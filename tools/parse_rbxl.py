#!/usr/bin/env python3
"""
Parser for Roblox binary .rbxl files (rbx-dom "Version 0" binary format).

Handles:
  * 32-byte file header
  * LZ4-compressed chunk bodies
  * SSTR / INST / PROP / PRNT / END chunks
  * Roblox data types incl. zigzag ints, byte interleaving, Roblox float format
"""
import struct, hashlib, sys, json

# ----------------------------------------------------------------------------
# Low-level helpers
# ----------------------------------------------------------------------------

def lz4_decompress(data):
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        token = data[i]; i += 1
        litlen = token >> 4
        if litlen == 15:
            while True:
                b = data[i]; i += 1
                litlen += b
                if b != 255:
                    break
        out += data[i:i+litlen]; i += litlen
        if i >= n:
            break
        offset = data[i] | (data[i+1] << 8); i += 2
        if offset == 0 or offset > len(out):
            raise ValueError(f"bad LZ4 offset {offset} at outlen {len(out)}")
        matchlen = token & 0x0F
        if matchlen == 15:
            while True:
                b = data[i]; i += 1
                matchlen += b
                if b != 255:
                    break
        matchlen += 4
        for _ in range(matchlen):
            out.append(out[-offset])
    return bytes(out)


def untransform_zigzag(u):
    """Untransform a Roblox-transformed integer (zigzag). u is the raw u32."""
    return (u >> 1) ^ -(u & 1)


def roblox_float_to_std(b):
    """Convert 4 Roblox-format float bytes (sign bit last, big-endian) to standard float."""
    v = int.from_bytes(b, 'big')
    v = ((v << 1) | (v >> 31)) & 0xFFFFFFFF
    return struct.unpack('>f', v.to_bytes(4, 'big'))[0]


# ----------------------------------------------------------------------------
# Reader over a decompressed chunk payload
# ----------------------------------------------------------------------------

class Reader:
    def __init__(self, buf):
        self.buf = buf
        self.pos = 0

    def u8(self):
        v = self.buf[self.pos]; self.pos += 1
        return v

    def bytes(self, n):
        v = self.buf[self.pos:self.pos+n]
        if len(v) != n:
            raise ValueError(f"short read at {self.pos}: wanted {n} got {len(v)}")
        self.pos += n
        return v

    def u16le(self):
        v = struct.unpack_from('<H', self.buf, self.pos)[0]; self.pos += 2
        return v

    def u32le(self):
        v = struct.unpack_from('<I', self.buf, self.pos)[0]; self.pos += 4
        return v

    def u32be(self):
        v = struct.unpack_from('>I', self.buf, self.pos)[0]; self.pos += 4
        return v

    def u64be(self):
        v = struct.unpack_from('>Q', self.buf, self.pos)[0]; self.pos += 8
        return v

    def f32le(self):
        v = struct.unpack_from('<f', self.buf, self.pos)[0]; self.pos += 4
        return v

    def f64le(self):
        v = struct.unpack_from('<d', self.buf, self.pos)[0]; self.pos += 8
        return v

    def string(self):
        """Untransformed u32 length + bytes."""
        n = self.u32le()
        return self.bytes(n)

    def remaining(self):
        return len(self.buf) - self.pos


# ----------------------------------------------------------------------------
# Chunk / value decoding
# ----------------------------------------------------------------------------

def decode_string(r):
    return r.string()


def decode_bool_array(r, n):
    return [r.u8() != 0 for _ in range(n)]


def decode_int32_array(r, n):
    """Big-endian zigzag ints, byte-interleaved."""
    if n == 0:
        return []
    raw = r.bytes(4 * n)
    vals = []
    for i in range(n):
        b = bytes(raw[j * n + i] for j in range(4))
        vals.append(untransform_zigzag(int.from_bytes(b, 'big')))
    return vals


