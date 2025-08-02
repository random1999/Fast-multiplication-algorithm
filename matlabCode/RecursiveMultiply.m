% ======================================================================================
% 作者： cx
% 时间： 2025-07-25
% 实现： 普通分治乘法算法
% ======================================================================================
function [result] = RecursiveMultiply(num1,num2)
    %数据预处理
    a=int8(str2num(num1(:)))';
    b=int8(str2num(num2(:)))';
    a=[zeros(1,2^ceil(log2(length(a)))-length(a)),a];  %将两数的长度补到2的整数次方
    b=[zeros(1,2^ceil(log2(length(b)))-length(b)),b];
    if length(a)>length(b)                             %将两数的长度对齐
        b=[zeros(1,length(a)-length(b)) b];
    else
        a=[zeros(1,length(b)-length(a)) a];
    end

    %计算！
    result=recursiveMultiply(a,b);

    %结果后处理
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

%% 实现普通分治乘法算法计算过程
function [result]=recursiveMultiply(X,Y)
  N=length(X);
  if N==1
       temp=X.*Y;
       Single=mod(temp,10);
       Ten=(temp-Single)/10;
       result=[Ten,Single];
       return;
  end

  A=X(1:N/2);
  B=X(N/2+1:N);
  C=Y(1:N/2);
  D=Y(N/2+1:N);

  AC=recursiveMultiply(A,C);       %计算AC,结果为N位的向量
  AD=recursiveMultiply(A,D);       %计算AD,结果为N位的向量
  BC=recursiveMultiply(B,C);       %计算BC,结果为N位的向量
  BD=recursiveMultiply(B,D);       %计算BD,结果为N位的向量

  ac=[AC,zeros(1,N)];
  ad=[zeros(1,N/2),AD,zeros(1,N/2)];
  bc=[zeros(1,N/2),BC,zeros(1,N/2)];
  bd=[zeros(1,N),BD];
  result=Add(Add(Add(ac,ad),bc),bd);
end

%% 实现等长数字相加,A、B为存储数字的向量，进位加在向量最前面
function [result]=Add(A,B)
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