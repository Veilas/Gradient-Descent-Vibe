function [points, Qtot] = wiebe(Q, b, deltat)

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

deltaQ = Q;


Qtot = trapz(t,Q);

points = [2 T/2 1];

[val, imax] = max(deltaQ);
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
    a = points(1);
    T = points(2);
    r = points(3);
        
    A = r*exp(-b*(t./T).^a);
    B = (t./T).^(a - 1);
    C = a* b/T;
     
    dQ = Qtot.*A.*B.*C;
    
    da = A.*B.*(C.*log(t./1).*(b*(t./T).^a + 1) + b./T);
    dT = A.*B.*C.*(t.*B.*C - a)./T;
    dr = (A.*B.*C)./r;
        
    
    dw = [da; dT; dr];
    
    gradient = [0, 0, 0];

    for k = 1:3
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
%    A = exp(-b*(t./T).^a);
%    B = (t./T).^(a - 1);
%    C = a* b/T;
    
%    dQ = Qtot.*A.*B.*C;
%    da = A.*B.*(C.*log(t./T).*(b*(t./T).^a + 1) + b./T);
    
%    dFda = (deltaQ - dQ).* da;
%    gradient = -2*sum(dFda);
   
%   a = a - gamma * gradient;
    
end