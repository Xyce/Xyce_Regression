# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/baseline.cir ${CMAKE_CURRENT_BINARY_DIR}/baseline.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_46_son.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_46_son.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_46_son.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug_46_son.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_46_son.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/synonyms.cir ${CMAKE_CURRENT_BINARY_DIR}/synonyms.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_46_SON/bug_46_son.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_46_son.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug_46_son.cir ${OutputDataDir}/Certification_Tests/BUG_46_SON/bug_46_son.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_46_SON/bug_46_son.cir.sh PROPERTY LABELS "serial;nightly;diode")
endif()
