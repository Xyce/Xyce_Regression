# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tab_only_line.cir ${CMAKE_CURRENT_BINARY_DIR}/tab_only_line.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tab_only_line.cir.prn.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/tab_only_line.cir.prn.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/tab_only_line.cir.prn.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir COMMAND $<TARGET_FILE:Xyce> tab_only_line.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir PROPERTY LABELS "serial;nightly;valgrind")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir PROPERTIES FIXTURES_SETUP tab_only_line.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.gen_gs COMMAND perl tab_only_line.cir.prn.gs.pl tab_only_line.cir.prn)
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.gen_gs PROPERTIES FIXTURES_REQUIRED tab_only_line.cir)
set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.gen_gs PROPERTIES FIXTURES_SETUP tab_only_line.cir.gs)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.gen_gs PROPERTY LABELS "serial;nightly;valgrind")
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.verify COMMAND ${XYCE_VERIFY} tab_only_line.cir tab_only_line.cir.prn.gs tab_only_line.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.verify PROPERTIES FIXTURES_REQUIRED tab_only_line.cir.gs)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_156_SON/tab_only_line.cir.verify PROPERTY LABELS "serial;nightly;valgrind")
endif()
