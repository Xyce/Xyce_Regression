%
% These are units tests written in Matlab script
% designed to test the Xyce REST API as exposed by
% the python code in XyceRest.py
%

% This will need to be modified for a given test configuration for now


classdef XyceRESTTests < matlab.unittest.TestCase
  methods(Test)
    function testServerStatus(testCase)
      status = webread("http://localhost:5000/status" );
      testCase.verifyEqual(status, []);
    end

    function testServerXyceOpen(testCase)
      wo=weboptions('MediaType', 'application/json');
      XyceCInterfaceLibraryDir = '/Users/rlschie/src/XyceDevelopment/BUILD/NormalShare/utils/XyceCInterface';
      s.libdir = XyceCInterfaceLibraryDir;
      jsarg=jsonencode(s);
      xyceID = webwrite("http://localhost:5000/xyce_open", jsarg, wo);
      testCase.verifyNotEqual(xyceID, '');
      s3.uuid=xyceID;
      jsarg3=jsonencode(s3);
      % close this xyce object
      retcode = webwrite("http://localhost:5000/xyce_close", jsarg3, wo);
      testCase.verifyEqual(retcode, 'success');
    end
    
    
  end
end