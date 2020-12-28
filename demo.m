clear; 
close all; 
clc; 

addpath('./Data/'); 
addpath('./Utils/'); 


%% load data: 20 shapes, the first 10 and the second 10 of which consist two classes (interpreted as humans in two different poses)
data_path = './Data/'; 

shapes = cell(20, 1); 
for i = 1:10
    % load ten shapes in rest pose, compute the first 60 eigenbasis of each of them
    shapes{i} = compute_laplacian_basis(read_off_shape([data_path 'tr_reg_0' num2str(i-1) '0.off']), 60); 
    % process the other ten shapes in a different pose. 
    shapes{i+10} = compute_laplacian_basis(read_off_shape([data_path 'tr_reg_0' num2str(i-1) '4.off']), 60); 
end

%% Analyze the area-based variability between the two classes. 

% set the dimension of the encoded functional maps.
ndim = 60; 

% set maps across the shapes of interest, here all the shapes are in identity
% to each other. 
Maps = cell(20, 1); 
for i = 1:20; for j = 1:20; Maps{i, j} = 1:6890; end; end

% set connectivity graph of the functional maps network: G(i, j) = 1 iff
% Fmaps{i, j} is given. Here we use the dense graph.
G = ones(20) - eye(20); 
% convert the p2p maps to functional maps.
Fmaps = convert_fmaps(shapes, Maps, G, ndim);

% compute the consistent latent basis.
U_nn = extract_latent_basis(Fmaps, G); 
% canonicalize the first 40 consistent latent basis.
U = canonical_latent_basis(U_nn, shapes, 40); 

% slect the size of limit shape difference
nCLB = 30; 

% construct limit shape differences.
nshapes_all = length(shapes); 
DA = cell(nshapes_all, 1); 

for i = 1:nshapes_all
    DA{i} = U.area_lsd{i}(1:nCLB, 1:nCLB); 
end

% construct the graphs Gg and Gc. 
% Gg contains edges within the same classes, while Gc contains that across
% different classes.
na = 10; nb = 10; 
Ag = zeros(nCLB); 
Ac = zeros(nCLB); 
Gg = blkdiag(G(1:na, 1:na), G(na+1:end, na+1:end)); 
Gc = G - Gg; 

for i = 1:nshapes_all
    for j = 1:nshapes_all
        if Gg(i, j) == 1
            Ag = Ag + (DA{i} - DA{j})^2; 
        end
        if Gc(i, j) == 1
            Ac = Ac + (DA{i} - DA{j})^2; 
        end
    end
end

E = Ac/nnz(Gc) - Ag/nnz(Gg); 
[u, v] = eig((E+E')/2); 
[~, id] =sort(diag(v), 'descend'); 
u = u(:, id);             

figure(1); 
% we plot the first highlighted funciton (w.r.t u(:, 1)) on shape 1 and shape 11, i.e., the
% first shapes in the respective classes. 
para.view_angle = [0, 90]; 
fa = (shapes{1}.evecs(:, 1:ndim)*U.cbases{1}(:, 1:nCLB)*u(:, 1)).^2;
fb = (shapes{11}.evecs(:, 1:ndim)*U.cbases{11}(:, 1:nCLB)*u(:, 1)).^2; 
subplot(121); plot_function(shapes{1}, fa, para); title('Area Diff: Class A'); 
subplot(122); plot_function(shapes{11}, fb, para); title('Area Diff: Class B'); 

figure(2); 
% plot everything in one figure.
for i = 1:20
    subplot(2, 10, i); plot_function(shapes{i}, (shapes{i}.evecs(:, 1:ndim)*U.cbases{i}(:, 1:nCLB)*u(:, 1)).^2, para); 
end



%% Analyze the extrinsic (i.e., coordinate based) variability across the two classes
DE = cell(20, 1); 
% construct extrinsic limit shape difference, please refer to our paper for the
% exact formulation.
for i = 1:nshapes_all
    M = squareform(pdist(shapes{i}.surface.VERT)).^2; 
    M = shapes{i}.A*M*shapes{i}.A; 
    M = diag(sum(M)) - M; 
    
    DE{i} = U.cbases{i}(:, 1:nCLB)'*shapes{i}.evecs'*M*shapes{i}.evecs*U.cbases{i}(:, 1:nCLB); 
end


Ag = zeros(nCLB); 
Ac = zeros(nCLB); 
Gg = blkdiag(G(1:na, 1:na), G(na+1:end, na+1:end)); 
Gc = G - Gg; 

for i = 1:nshapes_all
    for j = 1:nshapes_all
        if Gg(i, j) == 1
            Ag = Ag + (DE{i} - DE{j})^2; 
        end
        if Gc(i, j) == 1
            Ac = Ac + (DE{i} - DE{j})^2; 
        end
    end
end

E = Ac/nnz(Gc) - Ag/nnz(Gg); 
[u, v] = eig((E+E')/2); 
[~, id] =sort(diag(v), 'descend'); 
u = u(:, id);             

figure(3); 
% we plot the first highlighted funciton (w.r.t u(:, 1)) on shape 1 and shape 11, i.e., the
% first shapes in the respective classes. 
para.view_angle = [0, 90]; 
fa = (shapes{1}.evecs(:, 1:ndim)*U.cbases{1}(:, 1:nCLB)*u(:, 1)).^2;
fb = (shapes{11}.evecs(:, 1:ndim)*U.cbases{11}(:, 1:nCLB)*u(:, 1)).^2; 
subplot(121); plot_function(shapes{1}, fa, para); title('Ext Diff: Class A'); 
subplot(122); plot_function(shapes{11}, fb, para); title('Ext Diff: Class B'); 


% plot everything in one figure.
figure(4); 
for i = 1:20
    subplot(2, 10, i); plot_function(shapes{i}, (shapes{i}.evecs(:, 1:ndim)*U.cbases{i}(:, 1:nCLB)*u(:, 1)).^2, para); 
end


