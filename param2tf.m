function [ tf ] = param2tf( params )
%PARAM2TF unroll parameters into a transform object

tx = params(1);
ty = params(2);
theta = params(3);
s = params(4);
% sy = params(5);

m = [1 0 tx;
     0 1 ty;
     0 0 1];

r = [cos(theta) sin(theta) 0;
     -sin(theta) cos(theta) 0;
     0 0 1];

sc = [s 0 0;
      0 s 0;
      0 0 1]; 

tf_mat = r * sc * m;

tf = maketform('affine', tf_mat');

end

