# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug805_all.cir ${CMAKE_CURRENT_BINARY_DIR}/bug805_all.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug805_all.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug805_all.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug805_all.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug805_top.cir ${CMAKE_CURRENT_BINARY_DIR}/bug805_top.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug805_top2.cir ${CMAKE_CURRENT_BINARY_DIR}/bug805_top2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/mil_test1.lib ${CMAKE_CURRENT_BINARY_DIR}/mil_test1.lib ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/mil_test2a.lib ${CMAKE_CURRENT_BINARY_DIR}/mil_test2a.lib ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/mil_test2b.lib ${CMAKE_CURRENT_BINARY_DIR}/mil_test2b.lib ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_805_SON/bug805_all.cir.sh COMMAND bash bug805_all.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug805_all.cir ${OutputDataDir}/Certification_Tests/BUG_805_SON/bug805_all.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_805_SON/bug805_all.cir.sh PROPERTY LABELS "serial;nightly;parallel")
endif()
if( Xyce_PARALLEL_MPI  AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_805_SON/bug805_all.cir.sh COMMAND bash bug805_all.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bug805_all.cir ${OutputDataDir}/Certification_Tests/BUG_805_SON/bug805_all.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_805_SON/bug805_all.cir.sh PROPERTY LABELS "serial;nightly;parallel")
endif()
