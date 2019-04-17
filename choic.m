function [D]=choic(Obst ,D, human)
%%
size1 = size(D,1);
size2 = size(D,2);
% Obst(9:2:25,[5 11 12 18])=Obst(9:2:25,[5 11 12 18]);%给出位于邻接座位中间位子的距门口的距离,这里去除了+1的情况
% Obst(5,1)=0;%给出门口的位置
% D=zeros(size1,size2);%另给出一张表，表示在同样大小的教室
%D(9:2:25,[4 5 6 10 11 12 13 17 18 19])=human;%给出教室中人员的位置
%在这里给出矩阵D是为了验证程序写的正确性时便于调用
X=zeros(size1,size2); %给出目标矩阵，即人作出的选择，下一刻，即将要走向的位置
Y=zeros(size1,size2); %给出想要运动到X中的同一目标（x,y）的人所在的位置,其上值为x*sqrt(2)+y*sqrt(3)表示目标要到（x,y）去
Z=rand(size1,size2);%生成一张随机数表，用于最后的决策判断，注意这个表所应该放置的位置
H=zeros(size1,size2);%生成矩阵H式为了作为最后成功抢到位置的人所在的位置
%A(5,1)=0;%给出初始值
%D(5,1)=0;%给出D的门口的位置
%X(5,1)=0;
%Y(5,1)=0;
%Z(5,1)=0;
%这些量是在单独考虑一个房间时使房间门口的人走出去，如果考虑整个楼层，则使教室的人走出去的工作放在run函数中了
for x=2:(size1-1) %给出x的循环范围
    for y=2:(size2-1) %给出y的循环范围
        if D(x,y)==human %九宫格的中心如果是人的话才进行如下操作
            E=max(Obst,D);%取A和D中对应值的最大的表示此刻人也在教室，同时除本人所在的位置之外的每个元胞的值表示此人距门口的距离
            F=E((x-1):1:(x+1),(y-1):(y+1));%取出以（x,y）为中心的九宫格
            F(2,2)=Obst(x,y);%九宫格的中心对别人有影响，对自己没有，所以改回原来的值
            G=sort(F);%对列排序
            b=G(1,:);%取行向量
            d=sort(b);%对行向量排序
            if length(find(F==d(1)))==1 %先考虑找到的最小值为1个的情况
                [r,c]=find(F==d(1)); %找到最小值的位置
                if r==2&&c==2 %最小值恰好在中心
                    X(x,y)=D(x,y);%目标矩阵是其本身，保持不变
                    Y(x,y)=x*sqrt(2)+y*sqrt(3);%给出到达目标矩阵（x,y）的位置上的值
                else p=x-2+r; %最小值不在中心的时候找到的最小值位置即为目标位置
                    q=y-2+c;
                    if p~=1
                        X(p,q)=human;%给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3);%给出到达目标矩阵（x,y）的位置上的值
                    else X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end
                end
            else length(find(F==d(1)))==2; %考虑同时出现两个最小值得情况
                [r,c]=find(F==d(1));
                s=rand(1);
                if s>0.5
                    p=x-2+r(1);
                    q=y-2+c(1);
                    if p~=1
                        X(p,q)=human;
                        Y(x,y)=p*sqrt(2)+q*sqrt(3);
                    else X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end
                else
                    p=x-2+r(2);
                    q=y-2+c(2);
                    if p~=1;
                        X(p,q)=human;
                        Y(x,y)=p*sqrt(2)+q*sqrt(3);
                    else X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end
                end
            end
        end
    end
end
for x=2:(size1-1)%给出x的循环范围
    for y=2:size2%给出y的循环范围
        if X(x,y)>0
            Y1=Y((x-1):1:(x+1),(y-1):(y+1));%对目标（x,y）给出九宫格
            Y2=Z((x-1):1:(x+1),(y-1):(y+1));%给出九宫格的随机数作为之后的判断
            w=x*sqrt(2)+y*sqrt(3);
            %(Y1==w)*Y2;%从九宫格中找到以中心为目标的人所对应的随机数
            t=max(max((Y1==w).*Y2));%找到以中心为目标的人所对应位置的最大值
            [r1,c1]=find((Y1==w).*Y2==t);%找到最大值的位置
            H(x-2+r1,y-2+c1)=human;%将抢到中心的位置在H中的位置值改为M
        end
    end
end
%对以（5,1）为目标的应该如何讨论
for x=2:(size1-1)%给出x的循环范围
    for y=1%给出y的循环范围
        if X(x,y)>0
            Y1=Y((x-1):1:(x+1),y:(y+1));%对目标（x,y）给出九宫格
            Y2=Z((x-1):1:(x+1),y:(y+1));%给出九宫格的随机数作为之后的判断
            w=x*sqrt(2)+y*sqrt(3);
            %(Y1==w)*Y2;%从九宫格中找到以中心为目标的人所对应的随机数
            t=max(max((Y1==w).*Y2));%找到以中心为目标的人所对应位置的最大值
            [r1,c1]=find((Y1==w).*Y2==t);%找到最大值的位置
            H(x-2+r1,c1)=human;%将抢到中心的位置在H中的位置值改为M
        end
    end
end
D=D+X-H;%应用一个十分简单地公式给出下一个时间步的教室中的人员分布情况
end