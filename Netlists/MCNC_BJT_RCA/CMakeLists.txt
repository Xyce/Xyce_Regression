# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rca.cir ${CMAKE_CURRENT_BINARY_DIR}/rca.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}MCNC_BJT_RCA/rca.cir COMMAND $<TARGET_FILE:Xyce> rca.cir )
  set_property(TEST ${TestNamePrefix}MCNC_BJT_RCA/rca.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind")
  set_tests_properties(${TestNamePrefix}MCNC_BJT_RCA/rca.cir PROPERTIES FIXTURES_SETUP rca.cir)
  add_test(NAME ${TestNamePrefix}MCNC_BJT_RCA/rca.cir.verify COMMAND ${XYCE_VERIFY} rca.cir ${OutputDataDir}/MCNC_BJT_RCA/rca.cir.prn rca.cir.prn )
  set_tests_properties(${TestNamePrefix}MCNC_BJT_RCA/rca.cir.verify PROPERTIES FIXTURES_REQUIRED rca.cir)
  set_property(TEST ${TestNamePrefix}MCNC_BJT_RCA/rca.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}MCNC_BJT_RCA/rca.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> rca.cir )
  set_property(TEST ${TestNamePrefix}MCNC_BJT_RCA/rca.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind")
  set_tests_properties(${TestNamePrefix}MCNC_BJT_RCA/rca.cir PROPERTIES FIXTURES_SETUP rca.cir)
  add_test(NAME ${TestNamePrefix}MCNC_BJT_RCA/rca.cir.verify COMMAND ${XYCE_VERIFY} rca.cir ${OutputDataDir}/MCNC_BJT_RCA/rca.cir.prn rca.cir.prn )
  set_tests_properties(${TestNamePrefix}MCNC_BJT_RCA/rca.cir.verify PROPERTIES FIXTURES_REQUIRED rca.cir)
  set_property(TEST ${TestNamePrefix}MCNC_BJT_RCA/rca.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind")
endif()