def decode_int64_array(r, n):
    raw = r.bytes(8 * n)
    vals = []
    for i in range(n):
        b = bytes(raw[j * n + i] for j in range(8))
        vals.append(untransform_zigzag(int.from_bytes(b, 'big')))
    return vals


def decode_float32_array(r, n):
    """Roblox-format floats, big-endian, byte-interleaved."""
    if n == 0:
        return []
    raw = r.bytes(4 * n)
    return [roblox_float_to_std(bytes(raw[j * n + i] for j in range(4))) for i in range(n)]


def decode_float64_array(r, n):
    return [r.f64le() for _ in range(n)]


def decode_udim_array(r, n):
    scales = decode_float32_array(r, n)
    offsets = decode_int32_array(r, n)
    return list(zip(scales, offsets))


def decode_udim2_array(r, n):
    xs = decode_float32_array(r, n)
    ys = decode_float32_array(r, n)
    xo = decode_int32_array(r, n)
    yo = decode_int32_array(r, n)
    return [(xs[i], xo[i], ys[i], yo[i]) for i in range(n)]


def decode_ray_array(r, n):
    out = []
    for _ in range(n):
        out.append(tuple(r.f32le() for _ in range(6)))
    return out


def decode_brickcolor_array(r, n):
    if n == 0:
        return []
    raw = r.bytes(4 * n)
    return [int.from_bytes(bytes(raw[j * n + i] for j in range(4)), 'big') for i in range(n)]


def decode_color3_array(r, n):
    rr = decode_float32_array(r, n)
    gg = decode_float32_array(r, n)
    bb = decode_float32_array(r, n)
    return [(rr[i], gg[i], bb[i]) for i in range(n)]


def decode_vector2_array(r, n):
    xs = decode_float32_array(r, n)
    ys = decode_float32_array(r, n)
    return [(xs[i], ys[i]) for i in range(n)]


def decode_vector3_array(r, n):
    xs = decode_float32_array(r, n)
    ys = decode_float32_array(r, n)
    zs = decode_float32_array(r, n)
    return [(xs[i], ys[i], zs[i]) for i in range(n)]


def decode_vector2int16_array(r, n):
    out = []
    for _ in range(n):
        x = struct.unpack('<h', r.bytes(2))[0]
        y = struct.unpack('<h', r.bytes(2))[0]
        out.append((x, y))
    return out


def decode_vector3int16_array(r, n):
    out = []
    for _ in range(n):
        x = struct.unpack('<h', r.bytes(2))[0]
        y = struct.unpack('<h', r.bytes(2))[0]
        z = struct.unpack('<h', r.bytes(2))[0]
        out.append((x, y, z))
    return out


CFRAME_IDS = {
    0x02: (0, 0, 0), 0x03: (90, 0, 0), 0x05: (0, 180, 180), 0x06: (-90, 0, 0),
    0x07: (0, 180, 90), 0x09: (0, 90, 90), 0x0a: (0, 0, 90), 0x0c: (0, -90, 90),
    0x0d: (-90, -90, 0), 0x0e: (0, -90, 0), 0x10: (90, -90, 0), 0x11: (0, 90, 180),
    0x14: (0, 180, 0), 0x15: (-90, -180, 0), 0x17: (0, 0, 180), 0x18: (90, 180, 0),
    0x19: (0, 0, -90), 0x1b: (0, -90, -90), 0x1c: (0, -180, -90), 0x1e: (0, 90, -90),
    0x1f: (90, 90, 0), 0x20: (0, 90, 0), 0x22: (-90, 90, 0), 0x23: (0, -90, 180),
}


def decode_cframe_array(r, n):
    ids = []
    rots = []
    for _ in range(n):
        cid = r.u8()
        ids.append(cid)
        if cid == 0:
            rots.append([struct.unpack('<f', r.bytes(4))[0] for _ in range(9)])
        else:
            rots.append(CFRAME_IDS.get(cid, ('unknown-id', cid)))
    positions = decode_vector3_array(r, n)
    return [(ids[i], rots[i], positions[i]) for i in range(n)]


