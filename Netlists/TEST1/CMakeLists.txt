# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/test1.cir ${CMAKE_CURRENT_BINARY_DIR}/test1.cir ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}TEST1/test1.cir COMMAND $<TARGET_FILE:Xyce> test1.cir )
  set_property(TEST ${TestNamePrefix}TEST1/test1.cir PROPERTY LABELS "serial;nightly;bsim3;valgrind")
  set_tests_properties(${TestNamePrefix}TEST1/test1.cir PROPERTIES FIXTURES_SETUP test1.cir)
  add_test(NAME ${TestNamePrefix}TEST1/test1.cir.verify COMMAND ${XYCE_VERIFY} test1.cir ${OutputDataDir}/TEST1/test1.cir.prn test1.cir.prn )
  set_tests_properties(${TestNamePrefix}TEST1/test1.cir.verify PROPERTIES FIXTURES_REQUIRED test1.cir)
  set_property(TEST ${TestNamePrefix}TEST1/test1.cir.verify PROPERTY LABELS "serial;nightly;bsim3;valgrind")
endif()
