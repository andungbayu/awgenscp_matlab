function gettemp_param(filein,start_year,start_month,...
         end_year,end_month)

% load file input
datain=readawg(filein);         
         
% create initial loop value
i=1;
year=start_year;
month=start_month;

% begin while loop to populate data
while ((year<=end_year)&&(month<=end_month))
  
    % create notification
    disp(["processing year:",num2str(year),...
    " month:",num2str(month)])
    
    % create data selection
    select=((datain(:,1)==year)&(datain(:,2)==month));
    
    % subset data
    subset=datain(select,4);
    
    % estimate parameter
    [meanval,stdval]=normaldist_estimator(subset);
    
    % store result to array
    dataout(i,1)=year;
    dataout(i,2)=month;
    dataout(i,3)=meanval;
    dataout(i,4)=stdval;
    
    % add time increment
    i=i+1;
    
    % change timerange for next selection
    if (month==12),
        year=year+1;
        month=1;
    else
        month=month+1;
    end
  
% terminate while loop
end

% save output
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('normdist_mean');
label(4)=cellstr('normdist_std');
[path,name,ext]=fileparts(filein);
fileout=[path,"/",name,"_param.awg"];
disp(["writing temperature parameter to:",fileout]);
saveawg(fileout,dataout,label);
         
% terminate function
end 