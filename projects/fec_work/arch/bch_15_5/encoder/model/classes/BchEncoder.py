import numpy as np
from classes.GaloisField import *
from classes.GaloisPoly import *

class BchEncoder:

    def __init__(self, n, gen_poly):
        self._n         = n
        self._k         = n - gen_poly._degree
        self._gen_poly  = gen_poly
        self._gf_base   = GaloisField(1, 0b11)

# =======================================================================================
# =======================================================================================
    def do_unpack(self, v, bit_width):
        v   = self._gf_base.do_unpack(v, bit_width=bit_width)
        ak  = [ELEMENT_ZERO if e == 0 else ELEMENT_ONE for e in v]
        return GaloisPoly(self._gf_base, ak)

    def do_pack(self, p, bit_width):
        if p._zero_poly:
            v   = 0
        else:
            p   = [ELEMENT_ZERO]*(bit_width-1 - p._degree) + p._coeff
            v   = [0 if ak == ELEMENT_ZERO else 1 for ak in p]
            v   = self._gf_base.do_pack(v)
        return v

    def encode(self, u):
        xp  = [ELEMENT_ONE] + [ELEMENT_ZERO]*(self._gen_poly._degree)
        xp  = GaloisPoly(self._gf_base, xp)
        v   = u*xp + (u*xp) % self._gen_poly
        return v

    def get_output(self, w):
        u   = self.do_unpack(w, bit_width=self._k)
        v   = self.encode(u)
        cw  = self.do_pack(v, bit_width=self._n)
        return cw
