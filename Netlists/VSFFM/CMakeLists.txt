# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vsffm.cir ${CMAKE_CURRENT_BINARY_DIR}/vsffm.cir ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VSFFM/vsffm.cir COMMAND $<TARGET_FILE:Xyce> vsffm.cir )
  set_property(TEST ${TestNamePrefix}VSFFM/vsffm.cir PROPERTY LABELS "serial;nightly;valgrind")
  set_tests_properties(${TestNamePrefix}VSFFM/vsffm.cir PROPERTIES FIXTURES_SETUP vsffm.cir)
  add_test(NAME ${TestNamePrefix}VSFFM/vsffm.cir.verify COMMAND ${XYCE_VERIFY} vsffm.cir ${OutputDataDir}/VSFFM/vsffm.cir.prn vsffm.cir.prn )
  set_tests_properties(${TestNamePrefix}VSFFM/vsffm.cir.verify PROPERTIES FIXTURES_REQUIRED vsffm.cir)
  set_property(TEST ${TestNamePrefix}VSFFM/vsffm.cir.verify PROPERTY LABELS "serial;nightly;valgrind")
endif()
