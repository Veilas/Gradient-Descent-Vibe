



filepath = "Example/data.xlsx";
b = 6.908;

xlsdata = xlsread(filepath);

[T, width] = size(xlsdata);
t = 1:T;

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

xlswrite("result.xls",result);


