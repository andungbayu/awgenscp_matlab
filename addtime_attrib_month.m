function dataout=addtime_attrib_month(filename,year,month)
% fucntion to create time attribute

% load textfile
load(filename,'anomaly');

% get time length
ntime=length(anomaly);
disp(ntime)

% generate output array
timeout=zeros(ntime,2);

% loop to create time array
for i=1:ntime

    % add value to array
    timeout(i,1)=year;
    timeout(i,2)=month;
    
    % recycle time value if month=12
    if (month==12)
        year=year+1;month=1;
    else
        month=month+1;
    end
    
% terminate loop: i
end
  
% combine with input data
timedimension=timeout;

% save variable to existing input filename
save(filename,'timedimension','-append')
disp(['setup nino time dimension finished']);

% terminate function
end