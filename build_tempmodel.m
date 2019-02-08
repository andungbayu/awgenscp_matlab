function build_tempmodel(dir,modeltype)

% load required file
temp=readawg([dir,"temp_param.awg"]);
predict=readawg([dir,"predict_now_param.awg"]);

% get month value for classify model
monthval=temp(:,2);

% classify modelclass
if modeltype==1,
    modelclass=getseason(monthval);
    maxclass=4;
elseif modeltype==2,
    modelclass=monthval;
    maxclass=12;
end
    
% subset data to each monthclass
for i=1:maxclass
      
    % build selection
    select=(modelclass==i);
    
    % subset rain parameter
    temp_param=temp(select,3:4);
    predict_param=predict(select,3);
      
    % create mean value regression model
    [meanval_a,meanval_b]=regress(predict_param,temp_param(:,1));
    
    % create deviation regression model
    [stdev_a,stdev_b]=regress(predict_param,temp_param(:,2));
    
    % store to array
    dataout(i,1)=meanval_a;
    dataout(i,2)=meanval_b;
    dataout(i,3)=stdev_a;
    dataout(i,4)=stdev_b;
  
% terminate loop:i
end
  
% save output
label(1)=cellstr('mean_reg_a');
label(2)=cellstr('mean_reg_b');
label(3)=cellstr('std_reg_a');
label(4)=cellstr('std_reg_b');
fileout=[dir,"temp_regress.awg"];
saveawg(fileout,dataout,label);
disp(["regression model written to:",fileout]);  
  
% terminate function
end  