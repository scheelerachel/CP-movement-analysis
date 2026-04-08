function [x_out, y_out] = conv3Dto2D(x_in, y_in, z_in)

P = [x_in(:), y_in(:), z_in(:)];
N = size(P,1);

p1 = P(1,:);
p2 = P(round(N/2),:);
p3 = P(N,:);

% Create plane
v1 = p2 - p1;
v2 = p3 - p1;
n = cross(v1, v2);
n = n / norm(n);

% Define directionality
if dot(n, [0 0 1]) < 0
    n = -n;
end

vecX = [v1(1), v1(2), 0];
vecX = vecX / norm(vecX);

if dot(vecX, [0 1 0]) < 0
    vecX = -vecX;
end

vecY = cross(n, vecX);
vecY = vecY / norm(vecY);

if dot(vecY, [0 0 1]) < 0
    %vecX = -vecX;
    vecY = -vecY;
end

% Project trajectory into plane
Pshift = P - p1;
x_out = Pshift * vecX';
y_out = Pshift * vecY';

% traj_plane = [x_out, y_out];

% %% ================= Visualization =================
% figure; hold on; grid on; axis equal;
% title('3D Trajectory Projection onto Plane');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% 
% % Original 3D trajectory
% plot3(x_in, y_in, z_in, 'b.-', 'DisplayName', 'Original Trajectory');
% 
% % --- Plane surface for visualization ---
% [xx, yy] = meshgrid(linspace(min(x_in), max(x_in), 10), ...
%                     linspace(min(y_in), max(y_in), 10));
% 
% zz = p1(3) + (-n(1)*(xx-p1(1)) - n(2)*(yy-p1(2))) / n(3);
% surf(xx, yy, zz, 'FaceAlpha',0.2, 'EdgeColor','none', 'DisplayName','Plane');
% 
% % --- Plane axes ---
% scale = max(range(P));
% 
% quiver3(p1(1), p1(2), p1(3), vecX(1), vecX(2), vecX(3), scale, ...
%     'r', 'LineWidth',2, 'DisplayName','X-axis');
% 
% quiver3(p1(1), p1(2), p1(3), vecY(1), vecY(2), vecY(3), scale, ...
%     'g', 'LineWidth',2, 'DisplayName','Y-axis');
% 
% quiver3(p1(1), p1(2), p1(3), n(1), n(2), n(3), scale, ...
%     'k', 'LineWidth',2, 'DisplayName','Normal');
% 
% % --- Projected trajectory drawn back in 3D ---
% proj3D = p1 + traj_plane(:,1).*vecX + traj_plane(:,2).*vecY;
% 
% plot3(proj3D(:,1), proj3D(:,2), proj3D(:,3), ...
%       'm.-', 'DisplayName','Projected Trajectory');
% 
% legend;
% view(3);

end
