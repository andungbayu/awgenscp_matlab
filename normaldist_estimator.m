function [meanval,stdev]=normaldist_estimator(datain);
% function to overide gamfit error code in octave

meanval=mean(datain);
stdev=std(datain);

% terminate function
end