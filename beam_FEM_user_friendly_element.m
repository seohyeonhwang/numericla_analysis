%% 입력 값

%절점의 개수 받기
No_node = inputdlg({'절점의 개수를 입력하세요 :'},'절점의 개수',[1 70],{'3'});
No_node = str2num(No_node{1})

%절점의 좌표 입력하기/아바쿠스처럼 한 점씩 받고 싶었으나 inputdlg가 지원을 안해줌
coordinates_of_node = inputdlg({'절점의 좌표를 입력하세요 :','절점의 단위를 입력하세요:'},'절점의 좌표',[1 70; 1 40],{'예) 0 3000 6000','예)mm^2'});
%절점의 단위 변환하기
unit = coordinates_of_node{2};

%절점의 개수와 좌표의 개수 확인하기
coordinates_of_node = str2num(coordinates_of_node{1});
if length(coordinates_of_node) ~= No_node
    error('Error : 절점의 개수와 좌표의 개수는 일치해야 합니다');
end
coordinates_of_node = transpose(coordinates_of_node);

%받은 절점의 좌표를 행렬형식으로 표현하기
for i=1:No_node
   coordinates_of_node_i(i,1)=i;   
end
coordinates_of_node = [coordinates_of_node_i coordinates_of_node;]

%% BC 디폴트
BC = zeros(No_node,2);
for i=1:No_node
   BC_i(i,1)=i;   
end
BC = [BC_i BC];

y_theta = inputdlg({'y값이 fix인 node 번호를 입력하세요','theta값이 fix인 node 번호를 입력하세요'},'y_and_theta value fix',[1 70; 1 70],{'0 6 (예)','2 3 (예)'});
y = transpose(str2num(y_theta{1}));
theta = transpose(str2num(y_theta{2}));
for i=1:No_node
    for j=1:size(y,1)
      if BC(i,1)== y(j)
          BC(i,2)=1;
      end       
    end
end
for i=1:No_node
    for j=1:size(theta,1)
      if BC(i,1)== theta(j)
          BC(i,3)=1;
      end       
    end
end
BC    

%이거는 걍 박스에 1번세타, 1번 y, 2번 세타, 2번 y값 이런식으로 쭉 리스트가 있고 fix하고 싶은 애를 누르면 자동으로 행렬
%만드는걸 하고 싶었는데 너무 어려워서,,, 포기
%for i=1:No_node
   % BC_list(1,i)={'y값'};
   % for 2*i=1:No_node
    %    BC_list(1,i)={'theta값'};
    %end
%end
%BC_list = {'i번 y값','i번 세타값','j번 y값','j번 세타값'};
%[BC,tf] = listdlg('listString',BC_list);

%% load 디폴트

LM_vector = zeros(No_node,2);
for i=1:No_node
   LM_vector_i(i,1)=i;   
end
LM_vector = [LM_vector_i LM_vector];

LM = inputdlg({'노드 번호와 하중을 입력하세요','노드 번호와 모멘트를 입력하세요'},'하중과 모멘트',[1 70;1 70],{' 0 -1000 3 5000','2 30 3 200'});
L = transpose(str2num(LM{1}));
M = transpose(str2num(LM{2}));

for i=1:No_node
    for j=1:2:size(L,1)
      if LM_vector(i,1)== L(j)
          LM_vector(i,2)=L(j+1,1);
      end       
    end
end
for i=1:No_node
    for j=1:2:size(M,1)
      if LM_vector(i,1)== M(j)
          LM_vector(i,3)=M(j+1,1);
      end       
    end
end

LM_vector
