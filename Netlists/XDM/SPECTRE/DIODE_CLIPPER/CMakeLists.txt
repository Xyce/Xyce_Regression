# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/diodeClipper.cir.spectre ${CMAKE_CURRENT_BINARY_DIR}/diodeClipper.cir.spectre ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/diodeClipper.cir ${CMAKE_CURRENT_BINARY_DIR}/diodeClipper.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/diodeClipper.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/diodeClipper.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/diodeClipper.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/D1N3940.scs ${CMAKE_CURRENT_BINARY_DIR}/D1N3940.scs ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND XDM_BDL_FOUND AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}XDM/SPECTRE/DIODE_CLIPPER/diodeClipper.cir.sh COMMAND perl -I${XyceRegressionTestScripts} diodeClipper.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} diodeClipper.cir ${OutputDataDir}/XDM/SPECTRE/DIODE_CLIPPER/diodeClipper.cir.prn )
  set_property(TEST ${TestNamePrefix}XDM/SPECTRE/DIODE_CLIPPER/diodeClipper.cir.sh PROPERTY LABELS "serial;nightly;required:xdm;spectre")
endif()
