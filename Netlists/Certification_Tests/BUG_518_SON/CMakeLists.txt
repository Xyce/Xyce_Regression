# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug518.cir ${CMAKE_CURRENT_BINARY_DIR}/bug518.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_518_SON/bug518.cir COMMAND $<TARGET_FILE:Xyce> bug518.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_518_SON/bug518.cir PROPERTY LABELS "serial;nightly;inductor;mutualinductor;valgrind")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_518_SON/bug518.cir PROPERTIES FIXTURES_SETUP bug518.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_518_SON/bug518.cir.verify COMMAND ${XYCE_VERIFY} bug518.cir ${OutputDataDir}/Certification_Tests/BUG_518_SON/bug518.cir.prn bug518.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_518_SON/bug518.cir.verify PROPERTIES FIXTURES_REQUIRED bug518.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_518_SON/bug518.cir.verify PROPERTY LABELS "serial;nightly;inductor;mutualinductor;valgrind")
endif()
