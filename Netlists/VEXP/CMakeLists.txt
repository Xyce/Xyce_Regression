# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vexp.cir ${CMAKE_CURRENT_BINARY_DIR}/vexp.cir ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VEXP/vexp.cir COMMAND $<TARGET_FILE:Xyce> vexp.cir )
  set_property(TEST ${TestNamePrefix}VEXP/vexp.cir PROPERTY LABELS "serial;nightly;valgrind")
  set_tests_properties(${TestNamePrefix}VEXP/vexp.cir PROPERTIES FIXTURES_SETUP vexp.cir)
  add_test(NAME ${TestNamePrefix}VEXP/vexp.cir.verify COMMAND ${XYCE_VERIFY} vexp.cir ${OutputDataDir}/VEXP/vexp.cir.prn vexp.cir.prn )
  set_tests_properties(${TestNamePrefix}VEXP/vexp.cir.verify PROPERTIES FIXTURES_REQUIRED vexp.cir)
  set_property(TEST ${TestNamePrefix}VEXP/vexp.cir.verify PROPERTY LABELS "serial;nightly;valgrind")
endif()
