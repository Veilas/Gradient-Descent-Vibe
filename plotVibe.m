function plotVibe(a1, T1, r1, a2, T2, r2, Qtot)

b = 6.908;

T = 100;

t = 1:T;

Q1 = 1 - exp(-b*(t./T1).^a1);
Q2 = 1 - exp(-b*(t./T2).^a2);

Q = r1*Qtot * Q1 + r2*Qtot * Q2;

plot(Q);

end

