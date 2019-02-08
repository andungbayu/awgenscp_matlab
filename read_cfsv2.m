function read_cfsv2(dir)

% define input parameter
ncfile=[dir,'get_cfs.nc'];
output_file=[dir,'CFSv2_data.txt'];
output_time=[dir,'CFSv2_time.txt'];
output_fileobs=[dir,'CFS_obs_data.txt'];
output_timeobs=[dir,'CFS_obs_time.txt'];

% load netcdf package
pkg load netcdf

% get netcdf info
main=ncinfo(ncfile);

% get netcdf data
time=ncread(ncfile,'TIME');
ensemble=ncread(ncfile,'ENS');
anom=squeeze(ncread(ncfile,'anom'));

% calculate absolute time
init_date=datenum(1970,1,1);
time=time+init_date;
getdate=datevec(time);

% separate anomaly to prediction and observation
predict=anom(:,1:40);
obs=anom(:,41);

% get nonzero prediction data
idx=predict(:,1)<=-99;
predict(idx,:)=[];
predict(predict==-9999)=0;
sumval=sum(predict,1);
idxsum=(sumval==0);
predict(:,idxsum)=[];
timepredict=getdate(:,1:2);
timepredict(idx,:)=[];

% get nonzero observation data
idx=obs(:,1)<=-99;
obs(idx,:)=[];
timeobs=getdate(:,1:2);
timeobs(idx,:)=[];

% save to text file
dlmwrite(output_file,predict);
dlmwrite(output_time,timepredict);
dlmwrite(output_fileobs,obs);
dlmwrite(output_timeobs,timeobs);

% notify system
disp(["CFSv2 Ensemble Data written to: ",output_file]);
disp(["CFSv2 Ensemble Time written to: ",output_time]);
disp(["CFSv2 Observation Data written to: ",output_fileobs]);
disp(["CFSv2 Observation Time written to: ",output_timeobs]);
disp("");
disp("CFSv2 extractor job completed");
