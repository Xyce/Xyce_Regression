# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_nmos_bsim6.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_nmos_bsim6.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_pmos_bsim6.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_pmos_bsim6.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert_psp102.cir ${CMAKE_CURRENT_BINARY_DIR}/invert_psp102.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard_binned_bsim6.nmos ${CMAKE_CURRENT_BINARY_DIR}/modelcard_binned_bsim6.nmos ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard_binned_bsim6.pmos ${CMAKE_CURRENT_BINARY_DIR}/modelcard_binned_bsim6.pmos ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_n_bsimcmg107.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_n_bsimcmg107.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_n_bsimcmg108.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_n_bsimcmg108.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_n_bsimcmg110.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_n_bsimcmg110.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_n_bsimcmg111.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_n_bsimcmg111.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard107.nmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard107.nmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard108.nmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard108.nmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard110.nmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard110.nmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard111.nmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard111.nmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_p_bsimcmg107.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_p_bsimcmg107.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_p_bsimcmg108.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_p_bsimcmg108.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_p_bsimcmg110.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_p_bsimcmg110.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gummel_p_bsimcmg111.cir ${CMAKE_CURRENT_BINARY_DIR}/gummel_p_bsimcmg111.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard107.pmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard107.pmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard108.pmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard108.pmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard110.pmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard110.pmos_binned ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/modelcard111.pmos_binned ${CMAKE_CURRENT_BINARY_DIR}/modelcard111.pmos_binned ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir COMMAND $<TARGET_FILE:Xyce> gummel_n_bsimcmg107.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg107.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg107.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.prn gummel_n_bsimcmg107.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg107.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_n_bsimcmg107.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg107.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg107.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.prn gummel_n_bsimcmg107.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg107.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg107.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir COMMAND $<TARGET_FILE:Xyce> gummel_n_bsimcmg108.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg108.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg108.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.prn gummel_n_bsimcmg108.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg108.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_n_bsimcmg108.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg108.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg108.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.prn gummel_n_bsimcmg108.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg108.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg108.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir COMMAND $<TARGET_FILE:Xyce> gummel_n_bsimcmg110.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg110.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg110.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.prn gummel_n_bsimcmg110.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg110.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_n_bsimcmg110.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg110.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg110.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.prn gummel_n_bsimcmg110.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg110.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg110.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir COMMAND $<TARGET_FILE:Xyce> gummel_n_bsimcmg111.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg111.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg111.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.prn gummel_n_bsimcmg111.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg111.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_n_bsimcmg111.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir PROPERTIES FIXTURES_SETUP gummel_n_bsimcmg111.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.verify COMMAND ${XYCE_VERIFY} gummel_n_bsimcmg111.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.prn gummel_n_bsimcmg111.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_n_bsimcmg111.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_n_bsimcmg111.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir COMMAND $<TARGET_FILE:Xyce> gummel_nmos_bsim6.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir PROPERTIES FIXTURES_SETUP gummel_nmos_bsim6.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.verify COMMAND ${XYCE_VERIFY} gummel_nmos_bsim6.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.prn gummel_nmos_bsim6.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_nmos_bsim6.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_nmos_bsim6.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir PROPERTIES FIXTURES_SETUP gummel_nmos_bsim6.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.verify COMMAND ${XYCE_VERIFY} gummel_nmos_bsim6.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.prn gummel_nmos_bsim6.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_nmos_bsim6.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_nmos_bsim6.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir COMMAND $<TARGET_FILE:Xyce> gummel_p_bsimcmg107.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg107.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg107.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.prn gummel_p_bsimcmg107.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg107.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_p_bsimcmg107.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg107.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg107.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.prn gummel_p_bsimcmg107.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg107.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg107.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir COMMAND $<TARGET_FILE:Xyce> gummel_p_bsimcmg108.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg108.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg108.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.prn gummel_p_bsimcmg108.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg108.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_p_bsimcmg108.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg108.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg108.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.prn gummel_p_bsimcmg108.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg108.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg108.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir COMMAND $<TARGET_FILE:Xyce> gummel_p_bsimcmg110.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg110.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg110.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.prn gummel_p_bsimcmg110.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg110.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_p_bsimcmg110.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg110.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg110.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.prn gummel_p_bsimcmg110.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg110.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg110.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir COMMAND $<TARGET_FILE:Xyce> gummel_p_bsimcmg111.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg111.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg111.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.prn gummel_p_bsimcmg111.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg111.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_p_bsimcmg111.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir PROPERTIES FIXTURES_SETUP gummel_p_bsimcmg111.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.verify COMMAND ${XYCE_VERIFY} gummel_p_bsimcmg111.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.prn gummel_p_bsimcmg111.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_p_bsimcmg111.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_p_bsimcmg111.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir COMMAND $<TARGET_FILE:Xyce> gummel_pmos_bsim6.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir PROPERTIES FIXTURES_SETUP gummel_pmos_bsim6.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.verify COMMAND ${XYCE_VERIFY} gummel_pmos_bsim6.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.prn gummel_pmos_bsim6.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_pmos_bsim6.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> gummel_pmos_bsim6.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir PROPERTIES FIXTURES_SETUP gummel_pmos_bsim6.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.verify COMMAND ${XYCE_VERIFY} gummel_pmos_bsim6.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.prn gummel_pmos_bsim6.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.verify PROPERTIES FIXTURES_REQUIRED gummel_pmos_bsim6.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/gummel_pmos_bsim6.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir COMMAND $<TARGET_FILE:Xyce> invert_psp102.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir PROPERTIES FIXTURES_SETUP invert_psp102.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir.verify COMMAND ${XYCE_VERIFY} invert_psp102.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/invert_psp102.cir.prn invert_psp102.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir.verify PROPERTIES FIXTURES_REQUIRED invert_psp102.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> invert_psp102.cir )
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir PROPERTIES FIXTURES_SETUP invert_psp102.cir)
  add_test(NAME ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir.verify COMMAND ${XYCE_VERIFY} invert_psp102.cir ${OutputDataDir}/VERILOG_MODEL_BINNING/invert_psp102.cir.prn invert_psp102.cir.prn )
  set_tests_properties(${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir.verify PROPERTIES FIXTURES_REQUIRED invert_psp102.cir)
  set_property(TEST ${TestNamePrefix}VERILOG_MODEL_BINNING/invert_psp102.cir.verify PROPERTY LABELS "serial;parallel;nightly;adms;bsim6;psp102;bsimcmg;bsimcmg107;bsimcmg108;bsimcmg110;bsimcmg111;binning")
endif()
