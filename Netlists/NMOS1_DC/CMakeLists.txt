# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/nmos1.cir ${CMAKE_CURRENT_BINARY_DIR}/nmos1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}NMOS1_DC/nmos1.cir COMMAND $<TARGET_FILE:Xyce> nmos1.cir )
  set_property(TEST ${TestNamePrefix}NMOS1_DC/nmos1.cir PROPERTY LABELS "serial;nightly;mos1;valgrind")
  set_tests_properties(${TestNamePrefix}NMOS1_DC/nmos1.cir PROPERTIES FIXTURES_SETUP nmos1.cir)
  add_test(NAME ${TestNamePrefix}NMOS1_DC/nmos1.cir.verify COMMAND ${XYCE_VERIFY} nmos1.cir ${OutputDataDir}/NMOS1_DC/nmos1.cir.prn nmos1.cir.prn )
  set_tests_properties(${TestNamePrefix}NMOS1_DC/nmos1.cir.verify PROPERTIES FIXTURES_REQUIRED nmos1.cir)
  set_property(TEST ${TestNamePrefix}NMOS1_DC/nmos1.cir.verify PROPERTY LABELS "serial;nightly;mos1;valgrind")
endif()
