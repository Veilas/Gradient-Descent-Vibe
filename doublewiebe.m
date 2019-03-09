
function [points, Qtot] = doublewiebe(Q, b, deltat)

Q = Q';
% if b was not passed in, set it to a default value
if nargin == 1
    b = 6.908;
    deltat = 1;
end
if nargin == 2
    deltat = 1;
end

% Parameters
max_iterations = 50000;
gamma = 0.001;
THRESHOLD = 1e-4;

T = length(Q)*deltat;
t = deltat:deltat:T;

Qtot = trapz(t,Q);


% Initial values to proximate
% [a1 T1 r1 a2 T2 r2]
points = [2 T/2 1 2 T 0.5];

deltaQ = Q;

[val, imax] = max(deltaQ);
%deltaQ = [0 , diff(Q)];

ki = ones(1, length(Q));
for i = 1:length(ki)
    if i == imax 
        ki(i) = 16;
    elseif i > imax + 4
        ki(i) = 1;
    elseif i < imax - 4
        ki(i) = 1;
    else
        ki(i) = (4.0/abs(i - imax))^2;
    end
end

for iter = 1:max_iterations

    a1 = points(1);
    T1 = points(2);
    r1 = points(3);
    
    a2 = points(4);
    T2 = points(5);
    r2 = points(6);
    
    
    A1 = r1*exp(-b*(t./T1).^a1);
    B1 = (t./T1).^(a1 - 1);
    C1 = a1* b/T1;
    
    A2 = r2*exp(-b* (t./T2).^a2);
    B2 = (t./T2).^(a2 - 1);
    C2 = a2* b/T2;
 
    
    dQ = Qtot.*A1.*B1.*C1 + Qtot.*A2.*B2.*C2;
    
    
    da1 = A1.*B1.*(C1.*log(t./T1).*(b*(t./T1).^a1 + 1) + b./T1);
    dT1 = A1.*B1.*C1.*(t.*B1.*C1 - a1)./T1;
    dr1 = (A1.*B1.*C1)./r1;
    
    
    da2 = A2.*B2.*(C2.*log(t./T2).*(b*(t./T2).^a2 + 1) + b./T2);
    dT2 = A2.*B2.*C2.*(t.*B2.*C2 - a2)./T2;
    dr2 = (A2.*B2.*C2)./r2;
    
    
    dw = [da1; dT1; dr1; da2; dT2; dr2];
    
    gradient = [0, 0, 0, 0, 0, 0];

    for k = 1:6
        dFdw = ki.*(deltaQ - dQ).* dw(k,:);
        gradient(k) = -2*sum(dFdw);
    end
    magniude = norm(gradient);
    
    if magniude < 1
        magniude = 1;
    end
    
    points = points - gamma * gradient./magniude;
    
end
points = points;
    
end

