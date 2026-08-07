# definitions for element ids, and representations
ELEMENT_ZERO    = -1
ELEMENT_ONE     = 0
ID_BIN          = 0
ID_POWER        = 1

class GaloisField:

    def __init__(self, m_order, primitive_poly):
        """
        Elements and operations to work in Galois fields. The zero element always is indexed as -1

        Args:
            m_order: Field order M
            primitive_poly: Bitfield representation of primitive poly powers. Ex: X**4 + X + 1 == 0b10011
        """
        self._m_order           = m_order
        self._primitive_poly    = primitive_poly
        self._cycle             = 2**self._m_order - 1
        self._elements          = []
        self.generate_field()

    def __call__(self, n):
        if n == -1:
            i = -1
        else:
            i = abs(n) % self._cycle

        return self._elements[i], i

    def __str__(self):
        info = f"{'='*128}\n"
        for e in self._elements: info += f"{e:0{self._m_order}b} -- {self._elements.index(e) if e!=0 else -1}\n"
        info += f"{'='*128}\n"

        return info

    def get_poly(self,e):
        """
        Get polynomial representation of a element

        Args:
            e: Field element
        """
        return [(e>>b) & 1 for b in range(self._m_order+1)]

    def generate_field(self):
        """
        Generate all the field elements for the given order and primitive poly. Zero element always added last
        """

        for i in range(2**self._m_order):
            # get all primitive elements (1, alpha, alpha**2..)
            if i < self._m_order:
                alpha_n_final = 1<<i
            # get the m element (alpha**m)
            elif i == self._m_order:
                alpha_n_final = self._primitive_poly & (2**self._m_order)-1
            # get the remaining elements
            else:
                # multiply last one by alpha (LRL), get polynomial representation, simplify
                alpha_n         = self._elements[-1]<<1
                alpha_n_poly    = self.get_poly(alpha_n)

                # simplify using know elements
                alpha_n_final = 0
                for i in range(len(alpha_n_poly)):
                    if alpha_n_poly[i]:
                        alpha_n_final ^= self._elements[i]

            if i > 0 and alpha_n_final==1:
                print(f"Field Closed Succesfully!, {len(self._elements)} Non-Zero Elements")
                break
            else:
                self._elements += [alpha_n_final]

        # complete the field with zero element
        self._elements += [0]
    
    def add(self, a, b):
        """
        Add two elements of the field

        Args:
            a: Power of 1st element
            b: Power of 2nd element

        Returns:
            tuple: (result, power)
        """
        ans = self(a)[0] ^ self(b)[0]
        i   = -1 if ans==0 else self._elements.index(ans)
        return self(i)

    def mul(self, a, b):
        """
        Multiply two elements of the field

        Args:
            a: Power of 1st factor
            b: Power of 2nd factor

        Returns:
            tuple: (result, power)
        """
        i   = -1 if a==-1 or b==-1 else (a+b) % self._cycle
        return self(i)

    def inv(self, a):
        """
        Get inverse of element

        Args:
            a: Power of element to invert

        Raises:
            ZeroDivisionError: When a == -1 == ZERO_ELEMENT

        Returns:
            tuple: (result, power)
        """
        if a == -1:
            raise ZeroDivisionError
        else:
            i   = (self._cycle - a) % self._cycle

        return self(i)

    def div(self, a, b):
        """
        Divide elements of the field

        Args:
            a: Power of numerator
            b: Power of denominator

        Returns:
            tuple: (result, power)
        """
        return self.mul(a, self.inv(b)[1])

    def pow(self, a, b):
        """
        Powers one elements to the given exponent

        Args:
            a: Power of the base
            b: Exponent

        Returns:
            tuple: (result, power)
        """
        if a == -1:
            i = -1
        elif b == -1:
            i = 0
        else:
            i = (a*abs(b)) % self._cycle

        return self(i)
