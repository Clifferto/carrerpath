interface python_if();
    // Encapsulate raw DPI-C declarations inside the interface block
    import "DPI-C" function void create();
    import "DPI-C" function int get_output(int word);
    import "DPI-C" function void cleanup();

endinterface
