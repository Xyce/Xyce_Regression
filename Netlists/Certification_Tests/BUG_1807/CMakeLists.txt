# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vbic_pnp_default.cir ${CMAKE_CURRENT_BINARY_DIR}/vbic_pnp_default.cir ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1807/vbic_pnp_default.cir COMMAND $<TARGET_FILE:Xyce> vbic_pnp_default.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1807/vbic_pnp_default.cir PROPERTY LABELS "serial;nightly;vbic;adms")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1807/vbic_pnp_default.cir PROPERTIES FIXTURES_SETUP vbic_pnp_default.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1807/vbic_pnp_default.cir.verify COMMAND ${XYCE_VERIFY} vbic_pnp_default.cir ${OutputDataDir}/Certification_Tests/BUG_1807/vbic_pnp_default.cir.prn vbic_pnp_default.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1807/vbic_pnp_default.cir.verify PROPERTIES FIXTURES_REQUIRED vbic_pnp_default.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1807/vbic_pnp_default.cir.verify PROPERTY LABELS "serial;nightly;vbic;adms")
endif()
