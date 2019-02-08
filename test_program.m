% initiate condition
clc
clear

% define default directory
dir="C:/Users/andung/dropbox_geo/Dropbox/hibah_2018/awgenscp/src/octave_script/";

% -----------------create dummy input --------------------

% create rain and temp data
[rain,temp]=maketest_var(5000,0.3);

% save data to txt
dlmwrite("rain.txt",rain);
dlmwrite("temp.txt",temp);

% TESTING: return back rain and temp distibution
% [alpha,beta]=gamma_estimator(rain);
% disp(["gamma param* ",num2str(alpha)," ",num2str(beta)]);
% [meantemp,stdtemp]=normaldist_estimator(temp);
% disp(["ndist param* ",num2str(meantemp)," ",num2str(stdtemp)]);

% create predictor observed and future data
predict_now=maketest_predictor([500,1]);
predict_future=maketest_predictor([24,5]);

% save predictor data to text
dlmwrite("predict_now.txt",predict_now);
dlmwrite("predict_future.txt",predict_future);


% --------------- begin program setup -------------------

% add time attribute for rain and temp data
rain_time=addtime_attrib_day("rain.txt",1990,01,01);
temp_time=addtime_attrib_day("temp.txt",1990,01,01);

% save as .awg
saveawg("rain.awg",rain_time);
saveawg("temp.awg",temp_time);

% add time attribute for obs predictor data
predict_timenow=addtime_attrib_month("predict_now.txt",1990,01);

% save as .awg
saveawg("predict_now.awg",predict_timenow);

% add time attribute for future predictor data
predict_timefuture=addtime_attrib_month("predict_future.txt",1990,01);

% save as .awg
saveawg("predict_future.awg",predict_timefuture);

% --------------begin model building ---------------------

% define model setup
start_year=1990;
start_month=1;
end_year=2000;
end_month=12;

% setting up rain parameter
getrain_param([dir,"rain.awg"],...
start_year,start_month,end_year,end_month);
    
% setting up temperature parameter
gettemp_param([dir,"temp.awg"],...
start_year,start_month,end_year,end_month);
    
% formatting predictor parameter
predictnow_format([dir,"predict_now.awg"],...
start_year,start_month,end_year,end_month);

% --------------calculate regression model---------------

% create rain model
build_rainmodel(dir,1);

% create temp model
build_tempmodel(dir,1);

% ----------------running model simulation---------------

% simulating rain
simulate_rain(dir,1);

% simulating rain
simulate_temp(dir,1);

% simulating rain mean ensemble
simulate_rain_meanens(dir,1);

% simulating rain
simulate_temp_meanens(dir,1);

% ----------------------post processing-------------------

% calculate monthly rain ensemble
getrain_month(dir);

% calculate monthly temperature ensemble
gettemp_month(dir);

% calculate monthly rain ensemble mean
getrain_monthmean(dir);

% calculate monthly temperature ensemble mean
gettemp_monthmean(dir);

% --------------------------extras-----------------------

