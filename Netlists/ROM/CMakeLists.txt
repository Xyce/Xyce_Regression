# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

add_subdirectory(AUTODETECT)
add_subdirectory(AUTOSIZE)
add_subdirectory(MULTIPORT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder100.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder100.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder100_mor.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder100_mor.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder100_mor.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder100_mor.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder100_mor.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder100_mor.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder100_mor.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder_top10_mask1.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder_top10_mask1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder_top10_twolevel1.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder_top10_twolevel1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RC_ladder_top10_xyce.cir ${CMAKE_CURRENT_BINARY_DIR}/RC_ladder_top10_xyce.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder100.cir ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder100.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder100_mor.cir ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder100_mor.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder100_mor.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder100_mor.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder100_mor.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder100_mor.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder100_mor.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder_top30_mask1.cir ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder_top30_mask1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder_top30_twolevel1.cir ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder_top30_twolevel1.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/RLC_ladder_top30_xyce.cir ${CMAKE_CURRENT_BINARY_DIR}/RLC_ladder_top30_xyce.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cab_dak_sig_o_simple.cir ${CMAKE_CURRENT_BINARY_DIR}/cab_dak_sig_o_simple.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cab_dak_sig_o_simple_mor.cir ${CMAKE_CURRENT_BINARY_DIR}/cab_dak_sig_o_simple_mor.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cab_dak_sig_o_simple_mor.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/cab_dak_sig_o_simple_mor.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/cab_dak_sig_o_simple_mor.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cab_dak_sig_o_simple_mor.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/cab_dak_sig_o_simple_mor.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cab_dak_sig_o_simple_top2.cir ${CMAKE_CURRENT_BINARY_DIR}/cab_dak_sig_o_simple_top2.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/exclude ${CMAKE_CURRENT_BINARY_DIR}/exclude ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}ROM/RC_ladder100_mor.cir.sh COMMAND bash RC_ladder100_mor.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RC_ladder100_mor.cir ${OutputDataDir}/ROM/RC_ladder100_mor.cir.prn )
  set_property(TEST ${TestNamePrefix}ROM/RC_ladder100_mor.cir.sh PROPERTY LABELS "serial;parallel;nightly;rom;resistor;capacitor;inductor;ac")
endif()
if( Xyce_PARALLEL_MPI  AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}ROM/RC_ladder100_mor.cir.sh COMMAND bash RC_ladder100_mor.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} RC_ladder100_mor.cir ${OutputDataDir}/ROM/RC_ladder100_mor.cir.prn )
  set_property(TEST ${TestNamePrefix}ROM/RC_ladder100_mor.cir.sh PROPERTY LABELS "serial;parallel;nightly;rom;resistor;capacitor;inductor;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}ROM/RLC_ladder100_mor.cir.sh COMMAND bash RLC_ladder100_mor.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} RLC_ladder100_mor.cir ${OutputDataDir}/ROM/RLC_ladder100_mor.cir.prn )
  set_property(TEST ${TestNamePrefix}ROM/RLC_ladder100_mor.cir.sh PROPERTY LABELS "serial;parallel;nightly;rom;resistor;capacitor;inductor;ac")
endif()
if( Xyce_PARALLEL_MPI  AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}ROM/RLC_ladder100_mor.cir.sh COMMAND bash RLC_ladder100_mor.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} RLC_ladder100_mor.cir ${OutputDataDir}/ROM/RLC_ladder100_mor.cir.prn )
  set_property(TEST ${TestNamePrefix}ROM/RLC_ladder100_mor.cir.sh PROPERTY LABELS "serial;parallel;nightly;rom;resistor;capacitor;inductor;ac")
endif()
add_subdirectory(SPARSIFY)
if( (NOT Xyce_PARALLEL_MPI) AND BASH_FOUND )
  add_test(NAME ${TestNamePrefix}ROM/cab_dak_sig_o_simple_mor.cir.sh COMMAND bash cab_dak_sig_o_simple_mor.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} cab_dak_sig_o_simple_mor.cir ${OutputDataDir}/ROM/cab_dak_sig_o_simple_mor.cir.prn )
  set_property(TEST ${TestNamePrefix}ROM/cab_dak_sig_o_simple_mor.cir.sh PROPERTY LABELS "serial;rom;weekly;resistor;capacitor;inductor")
endif()
