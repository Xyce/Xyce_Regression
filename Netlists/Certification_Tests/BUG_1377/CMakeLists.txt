# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README ${CMAKE_CURRENT_BINARY_DIR}/README ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Xmodelcard.nmos ${CMAKE_CURRENT_BINARY_DIR}/Xmodelcard.nmos ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/test1.X.cir ${CMAKE_CURRENT_BINARY_DIR}/test1.X.cir ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1377/test1.X.cir COMMAND $<TARGET_FILE:Xyce> test1.X.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1377/test1.X.cir PROPERTY LABELS "serial;nightly;bsim4")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1377/test1.X.cir PROPERTIES FIXTURES_SETUP test1.X.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1377/test1.X.cir.verify COMMAND ${XYCE_VERIFY} test1.X.cir ${OutputDataDir}/Certification_Tests/BUG_1377/test1.X.cir.prn test1.X.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1377/test1.X.cir.verify PROPERTIES FIXTURES_REQUIRED test1.X.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1377/test1.X.cir.verify PROPERTY LABELS "serial;nightly;bsim4")
endif()
