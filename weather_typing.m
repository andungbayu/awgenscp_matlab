function type=weather_typing(nclass,minrange,maxrange)
  % classify observed predictor data
  
  % load file
  load("predict_now.mat","predict_now");
  
  % generate output array
  type=zeros(size(predict_now));
  
  % define minmax range
  if nargin==1,
    minrange=min(predict_now);
    maxrange=max(predict_now);
  end
  
  % define range
  range=(maxrange-minrange)./nclass;
  
  % define initial and endrange
  initrange=minrange:range:(maxrange-range);
  endrange=(minrange+range):range:maxrange;
  
  % loop to classify
  for i=1:nclass
    selection=((predict_now>=initrange(i))&...
    predict_now<=endrange(i));
    type(selection==1)=i;
  end
    
  % terminate function
  end