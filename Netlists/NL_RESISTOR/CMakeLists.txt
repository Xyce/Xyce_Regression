# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/nlrcs10.cir ${CMAKE_CURRENT_BINARY_DIR}/nlrcs10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir COMMAND $<TARGET_FILE:Xyce> nlrcs10.cir )
  set_property(TEST ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir PROPERTY LABELS "serial;nightly;parallel;expression;valgrind;subckt;inductor;bsrc")
  set_tests_properties(${TestNamePrefix}NL_RESISTOR/nlrcs10.cir PROPERTIES FIXTURES_SETUP nlrcs10.cir)
  add_test(NAME ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir.verify COMMAND ${XYCE_VERIFY} nlrcs10.cir ${OutputDataDir}/NL_RESISTOR/nlrcs10.cir.prn nlrcs10.cir.prn )
  set_tests_properties(${TestNamePrefix}NL_RESISTOR/nlrcs10.cir.verify PROPERTIES FIXTURES_REQUIRED nlrcs10.cir)
  set_property(TEST ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir.verify PROPERTY LABELS "serial;nightly;parallel;expression;valgrind;subckt;inductor;bsrc")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> nlrcs10.cir )
  set_property(TEST ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir PROPERTY LABELS "serial;nightly;parallel;expression;valgrind;subckt;inductor;bsrc")
  set_tests_properties(${TestNamePrefix}NL_RESISTOR/nlrcs10.cir PROPERTIES FIXTURES_SETUP nlrcs10.cir)
  add_test(NAME ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir.verify COMMAND ${XYCE_VERIFY} nlrcs10.cir ${OutputDataDir}/NL_RESISTOR/nlrcs10.cir.prn nlrcs10.cir.prn )
  set_tests_properties(${TestNamePrefix}NL_RESISTOR/nlrcs10.cir.verify PROPERTIES FIXTURES_REQUIRED nlrcs10.cir)
  set_property(TEST ${TestNamePrefix}NL_RESISTOR/nlrcs10.cir.verify PROPERTY LABELS "serial;nightly;parallel;expression;valgrind;subckt;inductor;bsrc")
endif()
