# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/HBT_IV_nosweep.cir ${CMAKE_CURRENT_BINARY_DIR}/HBT_IV_nosweep.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1770/HBT_IV_nosweep.cir COMMAND $<TARGET_FILE:Xyce> HBT_IV_nosweep.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1770/HBT_IV_nosweep.cir PROPERTY LABELS "serial;nightly;vbic;voltlim;adms")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1770/HBT_IV_nosweep.cir PROPERTIES FIXTURES_SETUP HBT_IV_nosweep.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1770/HBT_IV_nosweep.cir.verify COMMAND ${XYCE_VERIFY} HBT_IV_nosweep.cir ${OutputDataDir}/Certification_Tests/BUG_1770/HBT_IV_nosweep.cir.prn HBT_IV_nosweep.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1770/HBT_IV_nosweep.cir.verify PROPERTIES FIXTURES_REQUIRED HBT_IV_nosweep.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1770/HBT_IV_nosweep.cir.verify PROPERTY LABELS "serial;nightly;vbic;voltlim;adms")
endif()
