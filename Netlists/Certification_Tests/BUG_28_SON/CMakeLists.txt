# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son1.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son2.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son3.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son3.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son3.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son3.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son3_noparams.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son3_noparams.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son3_globalp.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son3_globalp.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son4.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son4.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son4.cir.res.gs ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4.cir.res.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son4_1.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4_1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son4_2.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4_2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son4_3.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son4_3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son5.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son5.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son5.cir.res.gs ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5.cir.res.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son5_1.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5_1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son5_2.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5_2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug_28_son5_3.cir ${CMAKE_CURRENT_BINARY_DIR}/bug_28_son5_3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir COMMAND $<TARGET_FILE:Xyce> bug_28_son1.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir PROPERTIES FIXTURES_SETUP bug_28_son1.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir.verify COMMAND ${XYCE_VERIFY} bug_28_son1.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son1.cir.prn bug_28_son1.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir.verify PROPERTIES FIXTURES_REQUIRED bug_28_son1.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir.verify PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> bug_28_son1.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir PROPERTIES FIXTURES_SETUP bug_28_son1.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir.verify COMMAND ${XYCE_VERIFY} bug_28_son1.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son1.cir.prn bug_28_son1.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir.verify PROPERTIES FIXTURES_REQUIRED bug_28_son1.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son1.cir.verify PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir COMMAND $<TARGET_FILE:Xyce> bug_28_son2.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir PROPERTIES FIXTURES_SETUP bug_28_son2.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir.verify COMMAND ${XYCE_VERIFY} bug_28_son2.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son2.cir.prn bug_28_son2.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir.verify PROPERTIES FIXTURES_REQUIRED bug_28_son2.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir.verify PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> bug_28_son2.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir PROPERTIES FIXTURES_SETUP bug_28_son2.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir.verify COMMAND ${XYCE_VERIFY} bug_28_son2.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son2.cir.prn bug_28_son2.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir.verify PROPERTIES FIXTURES_REQUIRED bug_28_son2.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son2.cir.verify PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son3.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_28_son3.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug_28_son3.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son3.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son3.cir.sh PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son3.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_28_son3.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bug_28_son3.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son3.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son3.cir.sh PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son4.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_28_son4.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug_28_son4.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son4.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son4.cir.sh PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son4.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_28_son4.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bug_28_son4.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son4.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son4.cir.sh PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son5.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_28_son5.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} bug_28_son5.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son5.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son5.cir.sh PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son5.cir.sh COMMAND perl -I${XyceRegressionTestScripts} bug_28_son5.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} bug_28_son5.cir ${OutputDataDir}/Certification_Tests/BUG_28_SON/bug_28_son5.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_28_SON/bug_28_son5.cir.sh PROPERTY LABELS "serial;parallel;nightly;mutualinductor;bug28son")
endif()
