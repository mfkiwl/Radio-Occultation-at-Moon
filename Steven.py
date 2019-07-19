import pandas as pd
import numpy as np

R=1737.1
dfA=pd.read_csv("sata.csv")
LIONER=np.array(dfA)
dfB=pd.read_csv("satb.csv")
LRO=np.array(dfB)
x_LIONER = LIONER[:,0]
y_LIONER = LIONER[:,1]
z_LIONER = LIONER[:,2]
x_LRO = LRO[:,0]
y_LRO = LRO[:,1]
z_LRO = LRO[:,2]
a=LRO-LIONER
K=2592
LLA=np.zeros((K,3)) 

for i in range(K):
    D=np.linalg.norm(np.cross(LIONER[i,:],LRO[i,:]))/np.linalg.norm(a[i])
    if(D<R):
        LLA[i]=[-1,-1,-1]
    elif(D<R+100):     
        t=-(np.dot(LIONER[i,:],a[i]))/(np.linalg.norm(a[i]))**2 #parametric representation of a line
        O=LIONER[i,:]+(LRO[i,:]-LIONER[i,:])*t
        x=O[0] 
        y=O[1]
        z=O[2]
        if(y>0):
            Lon=np.degrees(np.arccos(x/np.sqrt(x**2+y**2)))
        else:
            Lon=np.degrees(np.arccos(x/np.sqrt(x**2+y**2))) * (-1)
        Lat = np.degrees(np.arcsin(z/np.sqrt(x**2 + y**2 + z**2)));
        A = np.sqrt(x**2 + y**2 + z**2)-1737 #Altitude
        LLA[i]=[Lon,Lat,A]
    else:
        LLA[i]=[-1,-1,-1]
LLA
