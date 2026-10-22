# 1. Get the absolute path of this specific .tcl script file
set script_path [file dirname [info script]]

# 2. Set the PYTHONPATH to this exact folder
set classes_path "$script_path/classes"

# If PYTHONPATH exists append to it, else create it
if {[info exists ::env(PYTHONPATH)]} {
    set ::env(PYTHONPATH) "$::env(PYTHONPATH):$classes_path"
} else {
    set ::env(PYTHONPATH) $classes_path
}

puts "--- Universal Hook: PYTHONPATH added: $classes_path ---"
