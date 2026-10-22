from classes.BchEncoder import *
from pysv import sv, DataType

class model:
    @sv()
    def __init__(self):
        # pass
        # global BchEncoder
        self.model = BchEncoder()

    @sv(w=DataType.Int, return_type=DataType.Int)
    def get_output(self, w):
        return w + 2
        # return self.model.get_output(w)
