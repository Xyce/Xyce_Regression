# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README ${CMAKE_CURRENT_BINARY_DIR}/README ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_460.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_460.cir.dat.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.dat.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.dat.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_460.cir.prn.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.prn.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.prn.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_460.cir.res.gs ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.res.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_460.cir.res.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.res.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.res.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_460.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_460.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_460/bug_460.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_460.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug_460.cir ${OutputDataDir}/Certification_Tests/BUG_460/bug_460.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_460/bug_460.cir.sh PROPERTY LABELS "serial;nightly;parallel;result;step;tecplot")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_460/bug_460.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_460.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bug_460.cir ${OutputDataDir}/Certification_Tests/BUG_460/bug_460.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_460/bug_460.cir.sh PROPERTY LABELS "serial;nightly;parallel;result;step;tecplot")
endif()
