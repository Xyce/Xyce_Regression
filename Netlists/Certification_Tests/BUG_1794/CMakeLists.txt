# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/onedevice.cir ${CMAKE_CURRENT_BINARY_DIR}/onedevice.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/tags ${CMAKE_CURRENT_BINARY_DIR}/tags ONLY_IF_DIFFERENT)
if( Xyce_PARALLEL_MPI  )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1794/onedevice.cir COMMAND mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce> onedevice.cir )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1794/onedevice.cir PROPERTY LABELS "parallel;nightly")
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1794/onedevice.cir PROPERTIES FIXTURES_SETUP onedevice.cir)
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_1794/onedevice.cir.verify COMMAND ${XYCE_VERIFY} onedevice.cir ${OutputDataDir}/Certification_Tests/BUG_1794/onedevice.cir.prn onedevice.cir.prn )
  set_tests_properties(${TestNamePrefix}Certification_Tests/BUG_1794/onedevice.cir.verify PROPERTIES FIXTURES_REQUIRED onedevice.cir)
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_1794/onedevice.cir.verify PROPERTY LABELS "parallel;nightly")
endif()
