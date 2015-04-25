% im_a = im2double(imread('dataset/image1/original_image/image013.jpg'));
% im_b = im2double(imread('dataset/image1/original_image/image013.jpg'));
% im_b = im2double(imread('image013_rot.jpg'));


im_a = im2double(apple);
im_b = im2double(apple2);

p = [0 0 0 0 0]';


[grad_a_x, grad_a_y] = imgradientxy(im_a);
imdiff = im_a - im_b;
imsum = im_a + im_b;

reg_param = 15;
numiter = 1000;
costs = zeros(1,numiter);

for iter = 1:numiter
cost = sum(sum(imdiff.^2))/sum(sum(imsum.^2)) + ...
        sum((p - [0 0 0 0 0]').^2);

costs(iter) = cost;    
    
term1 = 0;
term2 = 0;
for i = 1:size(a,1)
    for j = 1:size(a,2)
        tx = p(1);
        ty = p(2);
        theta = p(3);
%         shx = p(4);
%         shy = p(5);
        sx = p(4);
        sy = p(5);
        
        
%         theta = 0;
%         shx = 0;
%         shy = 0;
%         sx = 0;
%         sy = 0;
        
        m = [1 0 tx;
             0 1 ty;
             0 0 1];
         
        r = [cos(theta) sin(theta) 0;
             -sin(theta) cos(theta) 0;
             0 0 1];
         
%         sh = [1 shx 0;
%               shy 1 0;
%               0 0 1];
          
%          sc = [sx 0 0;
%                0 sy 0;
%                0 0 1]; 
        
        dmdtx = [0 0 1;
                0 0 0;
                0 0 0];
        dmdty = [0 0 0;
                0 0 1;
                0 0 0];
        drdt = [-sin(theta) cos(theta) 0;
                -cos(theta) -sin(theta) 0;
                0 0 0];
%         dshdx = [0 1 0;
%                  0 0 0;
%                  0 0 0];
%         dshdy = [0 0 0;
%                  1 0 0;
%                  0 0 0];
        dscdx = [1 0 0;
                 0 0 0;
                 0 0 0];
        dscdy = [0 0 0;
                 0 1 0;
                 0 0 0];
             
       dT_dtx = dmdtx * r * sc;
       dT_dty = dmdty * r * sc;
       dT_dtheta = m * drdt * sc;
%        dT_dshx = m * r * dshdx * sc;
%        dT_dshy = m * r * dshdy * sc;
       dT_dsx = m * r * dscdx;
       dT_dsy = m * r * dscdy;
       
       im_grads = [grad_a_x(i,j) grad_a_y(i,j) 0];
       coords = [j; i; 1];
       
       grad_a_tx = im_grads * dT_dtx * coords;
       grad_a_ty = im_grads * dT_dty * coords;
       grad_a_theta = im_grads * dT_dtheta * coords;
%        grad_a_shx = im_grads * dT_dshx * coords;
%        grad_a_shy = im_grads * dT_dshy * coords;
       grad_a_sx = im_grads * dT_dsx * coords;
       grad_a_sy = im_grads * dT_dsy * coords;
       
       grad_p_i = [grad_a_tx; grad_a_ty; grad_a_theta; grad_a_sx; grad_a_sy];
       
       term1 = term1 + imdiff(i,j)*grad_p_i;
       term2 = term2 + imsum(i,j)*grad_p_i;
    end
end
term1 = 2 * term1 / sum(sum(imsum.^2));
term2 = 2 * sum(sum(imdiff.^2)) * term2 / sum(sum(imsum.^2))^2;

gradp = term1 - term2; % + reg_param * (p - [0 0 0 0 0]');


p = p - gradp;
end

title('alignment cost function');
plot(costs);