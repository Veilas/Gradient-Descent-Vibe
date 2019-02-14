
function [a1, T1, r1, a2, T2, r2] = vibe(Q, b)


% if b was not passed in, set it to a default value
if nargin == 1
    b = 6.908;
end


% Parameters
max_iterations = 5000;
gamma = 0.01;
deltat = 0.1;
THRESHOLD = 0.001;

T = length(Q)*deltat; 
t = 1:deltat:(T + 1 - deltat);

Qtot = trapz(t,Q);


% Initial values to proximate
% [a1 T1 r1 a2 T2 r2]
points = [1 T 0.5 1 T 0.5];

deltaQ = [0 , diff(Q)];


for iter = 1:max_iterations

    a1 = points(1);
    T1 = points(2);
    r1 = points(3);
    
    a2 = points(4);
    T2 = points(5);
    r2 = points(6);
    
    
    A1 = r1*exp(-b*(t./T1).^a1);
    B1 = (t./T1).^(a1 - 1);
    C1 = a1* b./T1;
    
    A2 = r2*exp(-b* (t./T2).^a2);
    B2 = (t./T2).^(a2 - 1);
    C2 = a2* b./T2;

    
    dQ = Qtot*A1.*B1*C1 + Qtot*A2.*B2*C2;
    
    da1 = A1.*B1.*(C1.*log10(t./T1).*(b*(t./T1).^a1 + 1) + b./T1);
    dT1 = A1.*B1.*C1.*(t.*B1.*C1 - a1)./T1;
    dr1 = (A1.*B1.*C1)./r1;
    
    
    da2 = A2.*B2.*(C2.*log10(t./T2).*(b*(t./T2).^a2 + 1) + b./T2);
    dT2 = A2.*B2.*C2.*(t.*B2.*C2 - a2)./T2;
    dr2 = (A2.*B2.*C2)./r2;
    
    
    dw = [da1, dT1, dr1, da2, dT2, dr2];
    
    gradient = [0, 0, 0, 0, 0, 0];
    
    for k = 1:6
        dFdw = 0;
        for i = 1:T
            ki = 1;
            
            dFdw = dFdw + ki*(deltaQ(i) - dQ(i)*deltat) * dw(k)*deltat; 
        end
        gradient(k) = -2*dFdw;
        
    end
    %gradient(5) = 0;
    if sum(abs(gradient)) < THRESHOLD
        break;
    end
    points = points - gamma * gradient;
    
end

a1 = points(1);
T1 = points(2);
r1 = points(3);

a2 = points(4);
T2 = points(5);
r2 = points(6);
    
   % plotVibe(a1,T1,r1,a2,T2,r2,Qtot)

    
end

