function [shape,scale]=gamma_estimator(datain);
% function to overide gamfit error code in octave

% delete zero value
datain(datain==0)=[];

% skip if data invalid
if length(datain)<=1,shape=0;scale=0;return;end

% calculate mean and stdev
meanval=mean(datain);
stdev=std(datain);

% calculate gamma parameter
shape=(meanval/stdev).^2;
scale=meanval./shape;

% terminate function
end