# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bsim4_test1.cir ${CMAKE_CURRENT_BINARY_DIR}/bsim4_test1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bsim4_test1.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bsim4_test1.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bsim4_test1.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ASU_45.txt ${CMAKE_CURRENT_BINARY_DIR}/ASU_45.txt ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ASU_47.txt ${CMAKE_CURRENT_BINARY_DIR}/ASU_47.txt ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inverter_transient_xyce.cir ${CMAKE_CURRENT_BINARY_DIR}/inverter_transient_xyce.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inverter_transient_xyce.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/inverter_transient_xyce.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/inverter_transient_xyce.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inverter_transient_xyce_4.7.net ${CMAKE_CURRENT_BINARY_DIR}/inverter_transient_xyce_4.7.net ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bsim4_test1.cir ${CMAKE_CURRENT_BINARY_DIR}/bsim4_test1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bsim4_test1.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bsim4_test1.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bsim4_test1.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}BSIM4_Versioning/bsim4_test1.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bsim4_test1.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bsim4_test1.cir ${OutputDataDir}/BSIM4_Versioning/bsim4_test1.cir.prn )
  set_property(TEST ${TestNamePrefix}BSIM4_Versioning/bsim4_test1.cir.sh PROPERTY LABELS "serial;parallel;nightly;bsim4")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}BSIM4_Versioning/bsim4_test1.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bsim4_test1.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bsim4_test1.cir ${OutputDataDir}/BSIM4_Versioning/bsim4_test1.cir.prn )
  set_property(TEST ${TestNamePrefix}BSIM4_Versioning/bsim4_test1.cir.sh PROPERTY LABELS "serial;parallel;nightly;bsim4")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}BSIM4_Versioning/inverter_transient_xyce.cir.sh COMMAND perl -I${XyceRegressionTestScripts} inverter_transient_xyce.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} inverter_transient_xyce.cir ${OutputDataDir}/BSIM4_Versioning/inverter_transient_xyce.cir.prn )
  set_property(TEST ${TestNamePrefix}BSIM4_Versioning/inverter_transient_xyce.cir.sh PROPERTY LABELS "serial;parallel;nightly;bsim4")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}BSIM4_Versioning/inverter_transient_xyce.cir.sh COMMAND perl -I${XyceRegressionTestScripts} inverter_transient_xyce.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} inverter_transient_xyce.cir ${OutputDataDir}/BSIM4_Versioning/inverter_transient_xyce.cir.prn )
  set_property(TEST ${TestNamePrefix}BSIM4_Versioning/inverter_transient_xyce.cir.sh PROPERTY LABELS "serial;parallel;nightly;bsim4")
endif()
