# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README ${CMAKE_CURRENT_BINARY_DIR}/README ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/negtable.cir ${CMAKE_CURRENT_BINARY_DIR}/negtable.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1012/negtable.cir COMMAND $<TARGET_FILE:Xyce> negtable.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1012/negtable.cir PROPERTY LABELS "serial;nightly")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1012/negtable.cir PROPERTIES FIXTURES_SETUP negtable.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1012/negtable.cir.verify COMMAND ${XYCE_VERIFY} negtable.cir ${OutputDataDir}/Certification_Tests/BUG_1012/negtable.cir.prn negtable.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1012/negtable.cir.verify PROPERTIES FIXTURES_REQUIRED negtable.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1012/negtable.cir.verify PROPERTY LABELS "serial;nightly")
endif()
