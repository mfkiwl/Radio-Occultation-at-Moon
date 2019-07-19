%Wei
R = 1737.1; % km
c = zeros(259201,3); % center of Moon
LRO = csvread('lro.csv');    % position of LRO
LIONER = csvread('LIONER396520.csv');  % position of LIONER
x_LRO = LRO(:,1);
y_LRO = LRO(:,2);
z_LRO = LRO(:,3);
x_LIONER = LIONER(:,1);
y_LIONER = LIONER(:,2);
z_LIONER = LIONER(:,3);
a(:,1) = x_LRO - x_LIONER;
a(:,2) = y_LRO - y_LIONER;
a(:,3) = z_LRO - z_LIONER;
b(:,1) = -x_LRO;
b(:,2) = -y_LRO;
b(:,3) = -z_LRO;
S=size(LRO);
for i = 1:S(1)

d(i,1) = norm(cross(a(i,:), b(i,:))) / norm(a(i,:)); % distance between the center of Moon and the line linking LRO and LIONER

if  d(i,1) < R
    LLA(i,:) = [-1 -1 -1];
    
elseif d(i,1) < (1+100/1737.1)*R
    t(i,1) = -(LIONER(i,:) - c(i,:)) * (a(i,:).') / (a(i,:) * a(i,:).');
    O(i,:) = LIONER(i,:) + (LRO(i,:) - LIONER(i,:)) * t(i,1);  % Occultation points!
    x(i) = O(i,1);
    y(i) = O(i,2);
    z(i) = O(i,3);
    if  y(i) > 0
        Lon(i) = acos(x(i) / (x(i)^2 + y(i)^2)^.5) * 180 / pi * 1;
    else
        Lon(i) = acos(x(i) / (x(i)^2 + y(i)^2)^.5) * 180 / pi * (-1);
    end
    Lat(i) = asin(z(i) / (x(i)^2 + y(i)^2 + z(i)^2)^.5) * 180 / pi;
    A(i) = (x(i)^2 + y(i)^2 + z(i)^2)^.5 - R;
    LLA(i,:) = [Lon(i) Lat(i) A(i)]; 
else
    LLA(i,:) = [-1 -1 -1];
end
end
csvwrite('occultation396520.csv',LLA); 
p(i) = LLA(i,1);
q(i) = LLA(i,2);
plot(p,q,'k.','MarkerSize',3);
axis([-180,180,-90,90]);
