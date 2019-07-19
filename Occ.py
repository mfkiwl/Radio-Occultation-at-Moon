import pandas as pd
import numpy as np
dfA=pd.read_csv("sata.csv")
SatA=np.array(dfA)
dfB=pd.read_csv("satb.csv")
SatB=np.array(dfB)
K=259
LLA=np.zeros((K,3)) 
x_SatA = SatA[:,0]
y_SatA = SatA[:,1]
z_SatA = SatA[:,2]
x_SatB = SatB [:,0]
y_SatB = SatB [:,1]
z_SatB = SatB [:,2]
for i in range(K):
    D=np.linalg.norm(np.cross(SatA[i,:],SatB[i,:]))/np.linalg.norm([x_SatA[i]-x_SatB[i],y_SatA[i]-y_SatB[i],z_SatA[i]-z_SatB[i]])
    if(D<1737):
        LLA[i]=[-1,-1,-1]
    elif(D<1837):
        a=[SatB[i,0]-SatA[i,0],SatB[i,1]-SatA[i,1],SatB[i,2]-SatA[i,2]]
        t=-(np.dot(SatA[i,:],a))/(np.linalg.norm(a))**2 #parametric representation of a line
        x=SatA[i,0] + (SatB[i,0] - SatA[i,0]) *t #Calculate the point on line AB that has shortest distance to center of moon
        y=SatA[i,1] + (SatB[i,1] - SatA[i,1]) *t
        z=SatA[i,2] + (SatB[i,2] - SatA[i,2]) *t
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
