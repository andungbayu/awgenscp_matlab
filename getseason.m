function dataout=getseason(month)
  
% create output array
dataout=zeros(size(month,1),1);

% indexing season
mam=(month==3)|(month==4)|(month==5);  
jja=(month==6)|(month==7)|(month==8);
son=(month==9)|(month==10)|(month==11);
djf=(month==12)|(month==1)|(month==2);      

% begin classify
dataout(mam)=1;
dataout(jja)=2;
dataout(son)=3;
dataout(djf)=4;
  
% terminate function
end