def decode_enum_array(r, n):
    if n == 0:
        return []
    raw = r.bytes(4 * n)
    return [int.from_bytes(bytes(raw[j * n + i] for j in range(4)), 'big') for i in range(n)]


def decode_referent_array(r, n):
    vals = decode_int32_array(r, n)
    acc = 0
    out = []
    for v in vals:
        acc += v
        out.append(acc)
    return out


def decode_numbersequence_array(r, n):
    out = []
    for _ in range(n):
        k = r.u32le()
        kps = []
        for _ in range(k):
            kps.append((r.f32le(), r.f32le(), r.f32le()))
        out.append(kps)
    return out


def decode_colorsequence_array(r, n):
    out = []
    for _ in range(n):
        k = r.u32le()
        kps = []
        for _ in range(k):
            t = r.f32le()
            c = (r.f32le(), r.f32le(), r.f32le())
            env = r.f32le()
            kps.append((t, c, env))
        out.append(kps)
    return out


def decode_numberrange_array(r, n):
    return [(r.f32le(), r.f32le()) for _ in range(n)]


def decode_rect_array(r, n):
    mx = decode_float32_array(r, n)
    my = decode_float32_array(r, n)
    xx = decode_float32_array(r, n)
    xy = decode_float32_array(r, n)
    return [(mx[i], my[i], xx[i], xy[i]) for i in range(n)]


def decode_physicalproperties_array(r, n):
    out = []
    for _ in range(n):
        bits = r.u8()
        if bits & 1:
            vals = [struct.unpack('<f', r.bytes(4))[0] for _ in range(5)]
            if bits & 2:
                vals.append(struct.unpack('<f', r.bytes(4))[0])
            out.append(tuple(vals))
        else:
            out.append(None)
    return out


def decode_color3uint8_array(r, n):
    rr = list(r.bytes(n))
    gg = list(r.bytes(n))
    bb = list(r.bytes(n))
    return [(rr[i], gg[i], bb[i]) for i in range(n)]


def decode_sharedstring_array(r, n, sstr):
    idxs = decode_enum_array(r, n)  # big-endian u32, interleaved
    return [sstr[i] if 0 <= i < len(sstr) else f"<bad sstr idx {i}>" for i in idxs]


def decode_uniqueid_array(r, n):
    out = []
    for _ in range(n):
        idx = r.u32le()
        tm = r.u32le()
        rnd = struct.unpack('<q', r.bytes(8))[0]
        out.append((idx, tm, rnd))
    return out


def decode_font_array(r, n):
    out = []
    for _ in range(n):
        fam = r.string()
        w = r.u16le()
        st = r.u8()
        cached = r.string()
        out.append((fam, w, st, cached))
    return out


def decode_content_array(r, n, sstr):
    # SourceTypes: series of u8 enums
    src = list(r.bytes(n))
    uricount = r.u32le()
    uris = [r.string() for _ in range(uricount)]
    objcount = r.u32le()
    objrefs = decode_referent_array(r, objcount)
    extcount = r.u32le()
    extrefs = decode_referent_array(r, extcount)
    out = []
    ui = 0
    oi = 0
    for s in src:
        if s == 0:
            out.append(None)
        elif s == 1:
            out.append(uris[ui]); ui += 1
        elif s == 2:
            out.append(('obj', objrefs[oi])); oi += 1
        else:
            out.append(f"<src {s}>")
    return out


def decode_optionalcframe_array(r, n, sstr):
    # preceded by type id 0x10 marker at chunk level, followed by bool array
    inner = r.u8()
    assert inner == 0x10, f"expected cframe marker 0x10, got {inner:#x}"
    cframes = decode_cframe_array(r, n)
    marker = r.u8()
    assert marker == 0x02, f"expected bool marker 0x02, got {marker:#x}"
    has = decode_bool_array(r, n)
    return [(cf, h) for cf, h in zip(cframes, has)]


