from machine import Pin
from utime import sleep

maxlen = -1
maxpath = []
def chall4():
    O0 = Pin(0, Pin.IN)
    O1 = Pin(1, Pin.IN)
    O2 = Pin(2, Pin.IN)
    O3 = Pin(3, Pin.IN)
    I0 = Pin(4, Pin.OUT)
    I1 = Pin(5, Pin.OUT)
    I2 = Pin(6, Pin.OUT)
    I3 = Pin(7, Pin.OUT)

    RST = Pin(8, Pin.OUT)
    CLK = Pin(9, Pin.OUT)

    RST.off()
    CLK.off()

    def rst():
        RST.on()
        sleep(0.001)
        RST.off()
        sleep(0.001)

    def clk():
        CLK.on()
        sleep(0.001)
        CLK.off()
        sleep(0.001)

    def test(x):
        i0 = x & 1
        x >>= 1
        i1 = x & 1
        x >>= 1
        i2 = x & 1
        x >>= 1
        i3 = x & 1

        I0.on() if i0 else I0.off()
        I1.on() if i1 else I1.off()
        I2.on() if i2 else I2.off()
        I3.on() if i3 else I3.off()

        clk()

    rst()
    visited = [0]
    paths = {}
    adj = {i: {} for i in range(16)}


    def DFS(_path, _nodepath):
        global maxlen, maxpath
        if maxlen == 16:
            return
        for i in range(16):
            path = _path[:]
            nodepath = _nodepath[:]
            rst()
            for p in path:
                test(p)
            test(i)
            out = 0
            out += O3.value()
            out <<= 1
            out += O2.value()
            out <<= 1
            out += O1.value()
            out <<= 1
            out += O0.value()

            path.append(i)
            nodepath.append(out)
            if out != _nodepath[-1]:
                adj[_nodepath[-1]][out] = i
            if out not in visited:
                if len(nodepath) > maxlen:
                    print(path)
                    print(nodepath)
                    maxlen = len(nodepath)
                    maxpath = nodepath[:]
                paths[out] = path
                visited.append(out)
                DFS(path, nodepath)
                visited.remove(out)

    DFS([], [0])
    print(adj)
    rst()
    rst()
    currnode = 0
    winpath = maxpath[1:]
    print(len(set(winpath)) == 15 and 0 not in winpath)
    for p in winpath:
        print(currnode, "->", adj[currnode][p], "->", p)
        test(adj[currnode][p])
        currnode = p

    a = b''
    b = b''
    h = ''
    while not (a.endswith(b'}') or b.endswith(b'}')):
        clk()
        out = 0
        out += O0.value()
        out <<= 1
        out += O1.value()
        out <<= 1
        out += O2.value()
        out <<= 1
        out += O3.value()
        h += hex(out)[2:]
        if len(h) % 2:
            b = bytes.fromhex(h[1:])
        else:
            a = bytes.fromhex(h)
    print(a)
    print(b)

    assert b'ECSC{3xpl0r3_th3_gr4ph}' in a or b'ECSC{3xpl0r3_th3_gr4ph}' in b

chall4()
