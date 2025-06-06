# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/test_ekv26_nmos.cir ${CMAKE_CURRENT_BINARY_DIR}/test_ekv26_nmos.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/test_ekv26_pmos.cir ${CMAKE_CURRENT_BINARY_DIR}/test_ekv26_pmos.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inverter_transient_ekv26.cir ${CMAKE_CURRENT_BINARY_DIR}/inverter_transient_ekv26.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir COMMAND $<TARGET_FILE:Xyce> inverter_transient_ekv26.cir )
  set_property(TEST ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir PROPERTY LABELS "serial;parallel;nightly;ekv26")
  set_tests_properties(${TestNamePrefix}EKV26/inverter_transient_ekv26.cir PROPERTIES FIXTURES_SETUP inverter_transient_ekv26.cir)
  add_test(NAME ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir.verify COMMAND ${XYCE_VERIFY} inverter_transient_ekv26.cir ${OutputDataDir}/EKV26/inverter_transient_ekv26.cir.prn inverter_transient_ekv26.cir.prn )
  set_tests_properties(${TestNamePrefix}EKV26/inverter_transient_ekv26.cir.verify PROPERTIES FIXTURES_REQUIRED inverter_transient_ekv26.cir)
  set_property(TEST ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir.verify PROPERTY LABELS "serial;parallel;nightly;ekv26")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> inverter_transient_ekv26.cir )
  set_property(TEST ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir PROPERTY LABELS "serial;parallel;nightly;ekv26")
  set_tests_properties(${TestNamePrefix}EKV26/inverter_transient_ekv26.cir PROPERTIES FIXTURES_SETUP inverter_transient_ekv26.cir)
  add_test(NAME ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir.verify COMMAND ${XYCE_VERIFY} inverter_transient_ekv26.cir ${OutputDataDir}/EKV26/inverter_transient_ekv26.cir.prn inverter_transient_ekv26.cir.prn )
  set_tests_properties(${TestNamePrefix}EKV26/inverter_transient_ekv26.cir.verify PROPERTIES FIXTURES_REQUIRED inverter_transient_ekv26.cir)
  set_property(TEST ${TestNamePrefix}EKV26/inverter_transient_ekv26.cir.verify PROPERTY LABELS "serial;parallel;nightly;ekv26")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_nmos.cir COMMAND $<TARGET_FILE:Xyce> test_ekv26_nmos.cir )
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_nmos.cir PROPERTY LABELS "serial;parallel;nightly;ekv26")
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_nmos.cir PROPERTIES FIXTURES_SETUP test_ekv26_nmos.cir)
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_nmos.cir.verify COMMAND ${XYCE_VERIFY} test_ekv26_nmos.cir ${OutputDataDir}/EKV26/test_ekv26_nmos.cir.prn test_ekv26_nmos.cir.prn )
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_nmos.cir.verify PROPERTIES FIXTURES_REQUIRED test_ekv26_nmos.cir)
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_nmos.cir.verify PROPERTY LABELS "serial;parallel;nightly;ekv26")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_nmos.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> test_ekv26_nmos.cir )
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_nmos.cir PROPERTY LABELS "serial;parallel;nightly;ekv26")
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_nmos.cir PROPERTIES FIXTURES_SETUP test_ekv26_nmos.cir)
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_nmos.cir.verify COMMAND ${XYCE_VERIFY} test_ekv26_nmos.cir ${OutputDataDir}/EKV26/test_ekv26_nmos.cir.prn test_ekv26_nmos.cir.prn )
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_nmos.cir.verify PROPERTIES FIXTURES_REQUIRED test_ekv26_nmos.cir)
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_nmos.cir.verify PROPERTY LABELS "serial;parallel;nightly;ekv26")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_pmos.cir COMMAND $<TARGET_FILE:Xyce> test_ekv26_pmos.cir )
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_pmos.cir PROPERTY LABELS "serial;parallel;nightly;ekv26")
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_pmos.cir PROPERTIES FIXTURES_SETUP test_ekv26_pmos.cir)
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_pmos.cir.verify COMMAND ${XYCE_VERIFY} test_ekv26_pmos.cir ${OutputDataDir}/EKV26/test_ekv26_pmos.cir.prn test_ekv26_pmos.cir.prn )
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_pmos.cir.verify PROPERTIES FIXTURES_REQUIRED test_ekv26_pmos.cir)
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_pmos.cir.verify PROPERTY LABELS "serial;parallel;nightly;ekv26")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_pmos.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> test_ekv26_pmos.cir )
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_pmos.cir PROPERTY LABELS "serial;parallel;nightly;ekv26")
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_pmos.cir PROPERTIES FIXTURES_SETUP test_ekv26_pmos.cir)
  add_test(NAME ${TestNamePrefix}EKV26/test_ekv26_pmos.cir.verify COMMAND ${XYCE_VERIFY} test_ekv26_pmos.cir ${OutputDataDir}/EKV26/test_ekv26_pmos.cir.prn test_ekv26_pmos.cir.prn )
  set_tests_properties(${TestNamePrefix}EKV26/test_ekv26_pmos.cir.verify PROPERTIES FIXTURES_REQUIRED test_ekv26_pmos.cir)
  set_property(TEST ${TestNamePrefix}EKV26/test_ekv26_pmos.cir.verify PROPERTY LABELS "serial;parallel;nightly;ekv26")
endif()
