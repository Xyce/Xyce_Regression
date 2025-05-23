# This test is hand coded due to the complexity of building ADMS plugins
# with an non-installed version of Xyce.  The "buildxyceplugin.sh" script
# and CMakeLists.txt file installed with Xyce for plugin support will not
# work with a version of Xyce that is still in the build directory.
#
# During the setup of Xyce with Cmake a CMake build script is created in 
# CMAKE_BINARY_DIR/utils/ADMS/InPlaceTesting/CMakeLists.txt 
# than can build the plugin objects.  
#
# One additional complexity that comes up is that the above CMakeLists.txt 
# file will generate Makefiles in the test directory.  Multiple tests running
# at the same time will overwrite each others Makefiles.  So each test builds 
# its plugins in a subdirectory. 


# First copy all of the original inputs to this local test directory.
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/DiodeClipper.cir ${CMAKE_CURRENT_BINARY_DIR}/DiodeClipper.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/DiodeClipper.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/DiodeClipper.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/DiodeClipper.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/DiodeClipper.cir.prn.gs ${CMAKE_CURRENT_BINARY_DIR}/DiodeClipper.cir.prn.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rlc_series.cir ${CMAKE_CURRENT_BINARY_DIR}/rlc_series.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rlc_series.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/rlc_series.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/rlc_series.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/rlc_series.cir.prn.gs ${CMAKE_CURRENT_BINARY_DIR}/rlc_series.cir.prn.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue396.cir ${CMAKE_CURRENT_BINARY_DIR}/Issue396.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue396.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Issue396.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Issue396.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue398.cir ${CMAKE_CURRENT_BINARY_DIR}/Issue398.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue398.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Issue398.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Issue398.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue398_AF.cir ${CMAKE_CURRENT_BINARY_DIR}/Issue398_AF.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue398_AF.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Issue398_AF.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Issue398_AF.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue399.cir ${CMAKE_CURRENT_BINARY_DIR}/Issue399.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Issue399.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Issue399.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Issue399.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Backlog106.cir ${CMAKE_CURRENT_BINARY_DIR}/Backlog106.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Backlog106.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Backlog106.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Backlog106.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Bugfix35_AF.cir ${CMAKE_CURRENT_BINARY_DIR}/Bugfix35_AF.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Bugfix35_AF.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Bugfix35_AF.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Bugfix35_AF.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Bugfix36_AF.cir ${CMAKE_CURRENT_BINARY_DIR}/Bugfix36_AF.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Bugfix36_AF.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/Bugfix36_AF.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/Bugfix36_AF.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527.cir ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527_2.cir ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527_2.cir.prn.gs ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_2.cir.prn.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527_2.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_2.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_2.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527_3.cir ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527_3.cir.prn.gs ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_3.cir.prn.gs ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/testBacklog527_3.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_3.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/testBacklog527_3.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/capacitor.va ${CMAKE_CURRENT_BINARY_DIR}/toys/capacitor.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/diode2.va ${CMAKE_CURRENT_BINARY_DIR}/toys/diode2.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/resistor.va ${CMAKE_CURRENT_BINARY_DIR}/toys/resistor.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/rlc2.va ${CMAKE_CURRENT_BINARY_DIR}/toys/rlc2.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/vsrc.va ${CMAKE_CURRENT_BINARY_DIR}/toys/vsrc.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/Issue396.va ${CMAKE_CURRENT_BINARY_DIR}/toys/Issue396.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/Issue398.va ${CMAKE_CURRENT_BINARY_DIR}/toys/Issue398.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/Issue398_AF.va ${CMAKE_CURRENT_BINARY_DIR}/toys/Issue398_AF.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/Issue399.va ${CMAKE_CURRENT_BINARY_DIR}/toys/Issue399.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/Bugfix35_AF.va ${CMAKE_CURRENT_BINARY_DIR}/toys/Bugfix35_AF.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/Bugfix36_AF.va ${CMAKE_CURRENT_BINARY_DIR}/toys/Bugfix36_AF.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/integer_var.va ${CMAKE_CURRENT_BINARY_DIR}/toys/integer_var.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/integer_var2.va ${CMAKE_CURRENT_BINARY_DIR}/toys/integer_var2.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/testBacklog527.va ${CMAKE_CURRENT_BINARY_DIR}/toys/testBacklog527.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/testBacklog527_2.va ${CMAKE_CURRENT_BINARY_DIR}/toys/testBacklog527_2.va ONLY_IF_DIFFERENT)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/toys)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/toys/testBacklog527_3.va ${CMAKE_CURRENT_BINARY_DIR}/toys/testBacklog527_3.va ONLY_IF_DIFFERENT)

