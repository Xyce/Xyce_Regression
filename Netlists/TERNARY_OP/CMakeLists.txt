# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ternary_op.cir ${CMAKE_CURRENT_BINARY_DIR}/ternary_op.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ternary_op.cir.prn.gs.pl ${CMAKE_CURRENT_BINARY_DIR}/ternary_op.cir.prn.gs.pl ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/ternary_op.cir.prn.gs.pl PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}TERNARY_OP/ternary_op.cir COMMAND $<TARGET_FILE:Xyce> ternary_op.cir )
  set_property(TEST ${TestNamePrefix}TERNARY_OP/ternary_op.cir PROPERTY LABELS "serial;parallel;nightly;ternaryop;bsrc")
  set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir PROPERTIES FIXTURES_SETUP ternary_op.cir)
  add_test(NAME ${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs COMMAND perl ternary_op.cir.prn.gs.pl ternary_op.cir.prn)
  set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs PROPERTIES FIXTURES_REQUIRED ternary_op.cir)
set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs PROPERTIES FIXTURES_SETUP ternary_op.cir.gs)
  set_property(TEST ${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs PROPERTY LABELS "serial;parallel;nightly;ternaryop;bsrc")
  add_test(NAME ${TestNamePrefix}TERNARY_OP/ternary_op.cir.verify COMMAND ${XYCE_VERIFY} ternary_op.cir ternary_op.cir.prn.gs ternary_op.cir.prn )
  set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir.verify PROPERTIES FIXTURES_REQUIRED ternary_op.cir.gs)
  set_property(TEST ${TestNamePrefix}TERNARY_OP/ternary_op.cir.verify PROPERTY LABELS "serial;parallel;nightly;ternaryop;bsrc")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}TERNARY_OP/ternary_op.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> ternary_op.cir )
  set_property(TEST ${TestNamePrefix}TERNARY_OP/ternary_op.cir PROPERTY LABELS "serial;parallel;nightly;ternaryop;bsrc")
  set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir PROPERTIES FIXTURES_SETUP ternary_op.cir)
add_test(NAME ${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs COMMAND perl ternary_op.cir.prn.gs.pl ternary_op.cir.prn)
set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs PROPERTIES FIXTURES_REQUIRED ternary_op.cir)
set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs PROPERTIES FIXTURES_SETUP ternary_op.cir.gs)
  set_property(TEST ${TestNamePrefix}TERNARY_OP/ternary_op.cir.gen_gs PROPERTY LABELS "serial;parallel;nightly;ternaryop;bsrc")
add_test(NAME ${TestNamePrefix}TERNARY_OP/ternary_op.cir.verify COMMAND ${XYCE_VERIFY} ternary_op.cir ternary_op.cir.prn.gs ternary_op.cir.prn )
set_tests_properties(${TestNamePrefix}TERNARY_OP/ternary_op.cir.verify PROPERTIES FIXTURES_REQUIRED ternary_op.cir.gs)
  set_property(TEST ${TestNamePrefix}TERNARY_OP/ternary_op.cir.verify PROPERTY LABELS "serial;parallel;nightly;ternaryop;bsrc")
endif()
