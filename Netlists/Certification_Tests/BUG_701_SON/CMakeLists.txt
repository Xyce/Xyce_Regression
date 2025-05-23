# This file is generated by the script SetUpCtestFiles.py
# If possible, modify the script to fix any issues with the CMakeLists.txt files
# Or you can remove this header line to prevent this file from being overwritten

file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files.cir ${CMAKE_CURRENT_BINARY_DIR}/ac_files.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/ac_files.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/ac_files.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files_fallback.cir ${CMAKE_CURRENT_BINARY_DIR}/ac_files_fallback.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/ac_files.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files_csv.cir ${CMAKE_CURRENT_BINARY_DIR}/ac_files_csv.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files_csv.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/ac_files_csv.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/ac_files_csv.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files_fallback_csv.cir ${CMAKE_CURRENT_BINARY_DIR}/ac_files_fallback_csv.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/ac_files_csv.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/ac_files_csv.cir.tags ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/hb_files_csv.cir ${CMAKE_CURRENT_BINARY_DIR}/hb_files_csv.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/hb_files_csv.cir.sh ${CMAKE_CURRENT_BINARY_DIR}/hb_files_csv.cir.sh ONLY_IF_DIFFERENT)
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/hb_files_csv.cir.sh PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/hb_files_fallback_csv.cir ${CMAKE_CURRENT_BINARY_DIR}/hb_files_fallback_csv.cir ONLY_IF_DIFFERENT)
file(COPY_FILE ${CMAKE_CURRENT_SOURCE_DIR}/hb_files_csv.cir.tags ${CMAKE_CURRENT_BINARY_DIR}/hb_files_csv.cir.tags ONLY_IF_DIFFERENT)
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files.cir.sh COMMAND perl -I${XyceRegressionTestScripts} ac_files.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} ac_files.cir ${OutputDataDir}/Certification_Tests/BUG_701_SON/ac_files.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files.cir.sh PROPERTY LABELS "serial;nightly;parallel;output;ac")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files.cir.sh COMMAND perl -I${XyceRegressionTestScripts} ac_files.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} ac_files.cir ${OutputDataDir}/Certification_Tests/BUG_701_SON/ac_files.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files.cir.sh PROPERTY LABELS "serial;nightly;parallel;output;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files_csv.cir.sh COMMAND perl -I${XyceRegressionTestScripts} ac_files_csv.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} ac_files_csv.cir ${OutputDataDir}/Certification_Tests/BUG_701_SON/ac_files_csv.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files_csv.cir.sh PROPERTY LABELS "serial;nightly;parallel;output;ac")
endif()
if( Xyce_PARALLEL_MPI  AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files_csv.cir.sh COMMAND perl -I${XyceRegressionTestScripts} ac_files_csv.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} ac_files_csv.cir ${OutputDataDir}/Certification_Tests/BUG_701_SON/ac_files_csv.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_701_SON/ac_files_csv.cir.sh PROPERTY LABELS "serial;nightly;parallel;output;ac")
endif()
if( (NOT Xyce_PARALLEL_MPI) AND Xyce_USE_FFT AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_701_SON/hb_files_csv.cir.sh COMMAND perl -I${XyceRegressionTestScripts} hb_files_csv.cir.sh $<TARGET_FILE:Xyce> ${XYCE_VERIFY} ${XYCE_VERIFY} hb_files_csv.cir ${OutputDataDir}/Certification_Tests/BUG_701_SON/hb_files_csv.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_701_SON/hb_files_csv.cir.sh PROPERTY LABELS "serial;nightly;parallel;output;hb;hboutput;required:fft")
endif()
if( Xyce_PARALLEL_MPI  AND Xyce_USE_FFT AND PERL_FOUND )
  add_test(NAME ${TestNamePrefix}Certification_Tests/BUG_701_SON/hb_files_csv.cir.sh COMMAND perl -I${XyceRegressionTestScripts} hb_files_csv.cir.sh "mpiexec -bind-to none -np 2 $<TARGET_FILE:Xyce>" ${XYCE_VERIFY} ${XYCE_VERIFY} hb_files_csv.cir ${OutputDataDir}/Certification_Tests/BUG_701_SON/hb_files_csv.cir.prn )
  set_property(TEST ${TestNamePrefix}Certification_Tests/BUG_701_SON/hb_files_csv.cir.sh PROPERTY LABELS "serial;nightly;parallel;output;hb;hboutput;required:fft")
endif()
