# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bjt_test_nk.cir ${CMAKE_CURRENT_BINARY_DIR}/bjt_test_nk.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir COMMAND $<TARGET_FILE:Xyce> bjt_test_nk.cir )
  set_property(TEST ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind;pspicecompat;dcsweep")
  set_tests_properties(${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir PROPERTIES FIXTURES_SETUP bjt_test_nk.cir)
  add_test(NAME ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir.verify COMMAND ${XYCE_VERIFY} bjt_test_nk.cir ${OutputDataDir}/BJT_PSPICE_NK/bjt_test_nk.cir.prn bjt_test_nk.cir.prn )
  set_tests_properties(${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir.verify PROPERTIES FIXTURES_REQUIRED bjt_test_nk.cir)
  set_property(TEST ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind;pspicecompat;dcsweep")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> bjt_test_nk.cir )
  set_property(TEST ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind;pspicecompat;dcsweep")
  set_tests_properties(${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir PROPERTIES FIXTURES_SETUP bjt_test_nk.cir)
  add_test(NAME ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir.verify COMMAND ${XYCE_VERIFY} bjt_test_nk.cir ${OutputDataDir}/BJT_PSPICE_NK/bjt_test_nk.cir.prn bjt_test_nk.cir.prn )
  set_tests_properties(${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir.verify PROPERTIES FIXTURES_REQUIRED bjt_test_nk.cir)
  set_property(TEST ${TestNamePrefix}BJT_PSPICE_NK/bjt_test_nk.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1;valgrind;pspicecompat;dcsweep")
endif()
