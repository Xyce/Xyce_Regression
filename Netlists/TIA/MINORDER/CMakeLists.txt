# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor.cir ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/capacitor.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/capacitor.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/invert.cir ${CMAKE_CURRENT_BINARY_DIR}/invert.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_VERBOSE_TIME AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}TIA/MINORDER/capacitor.cir.sh COMMAND perl -I${XyceRegressionTestScripts} capacitor.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} capacitor.cir ${OutputDataDir}/TIA/MINORDER/capacitor.cir.prn )
  set_property(TEST ${TestNamePrefix}TIA/MINORDER/capacitor.cir.sh PROPERTY LABELS "serial;nightly;newdae;required:verbose")
endif()
