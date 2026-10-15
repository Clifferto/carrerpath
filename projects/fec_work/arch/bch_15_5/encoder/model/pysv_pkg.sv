`ifndef PYSV_PYSV
`define PYSV_PYSV
package pysv;
import "DPI-C" function chandle GoldModel_pysv_init();
import "DPI-C" function int GoldModel_compute_expected(input chandle self,
                                                       input int a,
                                                       input int b);
import "DPI-C" function void GoldModel_destroy(input chandle self);
import "DPI-C" function void pysv_finalize();
class PySVObject;
chandle pysv_ptr;
endclass
class GoldModel extends PySVObject;
  function new();
    pysv_ptr = GoldModel_pysv_init();
  endfunction
  function int compute_expected(input int a,
                                input int b);
    return GoldModel_compute_expected(pysv_ptr, a, b);
  endfunction
  function void destroy();
    GoldModel_destroy(pysv_ptr);
  endfunction
endclass
endpackage
`endif // PYSV_PYSV
