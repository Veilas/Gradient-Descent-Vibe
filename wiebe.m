function [a, Qtot] = wiebe(Q, b, deltat)

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
max_iterations = 5000;
gamma = 0.001;
THRESHOLD = 1e-4;

T = length(Q)*deltat;
t = deltat:deltat:T;

deltaQ = Q;


Qtot = trapz(t,Q);

a = 2;
for iter = 1:max_iterations

    A = exp(-b*(t./T).^a);
    B = (t./T).^(a - 1);
    C = a* b/T;
    
    dQ = Qtot.*A.*B.*C;
    da = A.*B.*(C.*log(t./T).*(b*(t./T).^a + 1) + b./T);
    
    dFda = (deltaQ - dQ).* da;
    gradient = -2*sum(dFda);
   
    a = a - gamma * gradient;
    
end


end