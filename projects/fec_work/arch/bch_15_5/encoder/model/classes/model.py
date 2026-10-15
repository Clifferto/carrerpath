# model.py
from pysv import sv, DataType, compile_lib, generate_sv_binding

class GoldModel:
    @sv()
    def __init__(self):
        self.internal_state = 0

    @sv(a=DataType.Int, b=DataType.Int, return_type=DataType.Int)
    def compute_expected(self, a, b):
        # Your complex Python/NumPy algorithm logic goes here
        self.internal_state += 1
        return (a * b) + self.internal_state