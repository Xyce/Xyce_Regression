%
% These are units tests written in Matlab script
% designed to test the Xyce REST API as exposed by
% the python code in XyceRest.py
%

% This will need to be modified for a given test configuration for now

%
% functions tested
% . xyce_open
% . xyce_close
% . xyce_initialize
% . xyce_run 
% . xyce_getsimtime
% . xyce_getfinaltime 
% . xyce_simulateuntil
% . xyce_getdacnames
% . xyce_getadcmap
% . xyce_checkcircuitparamexists
% . xyce_getcircuitvalue
% . xyce_setcircuitparameter
% . xyce_gettimevoltagepairs
% xyce_updatetimevoltagepairs
% 
%


classdef XyceRESTTests < matlab.unittest.TestCase
  methods(Test)
  
    %
    % Test status
    % 
    function testServerStatus(testCase)
      status = webread("http://localhost:5000/status" );
      testCase.verifyEqual(status.numInstance, 0);
    end

    %
    % Test xyce_open and xyce_close 
    %
    function testServerXyceOpenClose(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_initialize
    %
    function testServerXyceInitialize(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist1.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % close this xyce object
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_run
    %
    function testServerXyceRun(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist1.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_run", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    
    %
    % Test xyce_getstimtime 
    %
    function testServerXyceGetSimTime(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist1.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_run", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % call getsimtime 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getsimtime", jsarg3, wo);
      testCase.verifyEqual(retcode.time, 1.0);
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_finaltime 
    %
    function testServerXyceFinalSimTime(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist1.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % call getfinaltime 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getfinaltime", jsarg3, wo);
      testCase.verifyEqual(retcode.time, 1.0);
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    
    %
    % Test xyce_simulateuntil 
    %
    function testServerXyceSimulateUntil(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist2.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % call getfinaltime 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getfinaltime", jsarg3, wo);
      testCase.verifyEqual(retcode.time, 1.0);
      
      numSteps = 20;
      deltaTime = retcode.time / numSteps;
      for i = 1:numSteps
        % now try running a circuit.
        s3.uuid=xyceID;
        s3.simtime = [i * deltaTime];
        jsarg3=jsonencode(s3);
        retcode = webwrite("http://localhost:5000/xyce_simulateuntil", jsarg3, wo);
        %print(retcode)
        %testCase.verifyEqual(retcode.simulatedTime, (i * deltaTime), "AbsTol", 1e-6);
      end
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    
    %
    % Test xyce_getdacnames 
    %
    function testServerXyceGetDACNames(testCase)
      wo=weboptions('MediaType', 'application/json');
      s.stats=0;
      jsarg=jsonencode(s);
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      %testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist3.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      %testCase.verifyEqual(retcode, 'success');
      
      % call xyce_getdacnames 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getdacnames", jsarg3, wo);
      testCase.verifyEqual(retcode.status, 1.0);
      testCase.verifyEqual(size(retcode.dacNames,1), 1);
      testCase.verifyEqual(retcode.dacNames{1}, 'YDAC!DAC_DRIVER1');
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_getadcmap 
    %
    function testServerXyceGetADCMap(testCase)
      wo=weboptions('MediaType', 'application/json');
      s.stats=0;
      jsarg=jsonencode(s);
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist3.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % call xyce_getadcmap 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getadcmap", jsarg3, wo);
      testCase.verifyEqual(retcode.status, 1.0);
      testCase.verifyEqual(size(retcode.ADCnames,1), 2);
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    
    %
    % Test xyce_checkcircuitparamexists 
    %
    function testServerXyceCheckCircuitParameterExists(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist2.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      s3.uuid=xyceID;
      s3.paramname ='TOMP';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_checkcircuitparamexists", jsarg3, wo);
      testCase.verifyEqual( retcode.result, 0)
      s3.uuid=xyceID;
      s3.paramname ='TEMP';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_checkcircuitparamexists", jsarg3, wo);
      testCase.verifyEqual( retcode.result, 1)
      s3.uuid=xyceID;
      s3.paramname ='R1:R';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_checkcircuitparamexists", jsarg3, wo);
      testCase.verifyEqual( retcode.result, 1)
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_getcircuitvalue 
    %
    function testServerXyceGetCirciutValue(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist2.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      testCase.verifyEqual(retcode, 'success');
      
      s3.uuid=xyceID;
      s3.paramname ='R1:R';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
      testCase.verifyEqual( retcode.value, 1)
      s3.uuid=xyceID;
      s3.paramname ='TEMP';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
      testCase.verifyEqual( retcode.value, 27)
      s3.uuid=xyceID;
      s3.paramname ='V(1)';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
      testCase.verifyEqual( retcode.value, 0)
      
      
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_getcircuitvalue and xyce_setcircuitparameter
    %
    function testServerXyceGetAndSetCirciutValue(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      %testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist2.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      %testCase.verifyEqual(retcode, 'success');
      
      s3.uuid=xyceID;
      s3.paramname ='R1:R';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
      %testCase.verifyEqual( retcode.value, 1)
      s3.paramname ='TEMP';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
      %testCase.verifyEqual( retcode.value, 27)
      s3.paramname ='V(1)';
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
      %testCase.verifyEqual( retcode.value, 0)
      
      % call getfinaltime 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getfinaltime", jsarg3, wo);
      %testCase.verifyEqual(retcode.time, 1.0);
      
      numSteps = 20;
      deltaTime = retcode.time / numSteps;
      for i = 1:numSteps
        % now try running a circuit.
        s3.uuid=xyceID;
        s3.simtime = [i * deltaTime];
        jsarg3=jsonencode(s3);
        retcode = webwrite("http://localhost:5000/xyce_simulateuntil", jsarg3, wo);
        %print(retcode)
        %testCase.verifyEqual(retcode.simulatedTime, (i * deltaTime), "AbsTol", 1e-6);
        if( i==(numSteps/2))
          % in the middle of the run change the resistance on resistor R1
          s4.uuid=xyceID;
          s4.paramname ='R1:R';
          s4.paramval =[1000.0];
          jsarg4=jsonencode(s4);
          retcode = webwrite("http://localhost:5000/xyce_setcircuitparameter", jsarg4, wo);
          testCase.verifyEqual( retcode.status, 1)
          s4.paramname ='TEMP';
          s4.paramval =[-50.0];
          jsarg4=jsonencode(s4);
          retcode = webwrite("http://localhost:5000/xyce_setcircuitparameter", jsarg4, wo);
          testCase.verifyEqual( retcode.status, 1)
        end
        if( i==((numSteps/2)+1))
          % check that param is still set. 
          s3.uuid=xyceID;
          s3.paramname ='R1:R';
          jsarg3=jsonencode(s3);
          retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
          testCase.verifyEqual( retcode.value, 1000)
          s3.paramname ='TEMP';
          jsarg3=jsonencode(s3);
          retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg3, wo);
          testCase.verifyEqual( retcode.value, -50)
        end 
      end
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    %
    % Test xyce_gettimevoltagepairs
    %
    function testServerXyceGetTimeVoltagePairs(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      %testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist3.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      %testCase.verifyEqual(retcode, 'success');
      
      % call getfinaltime 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getfinaltime", jsarg3, wo);
      %testCase.verifyEqual(retcode.time, 1.0);
      
      numSteps = 20;
      deltaTime = retcode.time / numSteps;
      for i = 1:numSteps
        % now try running a circuit.
        s3.uuid=xyceID;
        s3.simtime = [i * deltaTime];
        jsarg3=jsonencode(s3);
        retcode = webwrite("http://localhost:5000/xyce_simulateuntil", jsarg3, wo);
        testCase.verifyEqual(retcode.simulatedTime, (i * deltaTime), "AbsTol", 1e-6);
        
        retcode = webwrite("http://localhost:5000/xyce_gettimevoltagepairs", jsarg3, wo);
        testCase.verifyEqual(retcode.status, 1)
        testCase.verifyEqual(size(retcode.ADCnames,1), 2)
        % Xyce can return 1 or 2 points in the array
        testCase.verifyEqual(retcode.numPointsInArray, [1; 1], "AbsTol", 1)
        testCase.verifyEqual(size(retcode.timeArray,1),retcode.numADCnames*retcode.numPointsInArray(2)) 
        testCase.verifyEqual(size(retcode.voltageArray,1),retcode.numADCnames*retcode.numPointsInArray(2))
      end
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    
    %
    % Test xyce_updatetimevoltagepairs
    %
    function testServerXyceUpdateTimeVoltagePairs(testCase)
      wo=weboptions('MediaType', 'application/json');
      jsarg=jsonencode(' ');
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      %testCase.verifyNotEqual(xyceID, '');
      
      % call initialize 
      s2.uuid=xyceID;
      s2.simfile='TestNetlist3.cir';
      jsarg2=jsonencode(s2);
      retcode = webwrite("http://localhost:5000/xyce_initialize", jsarg2, wo);
      %testCase.verifyEqual(retcode, 'success');
      
      % call getfinaltime 
      % now try running a circuit.
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_getfinaltime", jsarg3, wo);
      %testCase.verifyEqual(retcode.time, 1.0);
      
      numSteps = 2;
      deltaTime = retcode.time / numSteps;
      
      % now try running the circuit half way through transient circuit.
      s3.uuid=xyceID;
      s3.simtime = [ deltaTime];
      jsarg3=jsonencode(s3);
      retcode = webwrite("http://localhost:5000/xyce_simulateuntil", jsarg3, wo);
      testCase.verifyEqual(retcode.simulatedTime, deltaTime, "AbsTol", 1e-6);
      simulatedTime = retcode.simulatedTime;
      
      % set the DAC 
      retcode = webwrite("http://localhost:5000/xyce_getdacnames", jsarg3, wo);
      testCase.verifyEqual(retcode.status, 1.0);
      testCase.verifyEqual(size(retcode.dacNames,1), 1);
      dacName = retcode.dacNames{1};
      
      timeArray = [simulatedTime + 1e-7; simulatedTime + 1e-3];
      dacVData = [0.5; 0.5];
      s4.uuid=xyceID;
      s4.devname = dacName;
      s4.timearray = timeArray;
      s4.voltarray = dacVData;
      jsarg4=jsonencode(s4);
      retcode = webwrite("http://localhost:5000/xyce_updatetimevoltagepairs", jsarg4, wo);
    
      % run to the end of the transient simulation
      retcode = webwrite("http://localhost:5000/xyce_run", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
      
      % verify the DAC change propagated in the circuit 
      s5.uuid=xyceID;
      s5.paramname ='V(N1)';
      jsarg5=jsonencode(s5);
      retcode = webwrite("http://localhost:5000/xyce_getcircuitvalue", jsarg5, wo);
      testCase.verifyEqual( retcode.value, 0.5)
      
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
  end
end 