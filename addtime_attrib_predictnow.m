function addtime_attrib_predictnow(filename,dir,year,month)
% fucntion to create time attribute

% load textfile
datain=dlmread(filename);

% get time length
ntime=size(datain,1);

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
dataout=[timeout,datain];

% save awg
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('predictor');
saveawg([dir,"predict_now.awg"],dataout,label);
disp(["\n setup process finished"]);

% terminate function
end