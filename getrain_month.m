function getrain_month(filein)
  
% load simulated data
% data=readawg([dir,"rain_sim.awg"]);
load(filein);
data=sim_result;

% define start and end month
startyear=data(1,1);
startmonth=data(1,2);
endyear=data(end,1);
endmonth=data(end,2);

% initiate rows and loop
row=1;
year=startyear;
month=startmonth;

% loop to each month
while (year<=endyear)&&(month<=endmonth),

    % create selection
    select=(data(:,1)==year)&(data(:,2)==month);
    
    % subset data
    subset=data(select,4:size(data,2));
    
    % calculate total rainfall
    month_rain=sum(subset,1);
    
    % write to array
    dataout(row,1)=year;
    dataout(row,2)=month;
    dataout(row,3:size(subset,2)+2)=month_rain;
    
    % add row increment
    row=row+1;
    
    % read next data
    if month==12,
        year=year+1;
        month=1;
    else
        month=month+1;
    end    
    
% terminate while loop  
end

% label output
label(1)=cellstr('year');
label(2)=cellstr('month');
for i=1:size(data,2)
label(i+2)=cellstr(['ensemble',num2str(i)]);
end

% save output into original file
monthly_summary=dataout;
fileout=filein;
save(fileout,'monthly_summary','-append');
disp(['rain monthly data written to:',fileout]);  
  
% terminate function
end