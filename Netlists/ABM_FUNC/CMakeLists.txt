# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/func.cir ${CMAKE_CURRENT_BINARY_DIR}/func.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}ABM_FUNC/func.cir COMMAND $<TARGET_FILE:Xyce> func.cir )
  set_property(TEST ${TestNamePrefix}ABM_FUNC/func.cir PROPERTY LABELS "serial;nightly;valgrind;bsrc;expression;function;vpwl;resistor;transient")
  set_tests_properties(${TestNamePrefix}ABM_FUNC/func.cir PROPERTIES FIXTURES_SETUP func.cir)
  add_test(NAME ${TestNamePrefix}ABM_FUNC/func.cir.verify COMMAND ${XYCE_VERIFY} func.cir ${OutputDataDir}/ABM_FUNC/func.cir.prn func.cir.prn )
  set_tests_properties(${TestNamePrefix}ABM_FUNC/func.cir.verify PROPERTIES FIXTURES_REQUIRED func.cir)
  set_property(TEST ${TestNamePrefix}ABM_FUNC/func.cir.verify PROPERTY LABELS "serial;nightly;valgrind;bsrc;expression;function;vpwl;resistor;transient")
endif()
