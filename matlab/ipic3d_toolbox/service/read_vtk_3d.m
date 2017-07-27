function [V,Vx,Vy,Vz,dx,dy,dz]=read_vtk_3d(filename,old)
% set old=0 for new VTKs and 1 for old
fid = fopen(filename,'r');
fgetl(fid); % # vtk DataFile Version x.x
fgetl(fid); % comments
fgetl(fid); % ASCII
fgetl(fid); % DATASET STRUCTURED_POINTS

s = fgetl(fid); % DIMENSIONS NX NY NZ
sz = sscanf(s, '%*s%d%d%d');

s=fgetl(fid); % ORIGIN OX OY OZ
oo = sscanf(s, '%*s%d%d%d');
s=fgetl(fid); % SPACING SX SY SZ
dd= sscanf(s, '%*s%f%f%f');
if (old)
 s=fgetl(fid); %uncomment for old VTK files from Alex convertoer
end
s=fgetl(fid); % POINT_DATA NXNYNZ
npoints = sscanf(s, '%*s%d%d%d');

s = fgetl(fid); % SCALARS/VECTORS name data_type (ex: SCALARS imagedata unsigned_char)
svstr = sscanf(s, '%s', 1);
dtstr = sscanf(s, '%*s%*s%s');

V=[];Vx=[];Vy=[];Vz=[];

if( strcmp(svstr,'SCALARS') > 0 )
fgetl(fid); % the lookup table
V=[];
%for np=1:npoints
%s=fgetl(fid); 
%V = [V;sscanf(s, '%g').'];
%end
V=fscanf(fid,' %f', [npoints, 1]);
V=reshape(V,sz(1),sz(2),sz(3));
Vx=[];
Vy=[];
Vz=[];
elseif( strcmp(svstr,'VECTORS') > 0 )
% read data
V=[];
%for np=1:npoints
%s=fgetl(fid); 
%V = [V;sscanf(s, '%g%g%g').'];
%end
V=fscanf(fid,' %f %f %f', [npoints, 3]);
Vx=V(1:3:end);
Vy=V(2:3:end);
Vz=V(3:3:end);
     Vx=reshape(Vx,sz(1),sz(2),sz(3));
     Vy=reshape(Vy,sz(1),sz(2),sz(3));
     Vz=reshape(Vz,sz(1),sz(2),sz(3));
     V=sqrt(Vx.^2+Vy.^2+Vz.^2);
end


%V=V';
%Vx=Vx';
%Vy=Vy';
%Vz=Vz';
dx=dd(1);
dy=dd(2);
dz=dd(3);
fclose(fid);


