% Compute the cotangent weight Laplacian.
% W is the symmetric cot Laplacian
function [At] = triangleAreas(X, T)

% Triangle areas
N = cross(X(T(:,1),:)-X(T(:,2),:), X(T(:,1),:) - X(T(:,3),:));
At = normv(N)/2;
