clc;
clear all;
close all;
tic;
im = imread('C:\Users\nEW u\Downloads\SalientRegionDetection-MATLABCode\Salient Region Detection\test\pic.jpg');
img = imresize(im, [400 300]);
 %imshow(rgb2gray(img));
 I = img;
 [h, w, ch] = size(I);

 I = double(I);
tmpI = reshape(I, [], ch);
tmpMin = min(tmpI);  tmpLen = max(tmpI) - tmpMin + eps;
tmpI = (tmpI - repmat(tmpMin, size(tmpI,1), 1)) ./ repmat(tmpLen, size(tmpI,1), 1);
I = reshape(tmpI, [h, w, ch]);

img = I;
if size(img, 3)>1
    C = makecform('srgb2lab');
    img = applycform(img, C);
end
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);    

%figure, imshow(just_blue)
total2 = 0;
total =0;
total1 = 0;
total3=0;
totalg2 = 0;
totalg =0;
totalg1 = 0;
totalg3=0;
totalb2 = 0;
totalb =0;
totalb1 = 0;
totalb3=0;
for i=1:16
    for j=1:300
    
        total =  total + int32(red(i,j));
                totalg =  totalg + int32(green(i,j));
        totalb =  totalb + int32(blue(i,j));

    end
end


for i=17:383
    for j=1:16
total2=  total2    + int32(red(i,j));
totalg2=  totalg2    + int32(green(i,j));
totalb2=  totalb2    + int32(blue(i,j));

    end
end
for i=384:400
    for j=1:300
        total1 = total1 + int32(red(i,j));
        totalg1 = totalg1 + int32(green(i,j));
        totalb1 = totalb1 + int32(blue(i,j));

    end
end

for i=17:383
    for j=284:300
        totalg3 = totalg3+ int32(green(i,j));
        totalb3 = totalb3+ int32(blue(i,j));
        total3 = total3+ int32(red(i,j));
    end 
end 
tot = total+total1+total2+total3;
totg = totalg+totalg1+totalg2+totalg3;

totb = totalb+totalb1+totalb2+totalb3;

mean = tot/21312;
meang = totg/21312;
meanb = totb/21312;

sir = [];
sib = [];
sig = [];
       
         str = std2(red);
                  stg = std2(green);
         stb = std2(blue);

for x=1:400
    for y=1:300
   

R(x,y) = double(1/(str*sqrt(2*pi)) .* (exp(double(-(red(x,y)-mean)^2 / (2*(str)^2)))));
Rg(x,y) = double(1/(stg*sqrt(2*pi)) .* exp(double(-((green(x,y))-meang)^2 / (2*(stg)^2))));
Rb(x,y) = double(1/(stb*sqrt(2*pi)) .* exp(double(-((blue(x,y))-meanb)^2 / (2*(stb)^2))));
 
     end
end
for x=1:400
    for y=1:300
       if R(x,y) > 0
          sir(x,y) =  abs(mean-int32(red(x,y)));
       else
           sir(x,y) = 0;
       end
       if Rg(x,y) > 0
            sig(x,y) = abs(meang-int32(green(x,y)));
                   else
           sig(x,y) = 0; 
       end
       if Rb(x,y) > 0
            sib(x,y) = abs(meanb-int32(blue(x,y)));
       else 
           sib(x,y)=0;
       end          
           
    end
end

med = median(sir);
meg = median(sig);
meb = median(sib);
s=0;
s2=0;
s3 = 0 ;
 

fir = [];
fig= [];
fib= [];
for x=1:400
    for y=1:300
        if sir(x,y) > (med+8)
            fir(x,y) = sir(x,y);
        else
            fir(x,y) = 0  ;
        end
        if sig(x,y) > (meg+8)
            fig(x,y) = sig(x,y);
        else
            fig(x,y)=0; 
        end
        if sib(x,y) > (meb+8)
            fib(x,y) = sib(x,y);
        else
            fib(x,y)=0;
        end
    end
end

sqare = ((fir).^2) + ((fig).^2) + ((fib).^2);
salMap = sqrt(sqare);
imshow(imresize(salMap, [400 400]),[]);
toc;