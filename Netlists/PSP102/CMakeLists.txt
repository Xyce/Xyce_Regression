# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/idvg0_Id_T27.cir ${CMAKE_CURRENT_BINARY_DIR}/idvg0_Id_T27.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/idvg0_Id_T27_pmos.cir ${CMAKE_CURRENT_BINARY_DIR}/idvg0_Id_T27_pmos.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert_psp.cir ${CMAKE_CURRENT_BINARY_DIR}/invert_psp.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/psp102_outvars.cir ${CMAKE_CURRENT_BINARY_DIR}/psp102_outvars.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27.cir COMMAND $<TARGET_FILE:Xyce> idvg0_Id_T27.cir )
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27.cir PROPERTIES FIXTURES_SETUP idvg0_Id_T27.cir)
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27.cir.verify COMMAND ${XYCE_VERIFY} idvg0_Id_T27.cir ${OutputDataDir}/PSP102/idvg0_Id_T27.cir.prn idvg0_Id_T27.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27.cir.verify PROPERTIES FIXTURES_REQUIRED idvg0_Id_T27.cir)
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> idvg0_Id_T27.cir )
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27.cir PROPERTIES FIXTURES_SETUP idvg0_Id_T27.cir)
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27.cir.verify COMMAND ${XYCE_VERIFY} idvg0_Id_T27.cir ${OutputDataDir}/PSP102/idvg0_Id_T27.cir.prn idvg0_Id_T27.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27.cir.verify PROPERTIES FIXTURES_REQUIRED idvg0_Id_T27.cir)
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir COMMAND $<TARGET_FILE:Xyce> idvg0_Id_T27_pmos.cir )
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir PROPERTIES FIXTURES_SETUP idvg0_Id_T27_pmos.cir)
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir.verify COMMAND ${XYCE_VERIFY} idvg0_Id_T27_pmos.cir ${OutputDataDir}/PSP102/idvg0_Id_T27_pmos.cir.prn idvg0_Id_T27_pmos.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir.verify PROPERTIES FIXTURES_REQUIRED idvg0_Id_T27_pmos.cir)
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> idvg0_Id_T27_pmos.cir )
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir PROPERTIES FIXTURES_SETUP idvg0_Id_T27_pmos.cir)
  add_test(NAME ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir.verify COMMAND ${XYCE_VERIFY} idvg0_Id_T27_pmos.cir ${OutputDataDir}/PSP102/idvg0_Id_T27_pmos.cir.prn idvg0_Id_T27_pmos.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir.verify PROPERTIES FIXTURES_REQUIRED idvg0_Id_T27_pmos.cir)
  set_property(TEST ${TestNamePrefix}PSP102/idvg0_Id_T27_pmos.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}PSP102/invert_psp.cir COMMAND $<TARGET_FILE:Xyce> invert_psp.cir )
  set_property(TEST ${TestNamePrefix}PSP102/invert_psp.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/invert_psp.cir PROPERTIES FIXTURES_SETUP invert_psp.cir)
  add_test(NAME ${TestNamePrefix}PSP102/invert_psp.cir.verify COMMAND ${XYCE_VERIFY} invert_psp.cir ${OutputDataDir}/PSP102/invert_psp.cir.prn invert_psp.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/invert_psp.cir.verify PROPERTIES FIXTURES_REQUIRED invert_psp.cir)
  set_property(TEST ${TestNamePrefix}PSP102/invert_psp.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}PSP102/invert_psp.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> invert_psp.cir )
  set_property(TEST ${TestNamePrefix}PSP102/invert_psp.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/invert_psp.cir PROPERTIES FIXTURES_SETUP invert_psp.cir)
  add_test(NAME ${TestNamePrefix}PSP102/invert_psp.cir.verify COMMAND ${XYCE_VERIFY} invert_psp.cir ${OutputDataDir}/PSP102/invert_psp.cir.prn invert_psp.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/invert_psp.cir.verify PROPERTIES FIXTURES_REQUIRED invert_psp.cir)
  set_property(TEST ${TestNamePrefix}PSP102/invert_psp.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}PSP102/psp102_outvars.cir COMMAND $<TARGET_FILE:Xyce> psp102_outvars.cir )
  set_property(TEST ${TestNamePrefix}PSP102/psp102_outvars.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/psp102_outvars.cir PROPERTIES FIXTURES_SETUP psp102_outvars.cir)
  add_test(NAME ${TestNamePrefix}PSP102/psp102_outvars.cir.verify COMMAND ${XYCE_VERIFY} psp102_outvars.cir ${OutputDataDir}/PSP102/psp102_outvars.cir.prn psp102_outvars.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/psp102_outvars.cir.verify PROPERTIES FIXTURES_REQUIRED psp102_outvars.cir)
  set_property(TEST ${TestNamePrefix}PSP102/psp102_outvars.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}PSP102/psp102_outvars.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> psp102_outvars.cir )
  set_property(TEST ${TestNamePrefix}PSP102/psp102_outvars.cir PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
  set_tests_properties(${TestNamePrefix}PSP102/psp102_outvars.cir PROPERTIES FIXTURES_SETUP psp102_outvars.cir)
  add_test(NAME ${TestNamePrefix}PSP102/psp102_outvars.cir.verify COMMAND ${XYCE_VERIFY} psp102_outvars.cir ${OutputDataDir}/PSP102/psp102_outvars.cir.prn psp102_outvars.cir.prn )
  set_tests_properties(${TestNamePrefix}PSP102/psp102_outvars.cir.verify PROPERTIES FIXTURES_REQUIRED psp102_outvars.cir)
  set_property(TEST ${TestNamePrefix}PSP102/psp102_outvars.cir.verify PROPERTY LABELS "serial;parallel;nightly;psp102;adms")
endif()
