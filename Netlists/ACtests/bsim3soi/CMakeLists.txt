# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/README ${CMAKE_CURRENT_BINARY_DIR}/README ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gain-stagesoi.cir ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gain-stagesoi.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gain-stagesoi_default.cir ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi_default.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gain-stagesoi_default.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi_default.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi_default.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/gain-stagesoi_default_spice.cir ${CMAKE_CURRENT_BINARY_DIR}/gain-stagesoi_default_spice.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/nmos_3_2.mod ${CMAKE_CURRENT_BINARY_DIR}/nmos_3_2.mod ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi.cir.sh COMMAND perl -I${XyceRegressionTestScripts} gain-stagesoi.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} gain-stagesoi.cir ${OutputDataDir}/ACtests/bsim3soi/gain-stagesoi.cir.prn )
  set_property(TEST ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi.cir.sh PROPERTY LABELS "serial;parallel;nightly;ac;b3soi;mos10;resistor;vsin")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi.cir.sh COMMAND perl -I${XyceRegressionTestScripts} gain-stagesoi.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} gain-stagesoi.cir ${OutputDataDir}/ACtests/bsim3soi/gain-stagesoi.cir.prn )
  set_property(TEST ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi.cir.sh PROPERTY LABELS "serial;parallel;nightly;ac;b3soi;mos10;resistor;vsin")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi_default.cir.sh COMMAND perl -I${XyceRegressionTestScripts} gain-stagesoi_default.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} gain-stagesoi_default.cir ${OutputDataDir}/ACtests/bsim3soi/gain-stagesoi_default.cir.prn )
  set_property(TEST ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi_default.cir.sh PROPERTY LABELS "serial;parallel;nightly;ac;b3soi;mos10;resistor;vsin")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi_default.cir.sh COMMAND perl -I${XyceRegressionTestScripts} gain-stagesoi_default.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} gain-stagesoi_default.cir ${OutputDataDir}/ACtests/bsim3soi/gain-stagesoi_default.cir.prn )
  set_property(TEST ${TestNamePrefix}ACtests/bsim3soi/gain-stagesoi_default.cir.sh PROPERTY LABELS "serial;parallel;nightly;ac;b3soi;mos10;resistor;vsin")
endif()
