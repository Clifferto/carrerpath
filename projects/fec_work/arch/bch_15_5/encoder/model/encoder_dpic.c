#include <stdio.h>
#include <Python.h>
#include <svdpi.h>

// Global pointers to keep the Python object alive during simulation
PyObject *pInstance = NULL;

// Called during scoreboard build_phase to initialize Python
void create() {

    // Point to classes directory, It will automatically read your terminal's PYTHONPATH variable here.
    Py_Initialize();
    PyRun_SimpleString("import sys; sys.path.append('./classes'); print(sys.path, flush=True);");
    
    PyObject *pMain     = PyImport_AddModule("__main__");
    PyObject *pGlobals  = PyModule_GetDict(pMain);

    int status = PyRun_SimpleString(
        "from classes.BchEncoder import *; gf_base = GaloisField(1, 0b11); g = GaloisPoly(gf_base, [0, -1, 0, -1, -1, 0, 0, -1, 0, 0, 0]); encoder = BchEncoder(15, g)"
    );
    if (status) {
        // Python has already printed the traceback to stdout/stderr.
        // Optional: You can explicitly call PyErr_Print() to force-flush errors
        PyErr_Print(); 
    }

    // Look up the object reference by its variable name string
    pInstance = PyDict_GetItemString(pGlobals, "encoder");

    Py_DECREF(pMain);
    Py_DECREF(pGlobals);
}

// The function exported to SystemVerilog
int get_output(int word) {

    int result = 0;
    
    // Call the method natively
    // "process_data" = The name of the Python function inside the class
    // "ii"           = Format string meaning: "Expect 2 C integers as arguments"
    // data_a, data_b = The actual native C variables passed from SystemVerilog
    PyObject *pResult = PyObject_CallMethod(pInstance, "get_output", "i", word);
    if (pResult == NULL) {
        PyErr_Print();
        return -1;
    }

    // Convert the Python return value back into a native C type
    result = (int)PyLong_AsLong(pResult);

    Py_DECREF(pResult);

    return result;
}

// Clean up memory at the end of simulation
void cleanup() {

    if(pInstance) Py_DECREF(pInstance);
    Py_Finalize();
}

// Linker Error Root Cause:
// 
//     Vivado 2025.2: older version of the GNU Linker (binutils-2.37/bin/ld)
//     Modern Linux distributions: added a newer optimization called .relr.dyn packing inside /lib64/libm.so.6.
// 
//     Vivado older ld --> unknown type [0x13] section '.relr.dyn' --> fails to link your libdpi.so.
// 
// The Fix: Bypass Vivado's Linker
// 
//     cd /home/clifferto/tools/2025.2/Vivado/tps/lnx64/binutils-2.37/bin/
//     # 2. Rename the incompatible linker so Vivado can't find it
//     mv ld ld.backup
//     # 3. Create a symbolic link pointing to your OS system linker instead
//     ln -s /usr/bin/ld ld

// Install Python.h for DIP-C
// 
//      sudo dnf install python3-devel
//      Config vivado:
//          tools > settings > Simulation > Compilation > xsim.compile.xsc.more_options: --gcc_compile_options "-I/usr/include/python3.14"

// Config PYTHONPATH before launch vivado
// 
//      goto model directory
//      export PYTHONPATH=$PYTHONPATH:$(pwd)/classes
//      launch vivado
