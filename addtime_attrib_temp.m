function addtime_attrib_temp(filename,dir,year,month,day)
% fucntion to create time attribute

% load textfile
datain=dlmread(filename);

% define date range
dateinit=datenum(year,month,day);
daterange=dateinit:1:(dateinit+size(datain,1)-1);

% generate output table
timevec=datevec(daterange);
dataout=timevec(:,1:3);

% combine with input data
dataout=[dataout,datain];
  
% save awg
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('day');
label(4)=cellstr('temp');
saveawg([dir,"temp.awg"],dataout,label);
disp(["\n setup process finished"]);
% disp(["\n write to: ",dir,"rain.awg"]);

% terminate function
end