PROP_DECODERS = {
    0x01: lambda r, n, s: [decode_string(r) for _ in range(n)],
    0x02: decode_bool_array,
    0x03: decode_int32_array,
    0x04: decode_float32_array,
    0x05: decode_float64_array,
    0x06: decode_udim_array,
    0x07: decode_udim2_array,
    0x08: decode_ray_array,
    0x09: lambda r, n, s: list(r.bytes(n)),
    0x0a: lambda r, n, s: list(r.bytes(n)),
    0x0b: decode_brickcolor_array,
    0x0c: decode_color3_array,
    0x0d: decode_vector2_array,
    0x0e: decode_vector3_array,
    0x0f: decode_vector2int16_array,
    0x10: decode_cframe_array,
    0x12: decode_enum_array,
    0x13: decode_referent_array,
    0x14: decode_vector3int16_array,
    0x15: decode_numbersequence_array,
    0x16: decode_colorsequence_array,
    0x17: decode_numberrange_array,
    0x18: decode_rect_array,
    0x19: decode_physicalproperties_array,
    0x1a: decode_color3uint8_array,
    0x1b: decode_int64_array,
    0x1c: decode_sharedstring_array,
    0x1d: lambda r, n, s: [decode_string(r) for _ in range(n)],
    0x1e: decode_optionalcframe_array,
    0x1f: decode_uniqueid_array,
    0x20: decode_font_array,
    0x22: decode_content_array,
}

TYPE_NAMES = {
    0x01: 'String', 0x02: 'Bool', 0x03: 'Int32', 0x04: 'Float32', 0x05: 'Float64',
    0x06: 'UDim', 0x07: 'UDim2', 0x08: 'Ray', 0x09: 'Faces', 0x0a: 'Axes',
    0x0b: 'BrickColor', 0x0c: 'Color3', 0x0d: 'Vector2', 0x0e: 'Vector3',
    0x0f: 'Vector2int16', 0x10: 'CFrame', 0x12: 'Enum', 0x13: 'Referent',
    0x14: 'Vector3int16', 0x15: 'NumberSequence', 0x16: 'ColorSequence',
    0x17: 'NumberRange', 0x18: 'Rect', 0x19: 'PhysicalProperties',
    0x1a: 'Color3uint8', 0x1b: 'Int64', 0x1c: 'SharedString', 0x1d: 'Bytecode',
    0x1e: 'OptionalCFrame', 0x1f: 'UniqueId', 0x20: 'Font', 0x22: 'Content',
}


# ----------------------------------------------------------------------------
# File parser
# ----------------------------------------------------------------------------

