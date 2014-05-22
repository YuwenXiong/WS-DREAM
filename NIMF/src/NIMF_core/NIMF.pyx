#########################################################
# NIMF.pyx
# Author: Jamie Zhu <jimzhu@GitHub>
# Created: 2014/2/6
# Last updated: 2014/5/18
#########################################################

import time
import numpy as np
from numpy import linalg as LA
from utilities import *
cimport numpy as np # import C-API


#########################################################
# Make declarations on functions from cpp file
#
cdef extern from "NIMF_core.h":
    void NIMF(double *removedData, int numUser, int numService, int dim, 
        double lmda, double alpha, int maxIter, double etaInit, int topK,
        double *Udata, double *Sdata, double *predData)
#########################################################


#########################################################
# Function to wrap up the C++ functions
#
def NIMF_wrapper(removedMatrix, paraStruct):  
    cdef int numService = removedMatrix.shape[1] 
    cdef int numUser = removedMatrix.shape[0] 
    cdef int dim = paraStruct['dimension']
    cdef double lmda = paraStruct['lambda']
    cdef int maxIter = paraStruct['maxIter']
    cdef double etaInit = paraStruct['etaInit']
    cdef int topK = paraStruct['topK']
    cdef double alpha = paraStruct['alpha']

    # initialization
    cdef np.ndarray[double, ndim=2, mode='c'] U = np.random.rand(numUser, dim)        
    cdef np.ndarray[double, ndim=2, mode='c'] S = np.random.rand(numService, dim)
    cdef np.ndarray[double, ndim=2, mode='c'] predMatrix = \
        np.zeros((numUser, numService), dtype=np.float64)
    
    logger.info('Iterating...')

    # Wrap up the NIMF_core.cpp
    NIMF(<double *> (<np.ndarray[double, ndim=2, mode='c']> removedMatrix).data,
        numUser,
        numService,
        dim,
        lmda,
        alpha,
        maxIter,
        etaInit,
        topK,
        <double *> U.data,
        <double *> S.data,
        <double *> predMatrix.data
        )
   
    return predMatrix
#########################################################

