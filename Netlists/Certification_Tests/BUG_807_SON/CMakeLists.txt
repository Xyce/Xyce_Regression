# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ASU_45.txt ${CMAKE_CURRENT_BINARY_DIR}/ASU_45.txt ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/input_stage.cir ${CMAKE_CURRENT_BINARY_DIR}/input_stage.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inverter_transient_xyce.cir ${CMAKE_CURRENT_BINARY_DIR}/inverter_transient_xyce.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_807_SON/input_stage.cir COMMAND $<TARGET_FILE:Xyce> input_stage.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_807_SON/input_stage.cir PROPERTY LABELS "serial;weekly;valgrind;bsim4;bug807son")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_807_SON/input_stage.cir PROPERTIES FIXTURES_SETUP input_stage.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_807_SON/input_stage.cir.verify COMMAND ${XYCE_VERIFY} input_stage.cir ${OutputDataDir}/Certification_Tests/BUG_807_SON/input_stage.cir.prn input_stage.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_807_SON/input_stage.cir.verify PROPERTIES FIXTURES_REQUIRED input_stage.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_807_SON/input_stage.cir.verify PROPERTY LABELS "serial;weekly;valgrind;bsim4;bug807son")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir COMMAND $<TARGET_FILE:Xyce> inverter_transient_xyce.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir PROPERTY LABELS "serial;nightly;valgrind;bsim4;bug807son")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir PROPERTIES FIXTURES_SETUP inverter_transient_xyce.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir.verify COMMAND ${XYCE_VERIFY} inverter_transient_xyce.cir ${OutputDataDir}/Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir.prn inverter_transient_xyce.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir.verify PROPERTIES FIXTURES_REQUIRED inverter_transient_xyce.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_807_SON/inverter_transient_xyce.cir.verify PROPERTY LABELS "serial;nightly;valgrind;bsim4;bug807son")
endif()
