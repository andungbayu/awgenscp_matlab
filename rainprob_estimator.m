function prob=rainprob_estimator(datain);

% define default threshold
threshold=1;

% count data
count=sum(datain>=threshold);
total=length(datain);

% get probability
prob=count./total;
  
% terminate function
end