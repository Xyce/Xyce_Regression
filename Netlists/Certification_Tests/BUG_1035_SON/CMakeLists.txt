# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_simple_baseline.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_simple_baseline.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_simple_data.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_simple_data.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_simple_data.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RC_simple_data.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RC_simple_data.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr2.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr3.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr4.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr4.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr4_baseline.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr4_baseline.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_expr4.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr4.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_expr4.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_simple.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_simple.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_simple.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RC_simple.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RC_simple.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_simple.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/RC_simple.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_exprAlone.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_exprAlone.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_AC_data_exprAlone.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_exprAlone.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RC_AC_data_exprAlone.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/transLineDataGlobal_AC.cir ${CMAKE_CURRENT_BINARY_DIR}/transLineDataGlobal_AC.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/transLineDataGlobal_AC.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/transLineDataGlobal_AC.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/transLineDataGlobal_AC.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/transLineDataGlobal_AC.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/transLineDataGlobal_AC.cir.tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_AC_data_expr.cir.sh COMMAND perl -I${XyceRegressionTestScripts} RC_AC_data_expr.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RC_AC_data_expr.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/RC_AC_data_expr.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_AC_data_expr.cir.sh PROPERTY LABELS "serial;nightly;bug1035son;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_AC_data_expr4.cir.sh COMMAND perl -I${XyceRegressionTestScripts} RC_AC_data_expr4.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RC_AC_data_expr4.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/RC_AC_data_expr4.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_AC_data_expr4.cir.sh PROPERTY LABELS "serial;nightly;bug1035son;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_AC_data_exprAlone.cir.sh COMMAND perl -I${XyceRegressionTestScripts} RC_AC_data_exprAlone.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RC_AC_data_exprAlone.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/RC_AC_data_exprAlone.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_AC_data_exprAlone.cir.sh PROPERTY LABELS "serial;nightly;bug1035son;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_simple.cir.sh COMMAND perl -I${XyceRegressionTestScripts} RC_simple.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RC_simple.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/RC_simple.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_simple.cir.sh PROPERTY LABELS "serial;nightly;bug1035son;ac;test1035bug")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_simple_data.cir.sh COMMAND perl -I${XyceRegressionTestScripts} RC_simple_data.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RC_simple_data.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/RC_simple_data.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/RC_simple_data.cir.sh PROPERTY LABELS "serial;nightly;bug1035son;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/transLineDataGlobal_AC.cir.sh COMMAND perl -I${XyceRegressionTestScripts} transLineDataGlobal_AC.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} transLineDataGlobal_AC.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/transLineDataGlobal_AC.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/transLineDataGlobal_AC.cir.sh PROPERTY LABELS "serial;parallel;nightly;bug1035son;ac;test1035bug")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1035_SON/transLineDataGlobal_AC.cir.sh COMMAND perl -I${XyceRegressionTestScripts} transLineDataGlobal_AC.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} transLineDataGlobal_AC.cir ${OutputDataDir}/Certification_Tests/BUG_1035_SON/transLineDataGlobal_AC.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1035_SON/transLineDataGlobal_AC.cir.sh PROPERTY LABELS "serial;parallel;nightly;bug1035son;ac;test1035bug")
endif()
