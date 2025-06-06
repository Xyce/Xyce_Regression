# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/correct_instance_parameters.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/correct_instance_parameters.cir ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/correct_instance_parameters.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/correct_instance_parameters_translation_inside_subckt.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters_translation_inside_subckt.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/correct_instance_parameters_translation_inside_subckt.cir ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters_translation_inside_subckt.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/correct_instance_parameters_translation_inside_subckt.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters_translation_inside_subckt.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/correct_instance_parameters_translation_inside_subckt.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor_model_statements.cir ${CMAKE_CURRENT_BINARY_DIR}/capacitor_model_statements.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor_model_statements.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/capacitor_model_statements.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor_model_statements.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/capacitor_model_statements.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/capacitor_model_statements.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inductor_model_statements.cir ${CMAKE_CURRENT_BINARY_DIR}/inductor_model_statements.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inductor_model_statements.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/inductor_model_statements.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inductor_model_statements.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/inductor_model_statements.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/inductor_model_statements.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/resistor_model_statements.cir ${CMAKE_CURRENT_BINARY_DIR}/resistor_model_statements.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/resistor_model_statements.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/resistor_model_statements.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/resistor_model_statements.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/resistor_model_statements.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/resistor_model_statements.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/model_level_translation.cir ${CMAKE_CURRENT_BINARY_DIR}/model_level_translation.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/model_level_translation.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/model_level_translation.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/model_level_translation.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/model_level_translation.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/model_level_translation.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/multiple_devices_same_model.cir ${CMAKE_CURRENT_BINARY_DIR}/multiple_devices_same_model.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/multiple_devices_same_model.cir.hspice ${CMAKE_CURRENT_BINARY_DIR}/multiple_devices_same_model.cir.hspice ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/multiple_devices_same_model.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/multiple_devices_same_model.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/multiple_devices_same_model.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/capacitor_model_statements.cir.sh COMMAND perl -I${XyceRegressionTestScripts} capacitor_model_statements.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} capacitor_model_statements.cir ${OutputDataDir}/XDM/HSPICE/MODELS/capacitor_model_statements.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/capacitor_model_statements.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/correct_instance_parameters.cir.sh COMMAND perl -I${XyceRegressionTestScripts} correct_instance_parameters.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} correct_instance_parameters.cir ${OutputDataDir}/XDM/HSPICE/MODELS/correct_instance_parameters.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/correct_instance_parameters.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/correct_instance_parameters_translation_inside_subckt.cir.sh COMMAND perl -I${XyceRegressionTestScripts} correct_instance_parameters_translation_inside_subckt.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} correct_instance_parameters_translation_inside_subckt.cir ${OutputDataDir}/XDM/HSPICE/MODELS/correct_instance_parameters_translation_inside_subckt.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/correct_instance_parameters_translation_inside_subckt.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/inductor_model_statements.cir.sh COMMAND perl -I${XyceRegressionTestScripts} inductor_model_statements.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} inductor_model_statements.cir ${OutputDataDir}/XDM/HSPICE/MODELS/inductor_model_statements.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/inductor_model_statements.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/model_level_translation.cir.sh COMMAND perl -I${XyceRegressionTestScripts} model_level_translation.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} model_level_translation.cir ${OutputDataDir}/XDM/HSPICE/MODELS/model_level_translation.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/model_level_translation.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/multiple_devices_same_model.cir.sh COMMAND perl -I${XyceRegressionTestScripts} multiple_devices_same_model.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} multiple_devices_same_model.cir ${OutputDataDir}/XDM/HSPICE/MODELS/multiple_devices_same_model.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/multiple_devices_same_model.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/HSPICE/MODELS/resistor_model_statements.cir.sh COMMAND perl -I${XyceRegressionTestScripts} resistor_model_statements.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} resistor_model_statements.cir ${OutputDataDir}/XDM/HSPICE/MODELS/resistor_model_statements.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/HSPICE/MODELS/resistor_model_statements.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;hspice")
endif()
