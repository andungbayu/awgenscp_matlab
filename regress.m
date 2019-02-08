function [param_a,param_b]=regress(x,y)
% get a and b parameter in regression y=a+bx  

% indexing nan data  
idx=y==-9999;
x(idx)=[];
y(idx)=[];

% get number of data
ndata=length(x);  
  
% generate regression matrix
matrix(:,1)=x;
matrix(:,2)=y;
matrix(:,3)=x.*y;
matrix(:,4)=x.^2;
matrix(:,5)=y.^2;

% calculate matrix sum
matrixsum=sum(matrix,1);

% calculate param_a
param_a=((matrixsum(2).*matrixsum(4))-...
        (matrixsum(1).*matrixsum(3)))./...
        ((ndata.*matrixsum(4))-...
        (matrixsum(1).^2));
        
% calculate param_b
param_b=((ndata.*matrixsum(3))-...
        (matrixsum(1).*matrixsum(2)))./...
        ((ndata.*matrixsum(4))-...
        (matrixsum(1).^2));

% terminate function
end  
