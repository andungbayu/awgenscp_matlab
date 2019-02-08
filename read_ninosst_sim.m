function read_ninosst_sim(inputfile,output_file,subset_year,base_year)

% define textfilename
txt_file=inputfile;

% begin reading input file
fileID=fopen(txt_file);

% reading 1st line to identify year
line=fgetl(fileID);
getyear=strsplit(line);
inityear=str2num(char(getyear{1,2}));
endyear=str2num(char(getyear{1,3}));
nrows=(endyear-inityear)+1;

% identifying rest of data
txt_data=zeros(nrows,13);
for i=1:nrows,
    line=fgetl(fileID);
    getdata=strsplit(line);
    for j=2:size(getdata,2),
    txt_data(i,j-1)=str2double(char(getdata(1,j)));
    end 
end

% close data
fclose(fileID);

% structuring data
data=zeros((nrows*12),3);
i=1;
for row=1:nrows,
for col=1:12,
    data(i,1)=txt_data(row,1);
    data(i,2)=col;
    data(i,3)=txt_data(row,col+1);
    i=i+1;
end
end

% remove invalid data
idx=(data(:,3)<-99.00);
data(idx,:)=[];

% subset data
idx=(data(:,1)>=subset_year(1))&(data(:,1)<=subset_year(2));
subset=data(idx,:);

% calculate anomaly
idx=(data(:,1)>=base_year(1))&(data(:,1)<=base_year(2));
meanval=mean(data(idx,3));
sim_anomaly=subset(:,3)-meanval;

% split to write output
sim_timedata=subset(:,1:2);

% write to output
save(output_file,'sim_anomaly','sim_timedata');
disp(['Data written to: ',output_file]);
disp('NOAA SST extractor job completed');