clc;

%---- Коорд-ты левого верхнего угла ----
y1 = 60.0994205474854;
x1 = 29.5567417144775;
 
%---- Коорд-ты пр. ниж. угла ----
y2 = 59.8077678680420;
x2 = 30.3299045562744;
 


D = [59.8850000000000 30.1666666666667 11.2500000000000;
     59.9083333333333 29.9366666666667 13.8000001900000; 
     59.9900000000000 29.8583333333333 13.8999996200000; 
     59.9583333333333 29.7966666666667 15.6999998100000; 
     59.9366666666667 29.7883333333333 6.30999994300000; 
     60 29.9383333333333 12.5000000000000; 
     59.9383333333333 30.1283333333333 15.4200000800000; 
     59.9016666666667 30.0866666666667 35.2000007600000];
 
 extraPoints = [59.9354735000362 29.6722798375239;
    59.9613064558725 29.6825795201412;
    59.9884953308607 29.6908192662349;
    60.0170367350607 29.7224049595943;
    60.0232231769916 29.8034291295162;
    60.0307828061665 29.8817067174068;
    60.0373101804513 29.9565510777584;
    60.0142868323772 29.9654774693599;
    59.9991582646393 30.0121693638912;
    59.997094740078 30.0684742955318;
    59.9888393502842 30.1288991002193;
    59.9833346089204 30.1941304234615;
    59.9633722197987 30.2167897252193;
    59.9327167923843 30.2112965611568;
    59.9051370691063 30.2085499791255;
    59.8806407981471 30.1714711217037;
    59.8616523537842 30.1330189732662;
    59.8619976953451 30.0629811314693;
    59.8685585015234 29.9970631627193;
    59.8854724832936 29.9496846226802;
    59.8892683129267 29.8933796910396;
    59.9023778318175 29.8322682408443;
    59.9172060277456 29.7766499547115;
    59.9289259439731 29.7217183140865];
 
n = 3500;
k = 3500;

%---- Кол-во опорных точек ----
p = 8;
 
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

[X,Y] = meshgrid(mX,mY);

for a = 1:p
    
    Z_extraPoints = idw_interp(D(:,2),D(:,1),D(:,3),extraPoints(:,2),extraPoints(:,1), -2,'ng',2);
    for i = 1 : length(extraPoints)
        extraPoints(i,3) = Z_extraPoints(i,i); 
    end

    points = cat(1, D, extraPoints);
    
    %Текущая точка
    y_test = points(a,1);
    x_test = points(a,2);
    z_test = points(a,3);
    
    x = points(:,2);
    y = points(:,1);
    z = points(:,3);
    
    %Удаление текущей точки
    x(a,:)=[];
    y(a,:)=[];
    z(a,:)=[];
        
    Z = griddata(x,y,z,X(1,:),Y(:,1),'linear');

    
    %Поиск в регулярной сетке ближайщей точки к иследуемой
    for i = 1:n
        if((X(1,i) >= (x_test-0.00015)) && (X(1,i) <= (x_test+0.00015)))           
            ii=i;
        end
    end
    for j = 1:k
        if((Y(j,1) >= (y_test-0.00015)) && (Y(j,1) <= (y_test+0.00015)))
            jj=j;
        end
    end
    
    disp(Z(jj,ii));
    d(1,a) = abs(z_test - Z(jj,ii)); %Разница
    disp('________________')  
    
    
    figure;
    clmp=colorGradient([1 1 1], [0 0.75 0.2], 64);

    imagesc(X(1,:),Y(:,1), Z); axis xy
    colormap(clmp);
    colorbar('TickLabels',{'0','3.5','7','10.5','14','17.5','21','24.5','28','31.5','35'})
    hold on

    [img, map, alphachannel] = imread('test7.png');
    imagesc([29.5567417144775,30.3299045562744], [59.8077678680420,60.0994205474854], img, 'AlphaData', alphachannel);

    plot(D(:, 2), D(:, 1), 'or')
end

sum = 0;
for o = 1:p
    sum = sum+d(1,o);
end

disp(sum/p); %Среднее значение
disp(var(d(1,:))); %Дисперсия











     
    