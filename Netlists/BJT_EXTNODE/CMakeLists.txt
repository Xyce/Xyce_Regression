# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn.cir ${CMAKE_CURRENT_BINARY_DIR}/npn.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/npn.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/npn.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn1.cir ${CMAKE_CURRENT_BINARY_DIR}/npn1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn2.cir ${CMAKE_CURRENT_BINARY_DIR}/npn2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rb_rc_re.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rb_rc_re.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rb_rc_re.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/npn_rb_rc_re.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/npn_rb_rc_re.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rb_rc_re_1.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rb_rc_re_1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rb_rc_re_2.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rb_rc_re_2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rb_rc_re_3.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rb_rc_re_3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rc_re.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rc_re.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rc_re.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/npn_rc_re.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/npn_rc_re.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rc_re_1.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rc_re_1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rc_re_2.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rc_re_2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/npn_rc_re_3.cir ${CMAKE_CURRENT_BINARY_DIR}/npn_rc_re_3.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}BJT_EXTNODE/npn.cir.sh COMMAND bash npn.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} npn.cir ${OutputDataDir}/BJT_EXTNODE/npn.cir.prn )
  set_property(TEST ${TestNamePrefix}BJT_EXTNODE/npn.cir.sh PROPERTY LABELS "nightly;serial;bjtlev1;bjt_extnode;resistor;isrc;dcsweep")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}BJT_EXTNODE/npn_rb_rc_re.cir.sh COMMAND bash npn_rb_rc_re.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} npn_rb_rc_re.cir ${OutputDataDir}/BJT_EXTNODE/npn_rb_rc_re.cir.prn )
  set_property(TEST ${TestNamePrefix}BJT_EXTNODE/npn_rb_rc_re.cir.sh PROPERTY LABELS "nightly;serial;bjtlev1;bjt_extnode;resistor;isrc;dcsweep")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}BJT_EXTNODE/npn_rc_re.cir.sh COMMAND bash npn_rc_re.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} npn_rc_re.cir ${OutputDataDir}/BJT_EXTNODE/npn_rc_re.cir.prn )
  set_property(TEST ${TestNamePrefix}BJT_EXTNODE/npn_rc_re.cir.sh PROPERTY LABELS "nightly;serial;bjtlev1;bjt_extnode;resistor;isrc;dcsweep")
endif()
