# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/bug971.cir ${CMAKE_CURRENT_BINARY_DIR}/bug971.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invalid_parameter.cir ${CMAKE_CURRENT_BINARY_DIR}/invalid_parameter.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invalid_parameter.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/invalid_parameter.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/invalid_parameter.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invalid_parameter.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/invalid_parameter.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invalid_parameter.cir.options ${CMAKE_CURRENT_BINARY_DIR}/invalid_parameter.cir.options ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir COMMAND $<TARGET_FILE:Xyce> bug971.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir PROPERTY LABELS "nightly;serial;parallel")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir PROPERTIES FIXTURES_SETUP bug971.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir.verify COMMAND ${XYCE_VERIFY} bug971.cir ${OutputDataDir}/Certification_Tests/BUG_971_SON/bug971.cir.prn bug971.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir.verify PROPERTIES FIXTURES_REQUIRED bug971.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir.verify PROPERTY LABELS "nightly;serial;parallel")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> bug971.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir PROPERTY LABELS "nightly;serial;parallel")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir PROPERTIES FIXTURES_SETUP bug971.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir.verify COMMAND ${XYCE_VERIFY} bug971.cir ${OutputDataDir}/Certification_Tests/BUG_971_SON/bug971.cir.prn bug971.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir.verify PROPERTIES FIXTURES_REQUIRED bug971.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_971_SON/bug971.cir.verify PROPERTY LABELS "nightly;serial;parallel")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_971_SON/invalid_parameter.cir.sh COMMAND perl -I${XyceRegressionTestScripts} invalid_parameter.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} invalid_parameter.cir ${OutputDataDir}/Certification_Tests/BUG_971_SON/invalid_parameter.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_971_SON/invalid_parameter.cir.sh PROPERTY LABELS "nightly;serial;parallel;errorexit")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_971_SON/invalid_parameter.cir.sh COMMAND perl -I${XyceRegressionTestScripts} invalid_parameter.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} invalid_parameter.cir ${OutputDataDir}/Certification_Tests/BUG_971_SON/invalid_parameter.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_971_SON/invalid_parameter.cir.sh PROPERTY LABELS "nightly;serial;parallel;errorexit")
endif()
