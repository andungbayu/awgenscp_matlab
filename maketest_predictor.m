function predic_data=maketest_predictor(ndata);
% function to generate random climatological predictor
 
% generate temp data
predic.mean=0;
predic.stdev=0.5;
predic.data=(predic.stdev.*...
    randn(ndata(1),ndata(2)))+predic.mean;
predic_data=predic.data;

% terminate function
end