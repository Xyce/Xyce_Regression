# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README ${CMAKE_CURRENT_BINARY_DIR}/README ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/atanh_tanh.cir ${CMAKE_CURRENT_BINARY_DIR}/atanh_tanh.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_254/atanh_tanh.cir COMMAND $<TARGET_FILE:Xyce> atanh_tanh.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_254/atanh_tanh.cir PROPERTY LABELS "serial;nightly;atanh")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_254/atanh_tanh.cir PROPERTIES FIXTURES_SETUP atanh_tanh.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_254/atanh_tanh.cir.verify COMMAND ${XYCE_VERIFY} atanh_tanh.cir ${OutputDataDir}/Certification_Tests/BUG_254/atanh_tanh.cir.prn atanh_tanh.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_254/atanh_tanh.cir.verify PROPERTIES FIXTURES_REQUIRED atanh_tanh.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_254/atanh_tanh.cir.verify PROPERTY LABELS "serial;nightly;atanh")
endif()
