# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/test3.cir ${CMAKE_CURRENT_BINARY_DIR}/test3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/test3.cir.res.gs ${CMAKE_CURRENT_BINARY_DIR}/test3.cir.res.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir COMMAND $<TARGET_FILE:Xyce> test3.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir PROPERTY LABELS "serial;parallel;nightly;diode")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir PROPERTIES FIXTURES_SETUP test3.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir.verify COMMAND ${XYCE_VERIFY} test3.cir ${OutputDataDir}/Certification_Tests/BUG_1144_SON/test3.cir.prn test3.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir.verify PROPERTIES FIXTURES_REQUIRED test3.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir.verify PROPERTY LABELS "serial;parallel;nightly;diode")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> test3.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir PROPERTY LABELS "serial;parallel;nightly;diode")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir PROPERTIES FIXTURES_SETUP test3.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir.verify COMMAND ${XYCE_VERIFY} test3.cir ${OutputDataDir}/Certification_Tests/BUG_1144_SON/test3.cir.prn test3.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir.verify PROPERTIES FIXTURES_REQUIRED test3.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1144_SON/test3.cir.verify PROPERTY LABELS "serial;parallel;nightly;diode")
endif()
