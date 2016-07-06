function Iout = transformvolume_mlb_simplified(varargin)
global Isize Iin

Isize_d=varargin{1};
Def=varargin{2};
mat=varargin{3};
Iin=varargin{4};


Isize = Isize_d;

M = inv(mat);
new_posit          = zeros(size(Def),'single');
new_posit(:,:,:,1) = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
new_posit(:,:,:,2) = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
new_posit(:,:,:,3) = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);

new_x = new_posit(:,:,:,1);
new_y = new_posit(:,:,:,2);
new_z = new_posit(:,:,:,3);

Iout = arrayfun(@interpolate_3d_cubic_black, new_x, new_y, new_z);
            
function Ipixelxyz = interpolate_3d_cubic_black(Tlocalx, Tlocaly, Tlocalz)
global Isize Iin
fTlocalx = floor(Tlocalx); 
fTlocaly = floor(Tlocaly); 
fTlocalz = floor(Tlocalz);
xBas0=fTlocalx; 
yBas0=fTlocaly; 
zBas0=fTlocalz;
tx=Tlocalx-fTlocalx; 
ty=Tlocaly-fTlocaly; 
tz=Tlocalz-fTlocalz;

vector_tx = [0.5, 0.5*tx, 0.5*tx^2, 0.5*tx^3];
vector_ty = [0.5, 0.5*ty, 0.5*ty^2, 0.5*ty^3];
vector_tz = [0.5, 0.5*tz, 0.5*tz^2, 0.5*tz^3];

vector_qx(1)= -1.0*vector_tx(2)+2.0*vector_tx(3)-1.0*vector_tx(4);
vector_qx(2)= 2.0*vector_tx(1)-5.0*vector_tx(3)+3.0*vector_tx(4);
vector_qx(3)= 1.0*vector_tx(2)+4.0*vector_tx(3)-3.0*vector_tx(4);
vector_qx(4)= -1.0*vector_tx(3)+1.0*vector_tx(4);
vector_qy(1)= -1.0*vector_ty(2)+2.0*vector_ty(3)-1.0*vector_ty(4);
vector_qy(2)= 2.0*vector_ty(1)-5.0*vector_ty(3)+3.0*vector_ty(4);
vector_qy(3)= 1.0*vector_ty(2)+4.0*vector_ty(3)-3.0*vector_ty(4);
vector_qy(4)= -1.0*vector_ty(3)+1.0*vector_ty(4);
vector_qz(1)= -1.0*vector_tz(2)+2.0*vector_tz(3)-1.0*vector_tz(4);
vector_qz(2)= 2.0*vector_tz(1)-5.0*vector_tz(3)+3.0*vector_tz(4);
vector_qz(3)= 1.0*vector_tz(2)+4.0*vector_tz(3)-3.0*vector_tz(4);
vector_qz(4)= -1.0*vector_tz(3)+1.0*vector_tz(4);

% /* Determine 1D neighbour coordinates */
xn(1)=xBas0-1; xn(2)=xBas0; xn(3)=xBas0+1; xn(4)=xBas0+2;
yn(1)=yBas0-1; yn(2)=yBas0; yn(3)=yBas0+1; yn(4)=yBas0+2;
zn(1)=zBas0-1; zn(2)=zBas0; zn(3)=zBas0+1; zn(4)=zBas0+2;

% /* First do interpolation in the x direction followed by interpolation in the y direction */
Ipixelxyz = 0;
for j = 1:4
    Ipixelxy=0;
    if((zn(j)>=0)&&(zn(j)<Isize(3))) 
        for i = 1:4
            Ipixelx=0;
            if((yn(i)>=0)&&(yn(i)<Isize(2))) 
                if((xn(1)>=0)&&(xn(1)<Isize(1))) 
                    Ipixelx=vector_qx(1)*getcolor_mindex3(xn(1), yn(i), zn(j), Isize(1), Isize(2), Isize(3), Iin) + Ipixelx;
                end
                if((xn(2)>=0)&&(xn(2)<Isize(1)))
                    Ipixelx=vector_qx(2)*getcolor_mindex3(xn(2), yn(i), zn(j), Isize(1), Isize(2), Isize(3), Iin) + Ipixelx;
                end
                if((xn(3)>=0)&&(xn(3)<Isize(1)))
                    Ipixelx=vector_qx(3)*getcolor_mindex3(xn(3), yn(i), zn(j), Isize(1), Isize(2), Isize(3), Iin) + Ipixelx;
                end
                if((xn(4)>=0)&&(xn(4)<Isize(1))) 
                    Ipixelx=vector_qx(4)*getcolor_mindex3(xn(4), yn(i), zn(j), Isize(1), Isize(2), Isize(3), Iin) + Ipixelx;
                end
            end
            Ipixelxy = vector_qy(i)*Ipixelx + Ipixelxy;
        end
        Ipixelxyz = vector_qz(j)*Ipixelxy + Ipixelxyz;
    end
end
Ipixelxyz = single(Ipixelxyz);

function val = getcolor_mindex3(x, y, z, sizx, sizy, sizz, I)
val = I(z*sizx*sizy + y*sizx + x);




