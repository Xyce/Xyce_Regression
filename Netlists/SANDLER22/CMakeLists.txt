# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/sandler22.cir ${CMAKE_CURRENT_BINARY_DIR}/sandler22.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) )
  add_test(NAME ${TestNamePrefix}SANDLER22/sandler22.cir COMMAND $<TARGET_FILE:Xyce> sandler22.cir )
  set_property(TEST ${TestNamePrefix}SANDLER22/sandler22.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1;diode")
  set_tests_properties(${TestNamePrefix}SANDLER22/sandler22.cir PROPERTIES FIXTURES_SETUP sandler22.cir)
  add_test(NAME ${TestNamePrefix}SANDLER22/sandler22.cir.verify COMMAND ${XYCE_VERIFY} sandler22.cir ${OutputDataDir}/SANDLER22/sandler22.cir.prn sandler22.cir.prn )
  set_tests_properties(${TestNamePrefix}SANDLER22/sandler22.cir.verify PROPERTIES FIXTURES_REQUIRED sandler22.cir)
  set_property(TEST ${TestNamePrefix}SANDLER22/sandler22.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1;diode")
endif()
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}SANDLER22/sandler22.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> sandler22.cir )
  set_property(TEST ${TestNamePrefix}SANDLER22/sandler22.cir PROPERTY LABELS "serial;nightly;parallel;bjtlev1;diode")
  set_tests_properties(${TestNamePrefix}SANDLER22/sandler22.cir PROPERTIES FIXTURES_SETUP sandler22.cir)
  add_test(NAME ${TestNamePrefix}SANDLER22/sandler22.cir.verify COMMAND ${XYCE_VERIFY} sandler22.cir ${OutputDataDir}/SANDLER22/sandler22.cir.prn sandler22.cir.prn )
  set_tests_properties(${TestNamePrefix}SANDLER22/sandler22.cir.verify PROPERTIES FIXTURES_REQUIRED sandler22.cir)
  set_property(TEST ${TestNamePrefix}SANDLER22/sandler22.cir.verify PROPERTY LABELS "serial;nightly;parallel;bjtlev1;diode")
endif()
