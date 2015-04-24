% this script messes up a bunch of images
input_dir = './dataset/image1/noise_image_0';
output_dir = './dataset/image1/twisted_image_0';

rng(42);

input_fnames = dir(fullfile(input_dir, '*.jpg'));

in_names = {input_fnames.name};


biggest_dim = 0;
for fname = in_names
    cur_name = fname{1};
    fpath = fullfile(input_dir, cur_name);   
   
    I = imread(fpath);
    
    tx = -2. + 4.*rand;
    ty = -2. + 4.*rand;

    sx = -2 + 4*rand;
    sy = -2 + 4*rand;
    
    shx = ((-12. + 24.*rand) / 180.0) * 2.0 * pi;
    shy = ((-12. + 24.*rand) / 180.0) * 2.0 * pi;
    
    rot = ((-12 + 24 * rand) /180) * 2 * pi;
    
    rotm = [cos(rot) sin(rot) 0;
            -sin(rot) cos(rot) 0;
            0 0 1];
        
    transm = [1 0 0;
              0 1 0;
              tx ty 1];
          
    scalem = [sx 0 0;
              0 sy 0;
              0 0 1];
          
    shearm = [1 shy 0;
              shx 1 0;
              0 0 1];
          
    trans_full = transm*rotm*shearm*scalem;
    
    tform = affine2d(trans_full);
    
    
    im_out = imwarp(I, tform);
    
    [r, c] = size(im_out);
    
    if r > biggest_dim
        biggest_dim = r;
    end
    if c > biggest_dim
        biggest_dim = c;
    end
    
    imwrite(im_out, fullfile(output_dir, cur_name));

end
%%
transformed_files= dir(fullfile(output_dir, '*.jpg'));
transformed_fnames = {transformed_files.name};

pad_out = './dataset/image1/pad_out_0';

for fname = transformed_fnames
    cur_name = fname{1};
    cur_file = fullfile(output_dir, cur_name);
    
    I = imread(cur_file);
    
    [m, n] = size(I);
    
    padded = padarray(I, [floor((biggest_dim-m)/2) floor((biggest_dim-n)/2)], 'replicate','post');
    padded = padarray(padded, [ceil((biggest_dim-m)/2) ceil((biggest_dim-n)/2)], 'replicate','pre');

    [r, c] = size(padded)
    
    imwrite(padded, fullfile(pad_out, cur_name));
end





