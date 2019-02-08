function saveawg(filename,datain,label)

% get data size
row=size(datain,1);
col=size(datain,2);
  
% open file 
fileID=fopen(filename,'w');

    % write data size to file
    fprintf(fileID,'%d\n',row);
    fprintf(fileID,'%d\n',col);
    
    % write label to file
    for i=1:col
        if nargin==3
        writelabel=char(label(i));
        else
        writelabel=["column ",num2str(i)];
        end
        fprintf(fileID,'%s,',writelabel);
    end
    fprintf(fileID,'%s\n',"");

% close file    
fclose(fileID);

% write input data to file
dlmwrite(filename,datain,"-append");

% terminate function
end