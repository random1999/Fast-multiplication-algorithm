% ======================================================================================
% 作者： cx
% 时间： 2025-07-24
% 实现： 比较竖式乘法、分治乘法和Karatsuba乘法的时间复杂度
% ======================================================================================
clear;clc;close all;

num1='1247981237489127147912376892752349857932875913898412';
num2='2317971447017321947928931239847194739479943583942589';
result1=BasicMultiply(num1,num2);
disp(strcat('竖式乘法计算—(',num1,')*(',num2,')='));
disp(result1);
result2=RecursiveMultiply(num1,num2);
disp(strcat('普通分治法计算—(',num1,')*(',num2,')='));
disp(result2);
result3=Karatsuba(num1,num2);
disp(strcat('karatsuba法计算—(',num1,')*(',num2,')='));
disp(result3);


N = 2:1000:4000;  % 相乘两数的位数
Basic_time= zeros(size(N));
Recursive_time= zeros(size(N));
Karatsuba_time= zeros(size(N));
for i=1:length(N)
    num1=num2str( randi([0, 9], 1, N(i)));
    num1(num1==' ')=[];
    num2=num2str( randi([0, 9], 1, N(i)));
    num2(num2==' ')=[];

    tic % 开始计时
    BasicMultiply(num1,num2);
    Basic_time(i) = toc;

    tic % 开始计时
    RecursiveMultiply(num1,num2);
    Recursive_time(i) = toc;

    tic % 开始计时
    Karatsuba(num1,num2);
    Karatsuba_time(i) = toc;
end

plot(N,Basic_time);
hold on;
plot(N,Recursive_time);
hold on;
plot(N,Karatsuba_time);
legend('竖式乘法', '分治乘法', 'Karatsuba乘法')
title('乘法算法时间复杂度比较');
xlabel('位数');
ylabel('耗时');