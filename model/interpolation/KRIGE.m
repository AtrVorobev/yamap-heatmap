%---- Коорд-ты левого верхнего угла ----
y1 = 60.0994205474854;
x1 = 29.5567417144775;
 
%---- Коорд-ты пр. ниж. угла ----
y2 = 59.8077678680420;
x2 = 30.3299045562744;
 

D = [59.9783333333333 30.2166666666667 2.04999995200000;
     59.8883333333333 30.2183333333333 9.60000038100000;
     59.8850000000000 30.1666666666667 11.2500000000000;
     59.9166666666667 30.2633333333333 2.60444400000000; 
     59.9083333333333 29.9366666666667 13.8000001900000; 
     59.9900000000000 29.8583333333333 13.8999996200000; 
     59.9583333333333 29.7966666666667 15.6999998100000; 
     59.9366666666667 29.7883333333333 6.30999994300000; 
     60 29.9383333333333 12.5000000000000; 
     59.9383333333333 30.1283333333333 15.4200000800000; 
     59.9016666666667 30.0866666666667 35.2000007600000];
 
n = 3500;
k = 3500;

 
stepX = (x2 - x1) / n;
stepY = (y2 - y1) / k;
 
%---- Массив коорд-т точек сетки по X ----
mX = [];
%---- Массив коорд-т точек сетки по Y ----
mY = [];
 
for i = 1:n
    for j = 1:k
        mX(i) = x1 + i * stepX;
        mY(j) = y1 + j * stepY; 
    end
end


% create random field with autocorrelation
[X,Y] = meshgrid(mX,mY);

% sample the field
x = D(:,2);
y = D(:,1);
z = D(:,3);

% plot the random field
%subplot(2,2,1)
%imagesc(X(1,:),Y(:,1),Z); axis xy
%hold on
%plot(x,y,'.k')
%title('random field with sampling locations')

% calculate the sample variogram
v = variogram([x y],z,'plotit',false,'maxdist',100);
% and fit a spherical variogram
figure('Name','KRIGE');
[dum,dum,dum,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable');
title('variogram')


% now use the sampled locations in a kriging
[Zhat,Zvar] = kriging(vstruct,x,y,z,X,Y);
figure('Name','KRIGE');
clmp=colorGradient([1 1 1], [0 0.75 0.2], 64);
imagesc(X(1,:),Y(:,1), Zhat); axis xy
colormap(clmp);
colorbar; %('TickLabels',{'0','3.5','7','10.5','14','17.5','21','24.5','28','31.5','35'})
hold on

[img, map, alphachannel] = imread('test7.png');
imagesc([29.5567417144775,30.3299045562744], [59.8077678680420,60.0994205474854], img, 'AlphaData', alphachannel);

plot(D(:, 2), D(:, 1), 'or')
%plot(x,y,'.k')
%title('kriging predictions')

figure('Name','KRIGE');
contour(X,Y,Zvar);
title('kriging variance')