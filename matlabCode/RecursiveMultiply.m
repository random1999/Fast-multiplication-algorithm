% ======================================================================================
% 作者： cx
% 时间： 2025-07-25
% 实现： 普通分治算法计算大数相乘
% ======================================================================================
function [result] = RecursiveMultiply(num1,num2)
    a=int8(str2num(num1(:)))';
    b=int8(str2num(num2(:)))';
    a=[zeros(1,2^ceil(log2(length(a)))-length(a)),a];  %将两数的长度补到2的整数次方
    b=[zeros(1,2^ceil(log2(length(b)))-length(b)),b];
    if length(a)>length(b)                             %将两数的长度对齐
        b=[zeros(1,length(a)-length(b)) b];
    else
        a=[zeros(1,length(b)-length(a)) a];
    end
    result=recursiveMultiply(a,b); %计算！
    for i=1:1:length(result)
        if result(i)~=0
            break;
        end
    end
    result(1:i-1)=[];
    result=strrep(mat2str(result), ' ', '');
    result=strrep(result, '[', '');
    result=strrep(result, ']', '');
end

%% 函数定义
function [r]=recursiveMultiply(X,Y) %实现普通分治乘法算法
  lenX=length(X);
  lenY=length(Y);
  if lenX==1 && lenY==1
       temp1=mod(X.*Y,10);
       temp2=(X.*Y-mod(X.*Y,10))/10;
       r=[temp2,temp1];
       return;
  end

  A=X(1:lenX/2);
  B=X(lenX/2+1:lenX);
  C=Y(1:lenY/2);
  D=Y(lenY/2+1:lenY);

  AC=recursiveMultiply(A,C);
  AD=recursiveMultiply(A,D);
  BC=recursiveMultiply(B,C);
  BD=recursiveMultiply(B,D);

  ac=[AC,zeros(1,lenX)];
  ad=[zeros(1,lenX/2),AD,zeros(1,lenX/2)];
  bc=[zeros(1,lenX/2),BC,zeros(1,lenX/2)];
  bd=[zeros(1,lenX),BD];
  r=Add(ad,bc);
  r=Add(r,ac);
  r=Add(r,bd);
end


function [result]=Add(A,B) %实现等长数字相加,A、B为存储数字的向量
  lenA=length(A);
  result=A;
  carryNum=int8(0);
  for i=lenA:-1:1
      temp1=result(i)+B(i)+carryNum;
      result(i)=mod(temp1,10);
      carryNum=(temp1-result(i))/10;
  end
  if carryNum~=0
     result=[carryNum,result];
  end
end