class RBXLFile:
    def __init__(self, path):
        self.path = path
        self.data = open(path, 'rb').read()
        self.parse()

    def parse(self):
        d = self.data
        assert d[:16] == b'<roblox!\x89\xff\r\n\x1a\n\x00\x00', "bad magic"
        self.version = struct.unpack_from('<H', d, 14)[0]
        self.class_count, self.instance_count = struct.unpack_from('<ii', d, 16)
        self.chunks = []
        off = 32
        while off < len(d):
            name = d[off:off+4].rstrip(b'\x00').decode()
            clen, ulen, res = struct.unpack_from('<III', d, off + 4)
            blob = d[off+16:off+16+clen] if clen else d[off+16:off+16+ulen]
            if clen:
                blob = lz4_decompress(blob)
            self.chunks.append({'name': name, 'compressed': bool(clen),
                                'uncompressed_len': ulen, 'data': blob})
            off += 16 + (clen if clen else ulen)
            if name == 'END':
                break
        self.parse_sstr()
        self.parse_inst()
        self.parse_prop()
        self.parse_prnt()

    def parse_sstr(self):
        self.sstr = []
        for c in self.chunks:
            if c['name'] != 'SSTR':
                continue
            r = Reader(c['data'])
            ver = r.u32le()
            cnt = r.u32le()
            for _ in range(cnt):
                md5 = r.bytes(16)
                s = decode_string(r)
                self.sstr.append(s)
            assert r.remaining() == 0

    def parse_inst(self):
        self.instances = {}   # referent -> dict(class, name, properties, parent)
        self.classes = {}     # classID -> {name, count, is_service, referents}
        for c in self.chunks:
            if c['name'] != 'INST':
                continue
            r = Reader(c['data'])
            class_id = r.u32le()
            class_name = decode_string(r)
            fmt = r.u8()
            count = r.u32le()
            refs = decode_referent_array(r, count)
            markers = []
            if fmt == 1:
                markers = list(r.bytes(count))
            assert r.remaining() == 0, f"INST leftover: {r.remaining()}"
            self.classes[class_id] = {
                'name': class_name, 'count': count, 'is_service': fmt == 1,
                'referents': refs, 'markers': markers,
            }
            for ref in refs:
                self.instances[ref] = {
                    'class': class_id, 'class_name': class_name,
                    'name': None, 'properties': {}, 'parent': None,
                }

    def parse_prop(self):
        for c in self.chunks:
            if c['name'] != 'PROP':
                continue
            r = Reader(c['data'])
            class_id = r.u32le()
            prop_name = decode_string(r)
            type_id = r.u8()
            cls = self.classes.get(class_id)
            n = cls['count'] if cls else 0
            dec = PROP_DECODERS.get(type_id)
            if dec is None:
                raise ValueError(f"unknown prop type {type_id} for {cls['name']}.{prop_name}")
            try:
                vals = dec(r, n, self.sstr)
            except TypeError:
                vals = dec(r, n)
            assert r.remaining() == 0, \
                f"PROP leftover {r.remaining()} for {cls['name']}.{prop_name} type {TYPE_NAMES.get(type_id)}"
            for ref, v in zip(cls['referents'], vals):
                self.instances[ref]['properties'][prop_name] = v
                if prop_name == b'Name' and isinstance(v, bytes):
                    self.instances[ref]['name'] = v

    def parse_prnt(self):
        for c in self.chunks:
            if c['name'] != 'PRNT':
                continue
            r = Reader(c['data'])
            ver = r.u8()
            cnt = r.u32le()
            children = decode_referent_array(r, cnt)
            parents = decode_referent_array(r, cnt)
            assert r.remaining() == 0
            for child, parent in zip(children, parents):
                if child in self.instances:
                    self.instances[child]['parent'] = parent
            # patch any instance whose referent isn't in PRNT? none expected
        self.roots = [ref for ref, inst in self.instances.items() if inst['parent'] is None]


# ----------------------------------------------------------------------------
# CLI
# ----------------------------------------------------------------------------

def main():
    path = sys.argv[1]
    rbxl = RBXLFile(path)
    print(f"file: {path}")
    print(f"format version: {rbxl.version}  classes: {rbxl.class_count}  instances: {rbxl.instance_count}")
    print(f"chunks: {len(rbxl.chunks)}  sstr strings: {len(rbxl.sstr)}")
    if len(sys.argv) > 2 and sys.argv[2] == '--dump':
        def dec(x):
            if isinstance(x, bytes):
                return x.decode('utf-8', 'replace')
            return x
        out = {
            'version': rbxl.version,
            'class_count': rbxl.class_count,
            'instance_count': rbxl.instance_count,
            'sstr': [s.decode('utf-8', 'replace') for s in rbxl.sstr],
            'instances': [
                {'ref': ref, 'class': dec(i['class_name']), 'name': dec(i['name']),
                 'parent': i['parent'],
                 'props': {dec(k): dec(v) for k, v in i['properties'].items()}}
                for ref, i in sorted(rbxl.instances.items())
            ],
        }
        with open(sys.argv[3], 'w') as f:
            json.dump(out, f, indent=1)
        print(f"wrote {sys.argv[3]}")


if __name__ == '__main__':
    main()
