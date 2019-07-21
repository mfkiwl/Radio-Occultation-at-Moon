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
    D = norm(cross(SatA(i,:), SatB(i,:)))/norm([x_SatB(i)-x_SatA(i),y_SatB(i)-y_SatA(i),z_SatB(i)-z_SatA(i)]);
    if D<1737
        LLA(i,:)=[-1,-1,-1];
    elseif D<1837
        a=[SatB(i,1)-SatA(i,1) SatB(i,2)-SatA(i,2) SatB(i,3)-SatA(i,3)];
        t=-dot(SatA(i,:),a)/norm(a)^2;
        x=SatA(i,1)+(SatB(i,1)-SatA(i,1))*t;
        y=SatA(i,2)+(SatB(i,2)-SatA(i,2))*t;
        z=SatA(i,3)+(SatB(i,3)-SatA(i,3))*t;
        if y>0
            Lon = rad2deg(acos(x / (x^2 + y^2)^.5));
        else
            Lon =  rad2deg(acos(x / (x^2 + y^2)^.5))*(-1);
        end
        Lat =  rad2deg(asin(z / (x^2 + y^2 + z^2)^.5));
        A = (x^2 + y^2 + z^2)^.5 - 1737;
        LLA(i,:) = [Lon Lat A];
    else
        LLA(i,:)=[-1,-1,-1];
    end     
end

LLA_3d=[100 100 100];
LLA_alt=100;
LLA_minalt=[100 100 100];
flag=true;
count=0;

for j=1:K
    if LLA(j,3)>0   
        flag=true;
        count=count+1;
        LLA_alt(end+1)= LLA(j,3);
        LLA_3d(end+1,:)=LLA(j,:);      
    else
        flag=false;       
    end
    
    if flag==false && count>0.5
        minalt=min(LLA_alt);
        position=find(LLA_alt==minalt);
        LLA_minalt(end+1,:)=LLA_3d(position,:);
        count=0;
        LLA_alt(1:end)=[];
        LLA_3d(1:end,:)=[];
    end    
end
LLA_minalt(1,:)=[];
LLA_minalt

img = imread('Moon 2D.png');
min_x = -180;
max_x = 180;
min_y = -90;
max_y = 90; 

A = LLA_minalt	
x=A(:,1);
y=A(:,2);

imagesc([min_x max_x], [min_y max_y],flip(img,1));
set(gca,'ydir','reverse')

hold on; 
plot(x,y,'r.','MarkerSize',7);
title('Occultation LRO');
ylabel('Latitude');
xlabel('Longitude');
set(gca,'yDir','normal');
axis image;
