# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor.cir ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor.cir.prn.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir.prn.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir.prn.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor3.cir ${CMAKE_CURRENT_BINARY_DIR}/capacitor3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor3.cir.prn.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/capacitor3.cir.prn.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/capacitor3.cir.prn.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor3.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/capacitor3.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/capacitor3.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rc_osc.cir ${CMAKE_CURRENT_BINARY_DIR}/rc_osc.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rc_osc.cir.prn.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/rc_osc.cir.prn.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/rc_osc.cir.prn.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rc_osc.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/rc_osc.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/rc_osc.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ErrorMessageTest.cir ${CMAKE_CURRENT_BINARY_DIR}/ErrorMessageTest.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ErrorMessageTest.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/ErrorMessageTest.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/ErrorMessageTest.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ErrorMessageTest.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/ErrorMessageTest.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ErrorMessageTest.cir.options ${CMAKE_CURRENT_BINARY_DIR}/ErrorMessageTest.cir.options ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/ErrorMessageTest.cir.sh COMMAND perl -I${XyceRegressionTestScripts} ErrorMessageTest.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} ErrorMessageTest.cir ${OutputDataDir}/CAPACITOR/ErrorMessageTest.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/ErrorMessageTest.cir.sh PROPERTY LABELS "serial;parallel;nightly;capacitor;semicap;errorexit")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/ErrorMessageTest.cir.sh COMMAND perl -I${XyceRegressionTestScripts} ErrorMessageTest.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} ErrorMessageTest.cir ${OutputDataDir}/CAPACITOR/ErrorMessageTest.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/ErrorMessageTest.cir.sh PROPERTY LABELS "serial;parallel;nightly;capacitor;semicap;errorexit")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/capacitor.cir.sh COMMAND bash capacitor.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} capacitor.cir ${OutputDataDir}/CAPACITOR/capacitor.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/capacitor.cir.sh PROPERTY LABELS "serial;nightly;parallel;analytic;valgrind;capacitor")
endif()
if( Xyce_PARALLEL_MPI  AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/capacitor.cir.sh COMMAND bash capacitor.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} capacitor.cir ${OutputDataDir}/CAPACITOR/capacitor.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/capacitor.cir.sh PROPERTY LABELS "serial;nightly;parallel;analytic;valgrind;capacitor")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/capacitor3.cir.sh COMMAND bash capacitor3.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} capacitor3.cir ${OutputDataDir}/CAPACITOR/capacitor3.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/capacitor3.cir.sh PROPERTY LABELS "serial;nightly;parallel;analytic;valgrind;capacitor")
endif()
if( Xyce_PARALLEL_MPI  AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/capacitor3.cir.sh COMMAND bash capacitor3.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} capacitor3.cir ${OutputDataDir}/CAPACITOR/capacitor3.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/capacitor3.cir.sh PROPERTY LABELS "serial;nightly;parallel;analytic;valgrind;capacitor")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/rc_osc.cir.sh COMMAND bash rc_osc.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} rc_osc.cir ${OutputDataDir}/CAPACITOR/rc_osc.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/rc_osc.cir.sh PROPERTY LABELS "serial;nightly;parallel;analytic;valgrind;capacitor")
endif()
if( Xyce_PARALLEL_MPI  AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}CAPACITOR/rc_osc.cir.sh COMMAND bash rc_osc.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} rc_osc.cir ${OutputDataDir}/CAPACITOR/rc_osc.cir.prn )
  set_property(TEST ${TestNamePrefix}CAPACITOR/rc_osc.cir.sh PROPERTY LABELS "serial;nightly;parallel;analytic;valgrind;capacitor")
endif()
