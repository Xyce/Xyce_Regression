# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug85son.cir ${CMAKE_CURRENT_BINARY_DIR}/bug85son.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir COMMAND $<TARGET_FILE:Xyce> bug85son.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir PROPERTY LABELS "serial;nightly;parallel")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir PROPERTIES FIXTURES_SETUP bug85son.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir.verify COMMAND ${XYCE_VERIFY} bug85son.cir ${OutputDataDir}/Certification_Tests/BUG_85_SON/bug85son.cir.prn bug85son.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir.verify PROPERTIES FIXTURES_REQUIRED bug85son.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir.verify PROPERTY LABELS "serial;nightly;parallel")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> bug85son.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir PROPERTY LABELS "serial;nightly;parallel")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir PROPERTIES FIXTURES_SETUP bug85son.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir.verify COMMAND ${XYCE_VERIFY} bug85son.cir ${OutputDataDir}/Certification_Tests/BUG_85_SON/bug85son.cir.prn bug85son.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir.verify PROPERTIES FIXTURES_REQUIRED bug85son.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_85_SON/bug85son.cir.verify PROPERTY LABELS "serial;nightly;parallel")
endif()
