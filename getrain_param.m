function getrain_param(filein,fileout,start_year,start_month,...
         end_year,end_month)

% load file input
%datain=readawg(filein);
load(filein);         
         
% create initial loop value
i=1;
year=start_year;
month=start_month;

% begin while loop to populate data
while ((year<=end_year)&&(month<=end_month))
  
    % create notification
    disp(['processing year:',num2str(year),...
    ' month:',num2str(month)])
    
    % create data selection
    select=((timedimension(:,1)==year)&(timedimension(:,2)==month));
    
    % subset data
    subset=data(select);
    
    % estimate rain probability
    prob=rainprob_estimator(subset);
    
    % estimate gamma distribution
    [alpha,beta]=gamma_estimator(subset);
   
    % !!!!if alpha and beta in log!!!!
    if alpha>0,alpha=log10(alpha);else, alpha=-9999;end
    if beta>0,beta=log10(beta);else, beta=-9999;end
 
    % store result to array
    dataout(i,1)=year;
    dataout(i,2)=month;
    dataout(i,3)=prob;
    dataout(i,4)=alpha;
    dataout(i,5)=beta;
    
    % add time increment
    i=i+1;
    
    % change timerange for next selection
    if (month==12),
        year=year+1;
        month=1;
    else
        month=month+1;
    end
  
% terminate while loop
end

% save output
label(1)=cellstr('year');
label(2)=cellstr('month');
label(3)=cellstr('rain_probability');
label(4)=cellstr('gammadist_a');
label(5)=cellstr('gammadist_b');

% save output
rain_param=dataout;
disp(['writing rain parameter to:',fileout]);
save(fileout,'rain_param','label');
         
% terminate function
end 
