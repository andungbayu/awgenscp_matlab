function simulate_rain_meanens(dir,modeltype)
  
% load required data
regress=readawg([dir,"rain_regress.awg"]);
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
    prob_a=regress(modelclass(i),1);
    prob_b=regress(modelclass(i),2);
    alpha_a=regress(modelclass(i),3);
    alpha_b=regress(modelclass(i),4);
    beta_a=regress(modelclass(i),5);
    beta_b=regress(modelclass(i),6);
    
    % obtain predictor data
    mon_predict=mean(predict(i,3:nensemble+2),2);
    
    % call month length
    if (mod(getyear,4)==0),
        monlen=monlen_mod;
    else
        monlen=monlen_norm;
    end
    
    % loop to each day
    for day=1:monlen(getmonth,1)
      
        % create random probability seed
        seed=rand(1,1);
        
        % calculate rain probability
        prob=prob_a+(prob_b.*mon_predict);
        
        % calculate rain model
        alpha=alpha_a+(alpha_b.*mon_predict);
        beta=beta_a+(beta_b.*mon_predict);
        
        % generate rain rate
        rain=gamrnd(alpha,beta,[1,1]);  
       
        % simulate conditional probability
        if (seed<(1-prob)),rain=0;end
      
        % write time information
        dataout(row,1)=getyear;
        dataout(row,2)=getmonth;
        dataout(row,3)=day;
        
        % write data
        dataout(row,4)=rain;
      
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
label(4)=cellstr('rain');
fileout=[dir,"rain_sim_meanens.awg"];
saveawg(fileout,dataout,label);
disp(["rain mean ensemble written to:",fileout]);  

% terminate function
end