# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ipulse.cir ${CMAKE_CURRENT_BINARY_DIR}/ipulse.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}IPULSE/ipulse.cir COMMAND $<TARGET_FILE:Xyce> ipulse.cir )
  set_property(TEST ${TestNamePrefix}IPULSE/ipulse.cir PROPERTY LABELS "serial;nightly;valgrind")
  set_tests_properties(${TestNamePrefix}IPULSE/ipulse.cir PROPERTIES FIXTURES_SETUP ipulse.cir)
  add_test(NAME ${TestNamePrefix}IPULSE/ipulse.cir.verify COMMAND ${XYCE_VERIFY} ipulse.cir ${OutputDataDir}/IPULSE/ipulse.cir.prn ipulse.cir.prn )
  set_tests_properties(${TestNamePrefix}IPULSE/ipulse.cir.verify PROPERTIES FIXTURES_REQUIRED ipulse.cir)
  set_property(TEST ${TestNamePrefix}IPULSE/ipulse.cir.verify PROPERTY LABELS "serial;nightly;valgrind")
endif()
