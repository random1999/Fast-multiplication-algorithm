% ======================================================================================
% 作者： cx
% 时间： 2025-07-25
% 实现： Karatsuba算法计算大数相乘
% ======================================================================================
function [result] = Karatsuba(num1,num2)
    a=int8(str2num(num1(:)))';
    b=int8(str2num(num2(:)))';
    a=[zeros(1,2^ceil(log2(length(a)))-length(a)),a];  %将两数的长度补到2的整数次方
    b=[zeros(1,2^ceil(log2(length(b)))-length(b)),b];
    if length(a)>length(b)                             %将两数的长度对齐
        b=[zeros(1,length(a)-length(b)) b];
    else
        a=[zeros(1,length(b)-length(a)) a];
    end
    
    result=karatsuba(a,b);   %计算！
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
function [r]=karatsuba(X,Y) %实现karatsuba乘法算法
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

  AC=karatsuba(A,C);       %计算AC
  BD=karatsuba(B,D);       %计算BD
  [r1,flag1]=Add(A,B);     %计算(A+B)
  [r2,flag2]=Add(C,D);     %计算(C+D)
  if flag1==0 && flag2==0  %对(A+B)和(C+D)进位的处理：对其补零
      A_B=r1;
      C_D=r2;
  elseif flag1~=0 && flag2~=0
      A_B=[zeros(1,length(r1)-1),flag1,r1];
      C_D=[zeros(1,length(r2)-1),flag2,r2];
  elseif flag1~=0 && flag2==0
      A_B=[zeros(1,length(r1)-1),flag1,r1];
      C_D=[zeros(1,length(r2)),r2];
  elseif flag2~=0 && flag1==0
      A_B=[zeros(1,length(r1)),r1];
      C_D=[zeros(1,length(r2)-1),flag2,r2];
  end
  AB_CD=karatsuba(A_B,C_D); %计算(A+B)(C+D)
  for i=1:1:length(AB_CD)
    if AB_CD(i)~=0
        break;
    end
   end
   AB_CD(1:i-1)=[];

  ac=[AC,zeros(1,lenX)];
  ab_cd=[zeros(1,length(ac)-length(AB_CD)-lenX/2),AB_CD,zeros(1,lenX/2)];
  ac_m=[zeros(1,lenX/2),AC,zeros(1,lenX/2)];
  bd_m=[zeros(1,lenX/2),BD,zeros(1,lenX/2)];
  bd=[zeros(1,lenX),BD];
  r=Add(ac,ab_cd);
  r=Minus(r,ac_m);
  r=Minus(r,bd_m);
  r=Add(r,bd);
end


function [result,carryNum]=Add(A,B) %实现等长数字相加,A、B为存储数字的向量
  lenA=length(A);
  result=A;
  carryNum=int8(0);
  for i=lenA:-1:1
      temp1=result(i)+B(i)+carryNum;
      result(i)=mod(temp1,10);
      carryNum=(temp1-result(i))/10;
  end
  % if carryNum~=0
  %    result=[carryNum,result];
  % end
end

function [result]=Minus(A,B) %实现等长数字相减,A、B为存储数字的向量且A>B
  lenA=length(A);
  result=A;
  carryNum=int8(0);
  for i=lenA:-1:1
      temp1=result(i)+10-B(i)-carryNum;
      result(i)=mod(temp1,10);
      carryNum=1-(temp1-result(i))/10;
  end
end