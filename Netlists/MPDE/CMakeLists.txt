# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

add_subdirectory(DCMIX_BAL)
add_subdirectory(FORCED_OSCILLATOR)
add_subdirectory(OPAMP)
add_subdirectory(RC)
add_subdirectory(RCDIODE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/converter.cir ${CMAKE_CURRENT_BINARY_DIR}/converter.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/converter.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/converter.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gilbert_cell_mpde.cir ${CMAKE_CURRENT_BINARY_DIR}/gilbert_cell_mpde.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert1.cir ${CMAKE_CURRENT_BINARY_DIR}/invert1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert1.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/invert1.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/invert1.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert1.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/invert1.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert1_MPDE.cir ${CMAKE_CURRENT_BINARY_DIR}/invert1_MPDE.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sandler24.cir ${CMAKE_CURRENT_BINARY_DIR}/sandler24.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sandler24.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/sandler24.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/sandler24.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sandler24.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/sandler24.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sandler24_MPDE.cir ${CMAKE_CURRENT_BINARY_DIR}/sandler24_MPDE.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}MPDE/invert1.cir.sh COMMAND perl -I${XyceRegressionTestScripts} invert1.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} invert1.cir ${OutputDataDir}/MPDE/invert1.cir.prn )
  set_property(TEST ${TestNamePrefix}MPDE/invert1.cir.sh PROPERTY LABELS "serial;parallel;nightly;mos1;mpde;valgrind")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}MPDE/invert1.cir.sh COMMAND perl -I${XyceRegressionTestScripts} invert1.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} invert1.cir ${OutputDataDir}/MPDE/invert1.cir.prn )
  set_property(TEST ${TestNamePrefix}MPDE/invert1.cir.sh PROPERTY LABELS "serial;parallel;nightly;mos1;mpde;valgrind")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}MPDE/sandler24.cir.sh COMMAND perl -I${XyceRegressionTestScripts} sandler24.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} sandler24.cir ${OutputDataDir}/MPDE/sandler24.cir.prn )
  set_property(TEST ${TestNamePrefix}MPDE/sandler24.cir.sh PROPERTY LABELS "serial;parallel;nightly;bjtlev1;diode;mpde;valgrind")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}MPDE/sandler24.cir.sh COMMAND perl -I${XyceRegressionTestScripts} sandler24.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} sandler24.cir ${OutputDataDir}/MPDE/sandler24.cir.prn )
  set_property(TEST ${TestNamePrefix}MPDE/sandler24.cir.sh PROPERTY LABELS "serial;parallel;nightly;bjtlev1;diode;mpde;valgrind")
endif()
