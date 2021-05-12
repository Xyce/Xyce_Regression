import numpy as np
from BaseDevice import BaseDevice

class Device(BaseDevice):
    
    def get_F_Q_B_dfDx_dQdx_sizes(self, b_params, d_params, i_params, s_params):
        num_vars = i_params["numVars"]
        size_dict = {}
        size_dict['F']=[num_vars,]
        size_dict['Q']=[0,]
        size_dict['B']=[0,]
        size_dict['dFdX']=[num_vars,num_vars]
        size_dict['dQdX']=[0,0]
        return size_dict
    
    def getJacStampSize(self, b_params, d_params, i_params, s_params):
        # minimum implementation is to return a size 0 numpy array of ints
        return np.zeros(shape=(0,),dtype='i4')
    
    def setJacStamp(self, jacStamp, b_params, d_params, i_params, s_params):
        return
    
    def computeXyceVectors(self, solV, fSV, stoV, t, deviceOptions, solverState,
            origFlag, F, Q, B, dFdX, dQdX, dFdXdVp, dQdXdVp, 
            b_params, d_params, i_params, s_params):
        # solV, F, Q, and B are memory views
        # cast them to numpy arrays without copying data
        np_solV = np.array(solV, dtype=np.float64, copy=False)
        np_F  = np.array( F, dtype=np.float64, copy=False)
        np_Q  = np.array( Q, dtype=np.float64, copy=False)
        np_B  = np.array( B, dtype=np.float64, copy=False)
    
        np_dFdX = [np.array(item, dtype=np.float64, copy=False) for item in dFdX]
        np_dQdX = [np.array(item, dtype=np.float64, copy=False) for item in dQdX]
    
        #print(np_solV.shape)
        #print(np_F.shape)
        #print(np_Q.shape)
        #print(np_B.shape)
        #print(dFdX)
        #print(dQdX)
    
    
        R = d_params['R']
        G=1.0/R;
    
    
        numVars=np_solV.shape[0]
        indepVars = np.zeros(shape=(numVars,),dtype=np.float64)
        Fcontribs = np.zeros(shape=(numVars,),dtype=np.float64)
        for i in range(numVars):
            indepVars[i]=np_solV[i];
    
        Fcontribs[0] = (indepVars[0]-indepVars[1])/R;
        Fcontribs[1] = -Fcontribs[0];
    
    
        for i in range(2,Fcontribs.shape[0]):
            Fcontribs[i]=0;
    
        for i in range(numVars):
            np_F[i] = Fcontribs[i];
    
        np_dFdX[0][0] = G;
        np_dFdX[0][1] = -G;
        np_dFdX[1][0] = -G;
        np_dFdX[1][1] = G;
    
        return 1
