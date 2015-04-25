% im_a = im2double(imread('dataset/image1/original_image/image013.jpg'));
% im_b = im2double(imread('dataset/image1/original_image/image013.jpg'));
% im_b = im2double(imread('image013_rot.jpg'));


im_a = im2double(apple);
im_b = im2double(apple2);

p = [0 0 0 1.5]';

[im_rows, im_cols] = size(im_a);

reg_param = 15;
numiter = 100;
costs = zeros(1,numiter);


for iter = 1:numiter
[grad_a_x, grad_a_y] = imgradientxy(im_a);
imdiff = im_a - im_b;
imsum = im_a + im_b;

cost = sum(sum(imdiff.^2))/sum(sum(imsum.^2)); %+ ...
   %     sum((p - [0 0 0 0 0]').^2);

costs(iter) = cost; 

    
term1 = 0;
term2 = 0;

for i = 1:size(im_a,1)
    for j = 1:size(im_a,2)
        
        x = j - im_cols /2 ;
        y = (im_rows - i) - im_rows/2;
        
        tx = p(1);
        ty = p(2);
        theta = p(3);
        s = p(4);
        
        
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
          
         sc = [s 0 0;
               0 s 0;
               0 0 1]; 
        
        dmdtx = [0 0 1;
                0 0 0;
                0 0 0];
        dmdty = [0 0 0;
                0 0 1;
                0 0 0];
        drdt = [-sin(theta) cos(theta) 0;
                -cos(theta) -sin(theta) 0;
                0 0 0];

        ds = [1 0 0;
              0 1 0;
              0 0 0];
             
       dT_dtx = dmdtx * sc * r;
       dT_dty = dmdty * sc* r;
       dT_dtheta = m * sc * drdt;
       dT_ds = m * ds * r;

       im_grads = [grad_a_x(i,j) grad_a_y(i,j) 0];
       
       coords = [x; y; 1];
       
       grad_a_tx = im_grads * dT_dtx * coords;
       grad_a_ty = im_grads * dT_dty * coords;
       grad_a_theta = im_grads * dT_dtheta * coords;
       grad_a_s = im_grads * dT_ds * coords;
       
       grad_p_i = [grad_a_tx; grad_a_ty; grad_a_theta; grad_a_s];
       
       term1 = term1 + imdiff(i,j)*grad_p_i;
       term2 = term2 + imsum(i,j)*grad_p_i;
    end
end
term1 = 2 * term1 / sum(sum(imsum.^2));
term2 = 2 * sum(sum(imdiff.^2)) * term2 / sum(sum(imsum.^2))^2;

gradp = term1 - term2; % + reg_param * (p - [0 0 0 0 0]');


p = p - 0.25 * gradp;

transform = param2tf(p);

im_a = imtransform(im_a, transform, 'Size', [im_rows, im_cols]);

if mod(iter, 2) == 0
    figure()
    imshow(im_a)
    title(sprintf('iteration %d', iter))
end

end

title('alignment cost function');
plot(costs);