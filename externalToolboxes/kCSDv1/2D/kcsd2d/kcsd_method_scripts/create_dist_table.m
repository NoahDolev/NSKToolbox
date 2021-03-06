function [dt_int]=create_dist_table(dist_dens,dist_max,R,h,sigma,src_type)

%INPUT
% dist_dens - number of points at which we interpolate the potential basis value
% dist_max - maximum value of distance
% R - radius of the support of the basis function
% h - 
% sigma - 
% src_type - type of basis function in the source space (step/gauss/gauss_lim)

%OUTPUT
%dist_table - a table with the potential generated by a single source 
%             base elements as a function of distance. The last record
%             corresponds to the distance equal to the diagonal of the 
%             grid

if nargin<6
    src_type='step';
end;

% disp(['dist_dens:' num2str(dist_dens)])
% disp(['dist_max:' num2str(dist_max)])
% disp(['R:' num2str(R)])
% disp(['h:' num2str(h)])

dense_step = 3;
denser_step = 1;
sparse_step = 9;
border1 = 0.9*R/dist_max*dist_dens;
border2 = 1.3*R/dist_max*dist_dens;

xs = [1:dense_step:border1];
xs = [xs border1 (border1+denser_step):denser_step:border2];
xs = [xs border2 (border2+denser_step) ...
 (border2+denser_step+sparse_step/2):sparse_step:dist_dens];
 
xs = unique(xs);

dist_table=zeros(length(xs),1);

%disp(['Integrating at ' num2str(length(xs)) ' points.'])

for ii=1:length(xs)
    dist_table(ii) = ...
    b_pot_2d_cont(((xs(ii)-1)/dist_dens)*dist_max,R,h,sigma,src_type);
end;
dt_int = interp1(xs, dist_table, 1:dist_dens, 'spline', 'extrap');
dt_int = dt_int(:);

