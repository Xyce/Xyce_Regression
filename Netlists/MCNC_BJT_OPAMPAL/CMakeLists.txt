# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/opampal.cir ${CMAKE_CURRENT_BINARY_DIR}/opampal.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir COMMAND $<TARGET_FILE:Xyce> opampal.cir )
  set_property(TEST ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1")
  set_tests_properties(${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir PROPERTIES FIXTURES_SETUP opampal.cir)
  add_test(NAME ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir.verify COMMAND ${XYCE_VERIFY} opampal.cir ${OutputDataDir}/MCNC_BJT_OPAMPAL/opampal.cir.prn opampal.cir.prn )
  set_tests_properties(${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir.verify PROPERTIES FIXTURES_REQUIRED opampal.cir)
  set_property(TEST ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> opampal.cir )
  set_property(TEST ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1")
  set_tests_properties(${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir PROPERTIES FIXTURES_SETUP opampal.cir)
  add_test(NAME ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir.verify COMMAND ${XYCE_VERIFY} opampal.cir ${OutputDataDir}/MCNC_BJT_OPAMPAL/opampal.cir.prn opampal.cir.prn )
  set_tests_properties(${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir.verify PROPERTIES FIXTURES_REQUIRED opampal.cir)
  set_property(TEST ${TestNamePrefix}MCNC_BJT_OPAMPAL/opampal.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1")
endif()
