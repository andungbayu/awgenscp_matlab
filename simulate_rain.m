function simulate_rain(regressfile,simulationfile,outputfile,modeltype)
  
% load required data
load(regressfile);
load(simulationfile);
%regress=readawg([dir,"rain_regress.awg"]);
%predict=readawg([dir,"predict_future.awg"]);
predict=sim_anomaly;
regress=regress_result;

% identify number of ensemble
nensemble=size(predict,2);

% get month value for classify model
monthval=sim_timedata(:,2);

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
    getyear=sim_timedata(i,1);
    getmonth=sim_timedata(i,2);
    
    % obtain rain parameter
    prob_a=regress(modelclass(i),1);
    prob_b=regress(modelclass(i),2);
    alpha_a=regress(modelclass(i),3);
    alpha_b=regress(modelclass(i),4);
    beta_a=regress(modelclass(i),5);
    beta_b=regress(modelclass(i),6);
    
    % obtain predictor data
    mon_predict=predict(i);
    
    % call month length
    if (mod(getyear,4)==0),
        monlen=monlen_mod;
    else
        monlen=monlen_norm;
    end
    
    % loop to each day
    for day=1:monlen(getmonth,1)
      
        % create random probability seed
        seed=rand(1,nensemble);
        
        % calculate rain probability
        prob=prob_a+(prob_b.*mon_predict);
        
        % calculate rain model
        alpha=alpha_a+(alpha_b.*mon_predict);
        beta=beta_a+(beta_b.*mon_predict);
        
        % !!!! convert alpha and beta from log10 !!!!!!
        if alpha~=-9999,alpha=10^alpha;end
        if beta~=-9999,beta=10^beta;end


        % generate rain rate
        for j=1:nensemble
        rain(1,j)=gamrnd(alpha(1,j),beta(1,j),[1,1]);  
        end
       
        % simulate conditional probability
        rain(seed<(1-prob))=0; 
      
        % write time information
        dataout(row,1)=getyear;
        dataout(row,2)=getmonth;
        dataout(row,3)=day;
        
        % write data
        dataout(row,4:(nensemble+3))=rain;
      
        % add row increment
        row=row+1;
        
    % terminate loop day  
    end
    
% terminate loop: i  
end  
             
% write label
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('day');
for i=1:size(predict,2)
label(i+3)=cellstr(['ensemble',num2str(i)]);
end

% save output
sim_result=dataout;
save(outputfile,'sim_result','label');
disp(['rain simulation written to:',outputfile]);  

% terminate function
end