# generate platform-specific xyceplugin library name
set(Xyce_PLUGIN_LIBRARY "${CMAKE_SHARED_LIBRARY_PREFIX}xyceplugin${CMAKE_SHARED_LIBRARY_SUFFIX}")

if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  # this test only makes a plugin.  It does not try to run a circuit as shown in the original test shell script Backlog106.cir.sh
  set(TESTING_SHORTNAME  "Backlog106")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/integer_var.va:../toys/integer_var2.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Backlog106.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Backlog106.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Backlog106.cir ${OutputDataDir}/VERILOGPLUGIN/Backlog106.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Backlog106.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  # this test only makes a plugin.  It does not try to run a circuit as shown in the original test shell script Bugfix35_AF.cir.sh
  set(TESTING_SHORTNAME  "Bugfix35_AF")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/Bugfix35_AF.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Bugfix35_AF.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Bugfix35_AF.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Bugfix35_AF.cir ${OutputDataDir}/VERILOGPLUGIN/Bugfix35_AF.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Bugfix35_AF.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND  )
  # this test only makes a plugin.  It does not try to run a circuit as shown in the original test shell script Bugfix36_AF.cir.sh
  set(TESTING_SHORTNAME  "Bugfix36_AF")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/Bugfix36_AF.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Bugfix36_AF.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Bugfix36_AF.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Bugfix36_AF.cir ${OutputDataDir}/VERILOGPLUGIN/Bugfix36_AF.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Bugfix36_AF.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  set(TESTING_SHORTNAME  "DiodeClipper")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${TESTING_SHORTNAME}.cir ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME}/${TESTING_SHORTNAME}.cir ONLY_IF_DIFFERENT)
  set(VAFILES "../toys/vsrc.va:../toys/capacitor.va:../toys/diode2.va:../toys/resistor.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun COMMAND $<TARGET_FILE:Xyce> -plugin ${Xyce_PLUGIN_LIBRARY}  DiodeClipper.cir WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify COMMAND perl ${XYCE_VERIFY} DiodeClipper.cir ../DiodeClipper.cir.prn.gs DiodeClipper.cir.prn WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP DiodeCliper_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED DiodeCliper_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP DiodeClilper_Plugin)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_REQUIRED DiodeClilper_Plugin )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_SETUP DiodeClilper_Output)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTIES FIXTURES_REQUIRED DiodeClilper_Output )
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  #add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/DiodeClipper.cir.sh COMMAND perl -I${XyceRegressionTestScripts} DiodeClipper.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} DiodeClipper.cir ${OutputDataDir}/VERILOGPLUGIN/DiodeClipper.cir.prn )
#  #set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/DiodeClipper.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  # this test only makes a plugin.  It does not try to run a circuit as shown in the original test shell script Issue396.cir.sh	
  set(TESTING_SHORTNAME  "Issue396")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/Issue396.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Issue396.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Issue396.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Issue396.cir ${OutputDataDir}/VERILOGPLUGIN/Issue396.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Issue396.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  # this test only makes a plugin.  It does not try to run a circuit as shown in the original test shell script Issue398.cir.sh	
  set(TESTING_SHORTNAME  "Issue398F")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/Issue398.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Issue398.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Issue398.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Issue398.cir ${OutputDataDir}/VERILOGPLUGIN/Issue398.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Issue398.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  # this test only makes a plugin.  It does not try to run a circuit as shown in the original test shell script Issue398_AF.cir.sh	
  set(TESTING_SHORTNAME  "Issue398_AF")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/Issue398_AF.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Issue398_AF.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Issue398_AF.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Issue398_AF.cir ${OutputDataDir}/VERILOGPLUGIN/Issue398_AF.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Issue398_AF.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  # this test errors when making a plugin.  It does not try to run a circuit as shown in the original test shell script Issue399.cir.sh	
  set(TESTING_SHORTNAME  "Issue399")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set(VAFILES "../toys/Issue399.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES WILL_FAIL TRUE )
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/Issue399.cir.sh COMMAND perl -I${XyceRegressionTestScripts} Issue399.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} Issue399.cir ${OutputDataDir}/VERILOGPLUGIN/Issue399.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/Issue399.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  set(TESTING_SHORTNAME  "rlc_series")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${TESTING_SHORTNAME}.cir ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME}/${TESTING_SHORTNAME}.cir ONLY_IF_DIFFERENT)
  set(VAFILES "../toys/rlc2.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun COMMAND $<TARGET_FILE:Xyce> -plugin ${Xyce_PLUGIN_LIBRARY}  rlc_series.cir WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify COMMAND perl ${XYCE_VERIFY} rlc_series.cir ../rlc_series.cir.prn.gs rlc_series.cir.prn WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Plugin)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Output)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Output )
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/rlc_series.cir.sh COMMAND perl -I${XyceRegressionTestScripts} rlc_series.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} rlc_series.cir ${OutputDataDir}/VERILOGPLUGIN/rlc_series.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/rlc_series.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI)  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  set(TESTING_SHORTNAME  "testBacklog527")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${TESTING_SHORTNAME}.cir ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME}/${TESTING_SHORTNAME}.cir ONLY_IF_DIFFERENT)
  set(VAFILES "../toys/testBacklog527.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun COMMAND $<TARGET_FILE:Xyce> -plugin ${Xyce_PLUGIN_LIBRARY}  testBacklog527.cir WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  #add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify COMMAND perl ${XYCE_VERIFY} testBacklog527.cir ../testBacklog527.cir.prn.gs testBacklog527.cir.prn WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Plugin )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Output)
  #set_property( TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTY LABELS "serial;parallel;nightly" )
  #set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Output )
endif()
#if( Xyce_PARALLEL_MPI AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/testBacklog527.cir.sh COMMAND perl -I${XyceRegressionTestScripts} testBacklog527.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} testBacklog527.cir ${OutputDataDir}/VERILOGPLUGIN/testBacklog527.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/testBacklog527.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  set(TESTING_SHORTNAME  "testBacklog527_2")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${TESTING_SHORTNAME}.cir ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME}/${TESTING_SHORTNAME}.cir ONLY_IF_DIFFERENT)
  set(VAFILES "../toys/testBacklog527_2.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun COMMAND $<TARGET_FILE:Xyce> -plugin ${Xyce_PLUGIN_LIBRARY}  testBacklog527_2.cir WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify COMMAND perl ${XYCE_VERIFY} testBacklog527_2.cir ../testBacklog527_2.cir.prn.gs testBacklog527_2.cir.prn WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Plugin)
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Output)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Output )
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/testBacklog527_2.cir.sh COMMAND perl -I${XyceRegressionTestScripts} testBacklog527_2.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} testBacklog527_2.cir ${OutputDataDir}/VERILOGPLUGIN/testBacklog527_2.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/testBacklog527_2.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
  set(TESTING_SHORTNAME  "testBacklog527_3")
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${TESTING_SHORTNAME}.cir ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME}/${TESTING_SHORTNAME}.cir ONLY_IF_DIFFERENT)
  set(VAFILES "../toys/testBacklog527_3.va")
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure COMMAND cmake  -DVERILOG_FILES="${VAFILES}" -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_BINARY_DIR}/utils/ADMS/InPlaceTesting/ WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build COMMAND cmake --build .  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun COMMAND $<TARGET_FILE:Xyce> -plugin ${Xyce_PLUGIN_LIBRARY}  testBacklog527_3.cir WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  add_test(NAME  ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify COMMAND perl ${XYCE_VERIFY} testBacklog527_3.cir ../testBacklog527_3.cir.prn.gs testBacklog527_3.cir.prn WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TESTING_SHORTNAME} )
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Configure PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Makefile)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Makefile )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Build PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Plugin)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTY LABELS "serial;parallel;nightly")
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Plugin )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_XyceRun PROPERTIES FIXTURES_SETUP ${TESTING_SHORTNAME}_Output)
  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTY LABELS "serial;parallel;nightly" )
  set_tests_properties( ${TestNamePrefix}VERILOGPLUGIN/${TESTING_SHORTNAME}_Verify PROPERTIES FIXTURES_REQUIRED ${TESTING_SHORTNAME}_Output )
endif()
#if( Xyce_PARALLEL_MPI  AND Xyce_PLUGIN_SUPPORT AND PERL_FOUND AND ADMSXML_FOUND )
#  add_test(NAME ${TestNamePrefix}VERILOGPLUGIN/testBacklog527_3.cir.sh COMMAND perl -I${XyceRegressionTestScripts} testBacklog527_3.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} testBacklog527_3.cir ${OutputDataDir}/VERILOGPLUGIN/testBacklog527_3.cir.prn )
#  set_property(TEST ${TestNamePrefix}VERILOGPLUGIN/testBacklog527_3.cir.sh PROPERTY LABELS "serial;parallel;nightly;required:buildplugin;required:installed")
#endif()
