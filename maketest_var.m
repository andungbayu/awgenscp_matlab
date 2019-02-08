function [rain_data,temp_data]=maketest_var(ndata,prob);
% function to generate random climatological data

% define rain probability threshold
rain.problimit=1-prob;

% generate rainfall data
rain.dist=gamrnd(2,5,[ndata,1]);
rain.prob=rand(ndata,1);
rain.dist(rain.prob<rain.problimit)=0;
rain_data=rain.dist;
 
% generate temp data
temp.mean=25;
temp.stdev=3;
temp.data=(temp.stdev.*randn(ndata,1))+temp.mean;
temp_data=temp.data;

% terminate function
end