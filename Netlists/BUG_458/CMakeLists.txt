# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug458.cir ${CMAKE_CURRENT_BINARY_DIR}/bug458.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}BUG_458/bug458.cir COMMAND $<TARGET_FILE:Xyce> bug458.cir )
  set_property(TEST ${TestNamePrefix}BUG_458/bug458.cir PROPERTY LABELS "serial;nightly;inductor;valgrind")
  set_tests_properties(${TestNamePrefix}BUG_458/bug458.cir PROPERTIES FIXTURES_SETUP bug458.cir)
  add_test(NAME ${TestNamePrefix}BUG_458/bug458.cir.verify COMMAND ${XYCE_VERIFY} bug458.cir ${OutputDataDir}/BUG_458/bug458.cir.prn bug458.cir.prn )
  set_tests_properties(${TestNamePrefix}BUG_458/bug458.cir.verify PROPERTIES FIXTURES_REQUIRED bug458.cir)
  set_property(TEST ${TestNamePrefix}BUG_458/bug458.cir.verify PROPERTY LABELS "serial;nightly;inductor;valgrind")
endif()
