function predictnow_format(filein,fileout,start_year,start_month,...
         end_year,end_month)

% load file input
%datain=readawg(filein);         
load(filein);
         
% create initial loop value
i=1;
year=start_year;
month=start_month;

% begin while loop to populate data
while ((year<=end_year)&&(month<=end_month))
  
    % create notification
    disp(['processing year:',num2str(year),...
    ' month:',num2str(month)])
    
    % create data selection
    select=((timedimension(:,1)==year)&(timedimension(:,2)==month));
    
    % subset data
	subsettime=timedimension(select,1:2);
    subsetdata=anomaly(select);
    
    % store result to array
    dataout(i,1)=subsettime(1);
    dataout(i,2)=subsettime(2);
    dataout(i,3)=subsetdata;
    
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

% define label
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('predictor');
nino_param=dataout;

% save output
save(fileout,'nino_param','label');
disp(['writing formatted setting to:',fileout]);
         
% terminate function
end 