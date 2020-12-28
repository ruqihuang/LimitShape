function plot_function(shape, f, para)
%     figure; 
%     set(gcf,'color','w'); 
    rot_flag = false;
    view_angle = [0, 0]; 
    normalize = false; 
    
    if nargin > 2
        if isfield(para, 'rot_flag'), rot_flag = para.rot_flag; end
        if isfield(para, 'view_angle'), view_angle = para.view_angle; end
        if isfield(para, 'normalize'), normalize = para.normalize; end
    end
    if ~isfield(shape, 'surface'), shape.surface = shape; end
    
    if normalize && (norm(f) > 1e-7)
        f = f/max(abs(f)); 
    end
    M = max(abs(f)); 
    f = f+1e-2;
    
    if rot_flag
        trimesh(shape.surface.TRIV, shape.surface.Y, shape.surface.Z, shape.surface.X, f, ...
            'EdgeColor', 'flat', 'FaceColor', 'interp', ...
            'AmbientStrength', 0.35, 'DiffuseStrength', 0.65,  'FaceLighting', 'gouraud', ...
            'SpecularExponent', 10, 'BackFaceLighting', 'reverselit', 'LineStyle', 'none');
        view(view_angle);
        axis equal;
        axis off;
    else
        trimesh(shape.surface.TRIV, shape.surface.X, shape.surface.Y, shape.surface.Z, f, ...
            'EdgeColor', 'flat', 'FaceColor', 'interp', ...
            'AmbientStrength', 0.35, 'DiffuseStrength', 0.65,  'FaceLighting', 'gouraud', ...
            'SpecularExponent', 10, 'BackFaceLighting', 'reverselit', 'LineStyle', 'none');
        view(view_angle);
        axis equal;
        axis off;
    end
    
%     colormap('hot');
%     colormap(flipud(colormap)); 
    colormap(redblue(length(f))); 
    set(gca, 'Projection', 'perspective');  
%     caxis([-M, M]); 
%     caxis([0, 0.1]); 
    camlight('headlight'); 
end