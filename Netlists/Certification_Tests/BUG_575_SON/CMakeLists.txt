# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug575son.cir ${CMAKE_CURRENT_BINARY_DIR}/bug575son.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir COMMAND $<TARGET_FILE:Xyce> bug575son.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir PROPERTY LABELS "serial;nightly;parallel;inductor;mutualinductor")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir PROPERTIES FIXTURES_SETUP bug575son.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir.verify COMMAND ${XYCE_VERIFY} bug575son.cir ${OutputDataDir}/Certification_Tests/BUG_575_SON/bug575son.cir.prn bug575son.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir.verify PROPERTIES FIXTURES_REQUIRED bug575son.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir.verify PROPERTY LABELS "serial;nightly;parallel;inductor;mutualinductor")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> bug575son.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir PROPERTY LABELS "serial;nightly;parallel;inductor;mutualinductor")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir PROPERTIES FIXTURES_SETUP bug575son.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir.verify COMMAND ${XYCE_VERIFY} bug575son.cir ${OutputDataDir}/Certification_Tests/BUG_575_SON/bug575son.cir.prn bug575son.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir.verify PROPERTIES FIXTURES_REQUIRED bug575son.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_575_SON/bug575son.cir.verify PROPERTY LABELS "serial;nightly;parallel;inductor;mutualinductor")
endif()
