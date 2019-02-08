function addtime_attrib_day(filename,year,month,day)
% fucntion to create time attribute

% load textfile
load(filename);

% define date range
dateinit=datenum(year,month,day);
daterange=dateinit:1:(dateinit+size(data,1)-1);

% generate output table
timevec=datevec(daterange);
dataout=timevec(:,1:3);
  
% add variable to matfile
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('day');

% define variable to save
timedimension=dataout(:,1:3);
timelabel=label;

% save variable to existing input filename
save(filename,'timedimension','-append')
save(filename,'timelabel','-append')
disp(['setup time dimension finished']);

% terminate function
end