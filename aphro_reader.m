function aphro_reader(outfile,year_init,year_end,lat,lon)

% initiate output
data=[];

% read data by year 
for t=year_init:year_end
  
    % display progress
    disp(['Processing year: ',num2str(t)]);

    % define netcdf file
	
	sourcefolder='/data/aphro_netcdf/';
    % sourcefile=[num2str(year),'.nc.gz'];
    % extractfile=[num2str(year),'.nc'];
    ramdisk='/dev/shm/';

    filename=[sourcefolder,num2str(t),'.nc.gz'];
    zipfile=[ramdisk,num2str(t),'.nc.gz'];
    ncfile=[ramdisk,num2str(t),'.nc'];
              
    % extract file
    copyfile(filename,zipfile);
    gunzip(zipfile,ramdisk);
    
    % get netcdf data
    time=ncread(ncfile,'time');
    getlat=ncread(ncfile,'lat');
    getlon=ncread(ncfile,'lon');

    % calculate requested latlon
    getlat=(getlat-lat).^2;
    getlon=(getlon-lon).^2;
    [any,idx_lat]=min(getlat);
    [any,idx_lon]=min(getlon);
    
    % subset data
    getsize=length(time);
    getdata=ncread(ncfile,'precip',[idx_lon,idx_lat,1,1],...
        [1,1,1,getsize],[1,1,1,1]);
    datayear=squeeze(getdata);
    data=[data;datayear];

    % remove netcdf
    delete(ncfile);
	delete(zipfile);
end

% save file
save(outfile,'data');