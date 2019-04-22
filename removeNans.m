function dataout = removeNans(datain)

for i = 1:size(datain,2)
    temp = datain(:,i);
    temp = temp(~isnan(temp));
    dataout(:,i) = temp;
end
