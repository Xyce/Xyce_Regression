# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vpwl.cir ${CMAKE_CURRENT_BINARY_DIR}/vpwl.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vpwl.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/vpwl.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/vpwl.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vpwlRepeatFail.cir ${CMAKE_CURRENT_BINARY_DIR}/vpwlRepeatFail.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/options ${CMAKE_CURRENT_BINARY_DIR}/options ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_630_SON/vpwl.cir.sh COMMAND perl -I${XyceRegressionTestScripts} vpwl.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} vpwl.cir ${OutputDataDir}/Certification_Tests/BUG_630_SON/vpwl.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_630_SON/vpwl.cir.sh PROPERTY LABELS "serial;parallel;nightly;vpwl;pwl;errorexit")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_630_SON/vpwl.cir.sh COMMAND perl -I${XyceRegressionTestScripts} vpwl.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} vpwl.cir ${OutputDataDir}/Certification_Tests/BUG_630_SON/vpwl.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_630_SON/vpwl.cir.sh PROPERTY LABELS "serial;parallel;nightly;vpwl;pwl;errorexit")
endif()
