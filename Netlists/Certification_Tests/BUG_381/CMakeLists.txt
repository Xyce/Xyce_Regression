# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README ${CMAKE_CURRENT_BINARY_DIR}/README ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_381.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_381.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_381.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug_381.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_381.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_5_-10.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_5_-10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_5_0.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_5_0.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_5_10.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_5_10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_6_-10.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_6_-10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_6_0.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_6_0.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_6_10.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_6_10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_7_-10.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_7_-10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_7_0.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_7_0.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator0_7_10.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator0_7_10.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator1.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator2.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/comparator3.cir ${CMAKE_CURRENT_BINARY_DIR}/comparator3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_381/bug_381.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_381.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug_381.cir ${OutputDataDir}/Certification_Tests/BUG_381/bug_381.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_381/bug_381.cir.sh PROPERTY LABELS "serial;nightly;parallel;step")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_381/bug_381.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_381.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bug_381.cir ${OutputDataDir}/Certification_Tests/BUG_381/bug_381.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_381/bug_381.cir.sh PROPERTY LABELS "serial;nightly;parallel;step")
endif()
