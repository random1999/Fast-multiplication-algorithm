% ======================================================================================
% 作者： cx
% 时间： 2025-07-24
% 实现： 竖式乘法算法(手算乘法)
% ======================================================================================
function [result] = BasicMultiply(num1,num2)
    %数据预处理
    a=uint8(str2num(num1(:)))';
    b=uint8(str2num(num2(:)))';
    len1=length(a);
    len2=length(b);
    M=zeros(len2,len1+len2);  %存储竖式的矩阵
    result=zeros(1,len1+len2);
    carryNum=uint8(0);
    
    for i=1:1:len2        %实现个位数乘n位数
        for j=1:1:len1
            single_mult=b(len2-i+1)*a(len1-j+1)+carryNum;
            M(i,len1+len2-i-j+2)=mod(single_mult,10);
            carryNum=(single_mult-M(i,len1+len2-i-j+2))/10;
        end
        M(i,len2-i+1)=carryNum;
        carryNum=0;
    end
    
    for i=1:1:size(M,1)   %实现n位数相加
        for j=size(M,2):-1:1
            single_add=result(1,j)+M(i,j)+carryNum;
            result(1,j)=mod(single_add,10);
            carryNum=(single_add-result(1,j))/10;
        end
    end
    if(result(1)==0)
        result(1)=[];
    end

    %结果后处理
    result=strrep(mat2str(result), ' ', '');
    result=strrep(result, '[', '');
    result=strrep(result, ']', '');
end