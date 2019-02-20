



filepath = 'Example/data.xlsx';
b = 6.908;

xlsdata = xlsread(filepath);

[T, width] = size(xlsdata);
t = 1:T;
derivt = 1:T-1;

result = zeros(7, width - 1);


for k = 2:width
    deltaQ = xlsdata(:, k);
    [parameters, Qtot] = wiebe(deltaQ);
    a1 = parameters(1);
    T1 = parameters(2);
    r1 = parameters(3);
    a2 = parameters(4);
    T2 = parameters(5);
    r2 = parameters(6);
    result(:, k -1) = [a1; T1; r1; a2; T2; r2; Qtot]; 
end

xlswrite('result.xls',result);

figure
for k = 2:width
    parameters = result(:, k - 1)';
    a1 = parameters(1);
    T1 = parameters(2);
    r1 = parameters(3);
    a2 = parameters(4);
    T2 = parameters(5);
    r2 = parameters(6);
    Qtot = parameters(7);
    
    Q1 = Qtot*r1*(1 - exp(-b*(t./T1).^a1));
    Q2 = Qtot*r2*(1 - exp(-b*(t./T2).^a2));
    dQ1 =  Q1(2: end) - Q1(1: end-1);
    dQ2 =  Q2(2: end) - Q2(1: end-1);
    dQ = dQ1 + dQ2;
    subplot(5, 2, k - 1);
    plot(derivt, dQ, t, xlsdata(:,k)');
    
end



