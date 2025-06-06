# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/print.cir ${CMAKE_CURRENT_BINARY_DIR}/print.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/measure.cir ${CMAKE_CURRENT_BINARY_DIR}/measure.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/measure.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/measure.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/measure.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/measure.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/measure.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/four.cir ${CMAKE_CURRENT_BINARY_DIR}/four.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/four.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/four.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/four.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/four.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/four.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/result.cir ${CMAKE_CURRENT_BINARY_DIR}/result.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/result.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/result.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/result.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/result.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/result.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sens.cir ${CMAKE_CURRENT_BINARY_DIR}/sens.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sens.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/sens.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/sens.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sens.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/sens.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ic.cir ${CMAKE_CURRENT_BINARY_DIR}/ic.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ic.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/ic.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ic2.cir ${CMAKE_CURRENT_BINARY_DIR}/ic2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ic2.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/ic2.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/nodeset.cir ${CMAKE_CURRENT_BINARY_DIR}/nodeset.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/nodeset.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/nodeset.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/four.cir.sh COMMAND perl -I${XyceRegressionTestScripts} four.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} four.cir ${OutputDataDir}/Certification_Tests/BUG_1962/four.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/four.cir.sh PROPERTY LABELS "serial;parallel;nightly;fourier")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/four.cir.sh COMMAND perl -I${XyceRegressionTestScripts} four.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} four.cir ${OutputDataDir}/Certification_Tests/BUG_1962/four.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/four.cir.sh PROPERTY LABELS "serial;parallel;nightly;fourier")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir COMMAND $<TARGET_FILE:Xyce> ic.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir PROPERTY LABELS "serial;parallel;nightly;ic")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir PROPERTIES FIXTURES_SETUP ic.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir.verify COMMAND ${XYCE_VERIFY} ic.cir ${OutputDataDir}/Certification_Tests/BUG_1962/ic.cir.prn ic.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir.verify PROPERTIES FIXTURES_REQUIRED ic.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir.verify PROPERTY LABELS "serial;parallel;nightly;ic")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> ic.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir PROPERTY LABELS "serial;parallel;nightly;ic")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir PROPERTIES FIXTURES_SETUP ic.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir.verify COMMAND ${XYCE_VERIFY} ic.cir ${OutputDataDir}/Certification_Tests/BUG_1962/ic.cir.prn ic.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir.verify PROPERTIES FIXTURES_REQUIRED ic.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic.cir.verify PROPERTY LABELS "serial;parallel;nightly;ic")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir COMMAND $<TARGET_FILE:Xyce> ic2.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir PROPERTY LABELS "serial;parallel;nightly;ic")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir PROPERTIES FIXTURES_SETUP ic2.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir.verify COMMAND ${XYCE_VERIFY} ic2.cir ${OutputDataDir}/Certification_Tests/BUG_1962/ic2.cir.prn ic2.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir.verify PROPERTIES FIXTURES_REQUIRED ic2.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir.verify PROPERTY LABELS "serial;parallel;nightly;ic")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> ic2.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir PROPERTY LABELS "serial;parallel;nightly;ic")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir PROPERTIES FIXTURES_SETUP ic2.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir.verify COMMAND ${XYCE_VERIFY} ic2.cir ${OutputDataDir}/Certification_Tests/BUG_1962/ic2.cir.prn ic2.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir.verify PROPERTIES FIXTURES_REQUIRED ic2.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/ic2.cir.verify PROPERTY LABELS "serial;parallel;nightly;ic")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/measure.cir.sh COMMAND perl -I${XyceRegressionTestScripts} measure.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} measure.cir ${OutputDataDir}/Certification_Tests/BUG_1962/measure.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/measure.cir.sh PROPERTY LABELS "serial;parallel;nightly;measure")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/measure.cir.sh COMMAND perl -I${XyceRegressionTestScripts} measure.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} measure.cir ${OutputDataDir}/Certification_Tests/BUG_1962/measure.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/measure.cir.sh PROPERTY LABELS "serial;parallel;nightly;measure")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir COMMAND $<TARGET_FILE:Xyce> nodeset.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir PROPERTY LABELS "serial;parallel;nightly;nodeset")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir PROPERTIES FIXTURES_SETUP nodeset.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir.verify COMMAND ${XYCE_VERIFY} nodeset.cir ${OutputDataDir}/Certification_Tests/BUG_1962/nodeset.cir.prn nodeset.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir.verify PROPERTIES FIXTURES_REQUIRED nodeset.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir.verify PROPERTY LABELS "serial;parallel;nightly;nodeset")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> nodeset.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir PROPERTY LABELS "serial;parallel;nightly;nodeset")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir PROPERTIES FIXTURES_SETUP nodeset.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir.verify COMMAND ${XYCE_VERIFY} nodeset.cir ${OutputDataDir}/Certification_Tests/BUG_1962/nodeset.cir.prn nodeset.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir.verify PROPERTIES FIXTURES_REQUIRED nodeset.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/nodeset.cir.verify PROPERTY LABELS "serial;parallel;nightly;nodeset")
endif()
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir COMMAND $<TARGET_FILE:Xyce> print.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/print.cir PROPERTIES FIXTURES_SETUP print.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir.verify COMMAND ${XYCE_VERIFY} print.cir ${OutputDataDir}/Certification_Tests/BUG_1962/print.cir.prn print.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/print.cir.verify PROPERTIES FIXTURES_REQUIRED print.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir.verify PROPERTY LABELS "serial;parallel;nightly")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> print.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/print.cir PROPERTIES FIXTURES_SETUP print.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir.verify COMMAND ${XYCE_VERIFY} print.cir ${OutputDataDir}/Certification_Tests/BUG_1962/print.cir.prn print.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1962/print.cir.verify PROPERTIES FIXTURES_REQUIRED print.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/print.cir.verify PROPERTY LABELS "serial;parallel;nightly")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/result.cir.sh COMMAND perl -I${XyceRegressionTestScripts} result.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} result.cir ${OutputDataDir}/Certification_Tests/BUG_1962/result.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/result.cir.sh PROPERTY LABELS "serial;parallel;nightly;result")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/result.cir.sh COMMAND perl -I${XyceRegressionTestScripts} result.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} result.cir ${OutputDataDir}/Certification_Tests/BUG_1962/result.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/result.cir.sh PROPERTY LABELS "serial;parallel;nightly;result")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/sens.cir.sh COMMAND perl -I${XyceRegressionTestScripts} sens.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} sens.cir ${OutputDataDir}/Certification_Tests/BUG_1962/sens.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/sens.cir.sh PROPERTY LABELS "serial;parallel;nightly;sens")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1962/sens.cir.sh COMMAND perl -I${XyceRegressionTestScripts} sens.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} sens.cir ${OutputDataDir}/Certification_Tests/BUG_1962/sens.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1962/sens.cir.sh PROPERTY LABELS "serial;parallel;nightly;sens")
endif()
