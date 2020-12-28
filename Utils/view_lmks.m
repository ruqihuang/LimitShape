function view_lmks(shape, lm, para)
    
    rot_flag = false;
    view_angle = [0, 90]; 
%     normalize = false; 
    
    if nargin > 2
        if isfield(para, 'rot_flag'), rot_flag = para.rot_flag; end
        if isfield(para, 'view_angle'), view_angle = para.view_angle; end
%         if isfield(para, 'normalize'), normalize = para.normalize; end
    end
    if ~isfield(shape, 'surface'), shape.surface = shape; end
    
    f = zeros(length(shape.surface.X), 1); 
    
    if rot_flag
        trimesh(shape.surface.TRIV, shape.surface.Y, shape.surface.Z, shape.surface.X, f, ...
            'EdgeColor', 'flat', 'FaceColor', 'interp', ...
            'AmbientStrength', 0.35, 'DiffuseStrength', 0.65,  'FaceLighting', 'gouraud', ...
            'SpecularExponent', 10, 'BackFaceLighting', 'reverselit', 'LineStyle', 'none');
        hold on; 
        scatter3(shape.surface.Y(lm), shape.surface.Z(lm), shape.surface.X(lm), 50, 'r', 'filled'); 
        view(view_angle);
        hold off; 
        axis equal;
        axis off;
    else
        trimesh(shape.surface.TRIV, shape.surface.X, shape.surface.Y, shape.surface.Z, f, ...
            'EdgeColor', 'flat', 'FaceColor', 'interp', ...
            'AmbientStrength', 0.35, 'DiffuseStrength', 0.65,  'FaceLighting', 'gouraud', ...
            'SpecularExponent', 10, 'BackFaceLighting', 'reverselit', 'LineStyle', 'none');
        hold on;         
        scatter3(shape.surface.X(lm), shape.surface.Y(lm), shape.surface.Z(lm), 50, 'r', 'filled'); 
        view(view_angle);
        hold off; 
        axis equal;
        axis off;
    end
    
    colormap('hot');
    colormap(flipud(colormap)); 
    set(gca, 'Projection', 'perspective');    
    caxis([0, 1]); 
    camlight('headlight'); 
end