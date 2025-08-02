% ======================================================================================
% 作者： cx
% 时间： 2025-07-26
% 实现： Karatsuba快速乘法算法
% ======================================================================================
function [result] = Karatsuba(num1,num2)
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
    result=karatsuba(a,b); 

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

%% 实现karatsuba乘法算法计算过程
function [result]=karatsuba(X,Y)
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

  AC=karatsuba(A,C);       %计算AC,结果为N位的向量
  BD=karatsuba(B,D);       %计算BD,结果为N位的向量
  % -----------------------------------------------
  [r1,flag1]=Add(A,B);     %计算(A+B)
  [r2,flag2]=Add(C,D);     %计算(C+D)
  t=[0,karatsuba(r1,r2)];       %计算(A+B)(C+D)不进位的情况,结果为N+1位的向量
  if flag1~=0 && flag2==0       %处理(A+B)进位的情况
    t=Add(t,[0,r2,zeros(1,N/2)]);
  elseif flag1==0 && flag2~=0   %处理(C+D)进位的情况
    t=Add(t,[0,r1,zeros(1,N/2)]);
  elseif  flag1~=0 && flag2~=0  %处理都发生进位的情况
    t=Add(t,[0,r2,zeros(1,N/2)]);
    t=Add(t,[0,r1,zeros(1,N/2)]);
    t=Add(t,[1,zeros(1,N)]);
  end
  ABCD_AC_BD=Minus(Minus(t,[0,AC]),[0,BD]);   %计算(A+B)(C+D)-AC-BD,结果为N+1位的向量
  % -----------------------------------------------
  first=[AC,zeros(1,N)];
  middle=[zeros(1,length(first)-length(ABCD_AC_BD)-N/2),ABCD_AC_BD,zeros(1,N/2)];
  last=[zeros(1,N),BD];
  result=Add(Add(first,middle),last);
end

%% 实现等长数字相加,A、B为存储数字的向量,返回的carryNum表示有无进位
function [result,carryNum]=Add(A,B)
  lenA=length(A);
  result=A;
  carryNum=int8(0);
  for i=lenA:-1:1
      temp1=result(i)+B(i)+carryNum;
      result(i)=mod(temp1,10);
      carryNum=(temp1-result(i))/10;
  end
end

%% 实现等长数字相减,A、B为存储数字的向量,且A>B
function [result]=Minus(A,B)
  lenA=length(A);
  result=A;
  carryNum=int8(0);
  for i=lenA:-1:1
      temp1=result(i)+10-B(i)-carryNum;
      result(i)=mod(temp1,10);
      carryNum=1-(temp1-result(i))/10;
  end
end