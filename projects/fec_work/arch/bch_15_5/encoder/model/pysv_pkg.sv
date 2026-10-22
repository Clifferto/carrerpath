`ifndef PYSV_PYSV
`define PYSV_PYSV
package pysv;
import "DPI-C" function chandle model_pysv_init();
import "DPI-C" function void model_destroy(input chandle self);
import "DPI-C" function int model_get_output(input chandle self,
                                             input int w);
import "DPI-C" function void pysv_finalize();
class PySVObject;
chandle pysv_ptr;
endclass
class model extends PySVObject;
  function new();
    pysv_ptr = model_pysv_init();
  endfunction
  function void destroy();
    model_destroy(pysv_ptr);
  endfunction
  function int get_output(input int w);
    return model_get_output(pysv_ptr, w);
  endfunction
endclass
endpackage
`endif // PYSV_PYSV
