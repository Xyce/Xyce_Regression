#include <vpi_user.h>
#include <stdio.h>
#include <stdlib.h>
#include <N_CIR_XyceCInterface.h>

static int ADCStateTest_compiletf(char*user_data)
{
      return 0;
}

static int ADCStateTest_calltf(char*user_data)
{
      printf("In calltf for ADCStateTest\n");

      // Used as a pointer to a pointer to an N_CIR_Xyce object.
      // This somewhat convoluted syntax is needed to stop p from
      // pointing at the same address as the VPI system task.
      void** p = (void **) malloc( sizeof(void* [1]) );

      // Turn the desired Xyce command line invocation into an int and
      // char** pointer that can used to initialize an N_CIR_ Xyce object.
      // This is hard-coded for initial testing purposes.
      char *argList[] = {
	  (char*)("Xyce"),
          (char*)("-quiet"),
          (char*)("ADCStateTest.cir")
      };
      int argc = sizeof(argList)/sizeof(argList[0]);
      char** argv = argList;

      xyce_open(p);
      xyce_initialize(p,argc,argv);

      // Get the number of YADC in the netlist, and the maximum name length
      // This allows for better sizing of the ADCnames char arrays.
      int numADCnames, maxADCnameLength;
      int* numADCnamesPtr = &numADCnames;
      int* maxADCnameLengthPtr = &maxADCnameLength;
      xyce_getNumDevices(p, (char *)"YADC", numADCnamesPtr, maxADCnameLengthPtr);
      printf("Num ADCs and Max ADC Name Length: %d %d\n",numADCnames,maxADCnameLength);

      // Initialize arrays of char array
      char ** ADCnames;

      int i,j,k; // loop counters
      ADCnames = (char **) malloc( numADCnames * sizeof(char*));
      for (i = 0; i < numADCnames; i++)
      {
        ADCnames[i] = (char *) malloc( (maxADCnameLength+1)*sizeof(char) );
      }

      int status, numPoints;
      int* numPointsPtr = &numPoints;
      double stepSize = 1e-5;
      double requested_time, actual_time;

      double* actual_time_ptr = &actual_time;
      double** timeArray;
      int** stateArray;
      timeArray = (double **) malloc(numADCnames * sizeof(double*));
      stateArray = (int **) malloc(numADCnames * sizeof(int*));
      for (i=0; i<2; i++)
      {
        timeArray[i] = (double *) malloc(2*sizeof(double));
        stateArray[i] = (int *) malloc(2*sizeof(int));
      }

      FILE *fptr;
      fptr = fopen("ADCStateTest.cir.TSarrayData","w" );

      for (i=0; i<10; i++)
      {
        requested_time = 0.0 + (i+1) * stepSize;
        printf( "Calling simulateUntil for requested time %f\n", requested_time );
        status = xyce_simulateUntil(p, requested_time, actual_time_ptr );
        printf( "Return status from simulateUntil = %d and actual_time = %f\n",status, actual_time);

        status = xyce_getTimeStatePairsADC(p, numADCnamesPtr, ADCnames, numPointsPtr, timeArray, stateArray);

        // output to stdout (for human readability)
        printf( "number of points returned by getTimeVoltagePairsADC is %d\n", numPoints );
        printf( "ADC 1: Time and state array 0 values are %.3e %d\n", timeArray[0][0], stateArray[0][0] );
        printf( "ADC 1: Time and state array 1 values are %.3e %d\n", timeArray[0][1], stateArray[0][1] );
        printf( "ADC 2: Time and state array 0 values are %.3e %d\n", timeArray[1][0], stateArray[1][0] );
        printf( "ADC 2: Time and state array 1 values are %.3e %d\n", timeArray[1][1], stateArray[1][1] );

        // output to file (for comparison against a gold standard)
        fprintf( fptr, "ADC 1: Time and state array 0 values are %.3e %d\n", timeArray[0][0], stateArray[0][0] );
        fprintf( fptr, "ADC 1: Time and state array 1 values are %.3e %d\n", timeArray[0][1], stateArray[0][1] );
        fprintf( fptr, "ADC 2: Time and state array 0 values are %.3e %d\n", timeArray[1][0], stateArray[1][0] );
        fprintf( fptr, "ADC 2: Time and state array 1 values are %.3e %d\n", timeArray[1][1], stateArray[1][1] );

        // zero out the arrays, before getting their values for the next iteration.
        for (j=0; j<=1; j++)
          for (k=0; k<=1; k++)
	  {
            timeArray[j][k]=0.0;
            stateArray[j][k]=0;
	  }
      }

      xyce_close(p);

      // pointer clean-up
      free(p);
      fclose(fptr);

      for (i = 0; i < numADCnames; i++)
      {
        free( ADCnames[i] );
        free( stateArray[i] );
        free( timeArray[i] );
      }
      free( ADCnames );
      free( stateArray );
      free( timeArray );

      vpi_printf("Exiting calltf for ADCStateTest\n");
      return 0;
}

void ADCStateTest_register()
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$ADCStateTest";
      tf_data.calltf    = ADCStateTest_calltf;
      tf_data.compiletf = ADCStateTest_compiletf;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])() = {
    ADCStateTest_register,
    0 /* final entry must be zero */
};
