# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ADCOutputTest.cir ${CMAKE_CURRENT_BINARY_DIR}/ADCOutputTest.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir COMMAND $<TARGET_FILE:Xyce> ADCOutputTest.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir PROPERTY LABELS "serial;nightly;parallel")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir PROPERTIES FIXTURES_SETUP ADCOutputTest.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.verify COMMAND ${XYCE_VERIFY} ADCOutputTest.cir ${OutputDataDir}/Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.prn ADCOutputTest.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.verify PROPERTIES FIXTURES_REQUIRED ADCOutputTest.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.verify PROPERTY LABELS "serial;nightly;parallel")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> ADCOutputTest.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir PROPERTY LABELS "serial;nightly;parallel")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir PROPERTIES FIXTURES_SETUP ADCOutputTest.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.verify COMMAND ${XYCE_VERIFY} ADCOutputTest.cir ${OutputDataDir}/Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.prn ADCOutputTest.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.verify PROPERTIES FIXTURES_REQUIRED ADCOutputTest.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1067_SON/ADCOutputTest.cir.verify PROPERTY LABELS "serial;nightly;parallel")
endif()
