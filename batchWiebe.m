inputfilepath = 'Example/data.xlsx';
outputfilepath = 'result.xls'; 

b = 6.908;

xlsdata = xlsread(inputfilepath);

[T, width] = size(xlsdata);
width=1;
t = 1:T;
derivt = 1:T-1;

results = zeros(10, width);
for k = 1:width
    data = (xlsdata(:, k));
    deltaQ = data(~isnan(data));
    deltaQ = deltaQ(2:end);
    [parameters1, Qtot] = doublewiebe(deltaQ);
    [parameters2] = wiebe(deltaQ);
    a1 = parameters1(1);
    T1 = parameters1(2);
    r1 = parameters1(3);
    a2 = parameters1(4);
    T2 = parameters1(5);
    r2 = parameters1(6);
    a  = parameters2(1);
    T  = parameters2(2);
    r  = parameters2(3);
    results(:, k) = [a1; T1; r1; a2; T2; r2; a; T; r; Qtot]; 
end


xlswrite(outputfilepath, results,'parametri');


for k = 1:width
    data = xlsdata(:, k);
    column = data(~isnan(data));
    T = length(column');
    t = 1:T;
    
    rez = results(:, k)';
    a1 = rez(1);
    T1 = rez(2);
    r1 = rez(3);
    a2 = rez(4);
    T2 = rez(5);
    r2 = rez(6);
    a = rez(7);
    T = rez(8);
    r = rez(9);
    Qtot = rez(10);

    A1 = r1*exp(-b*(t./T1).^a1);
    B1 = (t./T1).^(a1 - 1);
    C1 = a1* b/T1;
    
    A2 = r2*exp(-b* (t./T2).^a2);
    B2 = (t./T2).^(a2 - 1);
    C2 = a2* b/T2;
   
    A = r*exp(-b* (t./T).^a);
    B = (t./T).^(a - 1);
    C = a* b/T;
    
    dQ = Qtot.*A.*B.*C;
    
    dQ1 = Qtot.*A1.*B1.*C1;
    dQ2 = Qtot.*A2.*B2.*C2;
    
    t = 0:length(column');
    dQ1 = [0 dQ1];
    dQ2 = [0 dQ2];
    dQ = [0 dQ];
    column = [0; column];
    
    formatedData = [t' column dQ1' dQ2' (dQ1 + dQ2)' dQ'];
    xlswrite(outputfilepath, formatedData, strcat(num2str(k*10), '%'));
end


% figure
% for k = 1:width
%     parameters = result(:, k)';
%     a1 = parameters(1);
%     T1 = parameters(2);
%     r1 = parameters(3);
%     a2 = parameters(4);
%     T2 = parameters(5);
%     r2 = parameters(6);
%     Qtot = parameters(7);
%     
%     Q1 = Qtot*r1*(1 - exp(-b*(t./T1).^a1));
%     Q2 = Qtot*r2*(1 - exp(-b*(t./T2).^a2));
%     dQ1 =  Q1(2: end) - Q1(1: end-1);
%     dQ2 =  Q2(2: end) - Q2(1: end-1);
%     dQ = dQ1 + dQ2;
%     subplot(5, 2, k);
%     plot(derivt, dQ, t, xlsdata(:,k)');
%     
% end



