lappend auto_path "C:/Program Files/lscc/diamond/3.13/data/script"
package require simulation_generation
set ::bali::simulation::Para(DEVICEFAMILYNAME) {MachXO2}
set ::bali::simulation::Para(PROJECT) {PizzaFPGA_SIM}
set ::bali::simulation::Para(PROJECTPATH) {F:/Gits/Challenge-154/src/PizzaFPGA}
set ::bali::simulation::Para(FILELIST) {"F:/Gits/Challenge-154/src/PizzaFPGA/vhdl/PRINT_FLAG.vhd" "F:/Gits/Challenge-154/src/PizzaFPGA/vhdl/FSM_CHALL.vhd" "F:/Gits/Challenge-154/src/PizzaFPGA/vhdl/TOP_ENTITY.vhd" "F:/Gits/Challenge-154/src/PizzaFPGA/vhdl/FPGA_testbench.vhd" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" }
set ::bali::simulation::Para(COMPLIST) {"VHDL" "VHDL" "VHDL" "VHDL" }
set ::bali::simulation::Para(LANGSTDLIST) {"" "" "" "" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_machxo2}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {FPGA_testbench}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {VHDL}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(INSTALLATIONPATH) {C:/Program Files/lscc/diamond/3.13}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(HDLPARAMETERS) {}
set ::bali::simulation::Para(POJO2LIBREFRESH)    {}
set ::bali::simulation::Para(POJO2MODELSIMLIB)   {}
::bali::simulation::ModelSim_Run
