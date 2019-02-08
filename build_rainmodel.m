function build_rainmodel(rainfile,ninofile,fileout,modeltype)

% load required file
% rain=readawg([dir,"rain_param.awg"]);
% predict=readawg([dir,"predict_now_param.awg"]);
load(rainfile,'rain_param');
load(ninofile,'nino_param');
rain=rain_param;
predict=nino_param;

% get month value for classify model
monthval=rain(:,2);

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
    rain_param=rain(select,3:5);
    predict_param=predict(select,3);
      
    % create rain probability regression model
    [prob_a,prob_b]=regress(predict_param,rain_param(:,1));
    
    % create gamma alpha regression model
    [alpha_a,alpha_b]=regress(predict_param,rain_param(:,2));
    
    % create gamma beta regression model
    [beta_a,beta_b]=regress(predict_param,rain_param(:,3));
    
    % store to array
    dataout(i,1)=prob_a;
    dataout(i,2)=prob_b;
    dataout(i,3)=alpha_a;
    dataout(i,4)=alpha_b;
    dataout(i,5)=beta_a;
    dataout(i,6)=beta_b;
  
% terminate loop:i
end
  
% create label
label(1)=cellstr('prob_reg_a');
label(2)=cellstr('prob_reg_b');
label(3)=cellstr('alpha_reg_a');
label(4)=cellstr('alpha_reg_b');
label(5)=cellstr('beta_reg_a');
label(6)=cellstr('beta_reg_b');

% save output
regress_result=dataout;
save(fileout,'regress_result','label');
disp(['regression model written to:',fileout]);  
  
% terminate function
end  
