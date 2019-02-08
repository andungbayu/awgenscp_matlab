function simulate_temp(dir,modeltype)
  
% load required data
regress=readawg([dir,"temp_regress.awg"]);
predict=readawg([dir,"predict_future.awg"]);

% identify number of ensemble
nensemble=size(predict,2)-2;

% get month value for classify model
monthval=predict(:,2);

% clasify modeltype
if modeltype==1,
    modelclass=getseason(monthval);
elseif modeltype==2,
    modelclass=monthval;
end

% define month length
monlen_norm=[31;28;31;30;31;30;...
             31;31;30;31;30;31];
monlen_mod=[31;29;31;30;31;30;...
             31;31;30;31;30;31];
             
% initiate row to write
row=1;             

% loop to each monthly data in simulation
for i=1:size(predict,1)
  
    % obtain year and month
    getyear=predict(i,1);
    getmonth=predict(i,2);
    
    % obtain rain parameter
    mean_a=regress(modelclass(i),1);
    mean_b=regress(modelclass(i),2);
    stdev_a=regress(modelclass(i),3);
    stdev_b=regress(modelclass(i),4);
    
    % obtain predictor data
    mon_predict=predict(i,3:nensemble+2);
    
    % call month length
    if (mod(getyear,4)==0),
        monlen=monlen_mod;
    else
        monlen=monlen_norm;
    end
    
    % loop to each day
    for day=1:monlen(getmonth,1)
        
        % calculate new mean
        meanval=mean_a+(mean_b.*mon_predict);
        
        % calculate new stdev
        stdev=stdev_a+(stdev_b.*mon_predict);
        
        % generate rain rate
        for j=1:nensemble
        temp(1,j)=(stdev(j).*randn(1,1))+meanval(j);  
        end
      
        % write time information
        dataout(row,1)=getyear;
        dataout(row,2)=getmonth;
        dataout(row,3)=day;
        
        % write data
        dataout(row,4:(nensemble+3))=temp;
      
        % add row increment
        row=row+1;
        
    % terminate loop day  
    end
    
% terminate loop: i  
end  
             
% save output
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('day');
for i=1:size(predict,2)
label(i+3)=cellstr(['ensemble',num2str(i)]);
end
fileout=[dir,"temp_sim.awg"];
saveawg(fileout,dataout,label);
disp(["temp simulation written to:",fileout]);  

% terminate function
end