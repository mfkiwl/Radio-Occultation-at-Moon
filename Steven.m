SatA = csvread('LIONER396520.csv');    % position of LRO
SatB = csvread('lro.csv');  % position of LIONER
x_SatA = SatA(:,1);
y_SatA = SatA(:,2);
z_SatA = SatA(:,3);
x_SatB = SatB(:,1);
y_SatB = SatB(:,2);
z_SatB = SatB(:,3);
K=259200;
LLA=zeros(K,3);
for i=1:K
    D = norm(cross(SatA(i,:), SatB(i,:))) / norm([x_SatB(i)-x_SatA(i),y_SatB(i)-y_SatA(i),z_SatB(i)-z_SatA(i)]);
    if D<1737
        LLA(i,:)=[-1,-1,-1];
    elseif D<1837
        a=[SatB(i,1)-SatA(i,1) SatB(i,2)-SatA(i,2) SatB(i,3)-SatA(i,3)];
        t=-dot(SatA(i,:),a)/norm(a)^2;
        x=SatA(i,1)+(SatB(i,1)-SatA(i,1))*t;
        y=SatA(i,2)+(SatB(i,2)-SatA(i,2))*t;
        z=SatA(i,3)+(SatB(i,3)-SatA(i,3))*t;
        if y>0
            Lon = acos(x / (x^2 + y^2)^.5) * 180 / pi * 1;
        else
            Lon = acos(x / (x^2 + y^2)^.5) * 180 / pi * (-1);
        end
        Lat = asin(z / (x^2 + y^2 + z^2)^.5) * 180 / pi;
        A = (x^2 + y^2 + z^2)^.5 - 1737;
        LLA(i,:) = [Lon Lat A];
    else
        LLA(i,:)=[-1,-1,-1];
    end     
end
csvwrite('Occ.csv',LLA);
fprintf("Done");
