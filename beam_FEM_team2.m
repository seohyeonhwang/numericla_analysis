%% Beam (Team 02)
% 작성일 : 2019.06.06
clear all;  
clc;
%
% 실행 시작한 시각 보여주기
disp('*********** START ANALYSIS ************');
c = clock;
fprintf('%i년 %i월 %i일 %i시 %i분 %2.1f초',transpose(c))
fprintf('\n');
%
%
%% 입력 값 - 절점 개수, 절점의 좌표
%
% 절점의 개수 입력 받기
No_node = inputdlg({'절점의 개수를 입력하세요 :'},'절점의 개수',[1 70],{'7'});
No_node = str2num(No_node{1}); % *****절점의 개수 출력*****
if No_node < 2 || No_node ~= fix(No_node)
    error('Error: Beam을 구성하기 위한 절점의 개수는 2이상인 정수여야 합니다.')
end
%
% 절점의 좌표 입력 받기
coordinates_of_node = inputdlg({'절점의 좌표를 입력하세요 :',...
    '절점의 단위를 입력하세요:'},...
    '절점의 좌표',[1 70; 1 40],{'0 0.5 2 3 4 5.5 6','m'});
%
%절점의 단위 변환하기 (m -> mm)
unit = coordinates_of_node{2};
tf=strcmpi(unit,'m');
if tf==1
    coordinates_of_node = str2num(coordinates_of_node{1})*(10^3);
elseif tf==0
    coordinates_of_node = str2num(coordinates_of_node{1});
end
%
%절점의 개수와 좌표의 개수 확인하기
if length(coordinates_of_node) ~= No_node
    error('Error : 절점의 개수와 좌표의 개수는 일치해야 합니다');
end
coordinates_of_node = transpose(coordinates_of_node);
%
%받은 절점의 좌표를 행렬형식으로 표현하기
for i=1:No_node
   coordinates_of_node_i(i,1)=i;   
end
coordinates_of_node = [coordinates_of_node_i coordinates_of_node;]; % *****좌표 출력*****
%
%
%% 사용자에게 입력 받은 값 출력 - 절점 개수, 절점의 좌표
%
fprintf('\n1. 입력받은 Node 갯수 : %d개\n\n', No_node);
disp('2. 입력받은 Node 좌표 :');
disp('   COORDINATES OF NODE');
disp('   Node    Coordinate (mm)');
fprintf('   %i       %.3f\n', (coordinates_of_node)');
%
%% 입력 값 - 단면2차모멘트, 탄성계수
%
% 단면2차모멘트 받기
inertia = inputdlg({'단면의 단면2차 모멘트 크기를 입력하시오 :',...
    '단면2차모멘트의 단위(mm^2/m^2)를 입력하세요:'},...
    '단면2차모멘트',[1 70; 1 40],{'2*10^8','mm^4'});
%
% 단면2차모멘트의 단위 변환하기 (m^4 -> mm^4)
unit = inertia{2};
tf=strcmpi(unit,'m^4');
if tf==1
    inertia = str2num(inertia{1})*(10^12);
elseif tf==0
    inertia = str2num(inertia{1});
end
%
% 탄성계수 입력 받기
E = inputdlg({'탄성계수를 입력하시오 :',...
    '탄성계수의 단위(MPa/GPa)를 입력하세요:'},...
    '단면2차모멘트',[1 70; 1 40],{'300','GPa'});
%
% 탄성계수의 단위 변환하기 (GPa -> MPa)
unit = E{2};
tf=strcmpi(unit,'GPa');
if tf==1
    E = str2num(E{1})*(10^3);
elseif tf==0
    E = str2num(E{1});
end

%
% 부재의 길이 계산하기
No_element = No_node-1; % 부재 개수 계산
len_element = zeros(No_element, 2);
for i=1 : No_element
    len_element_i = zeros(No_element, 2);
    length = coordinates_of_node(i+1, 2) - coordinates_of_node(i, 2);
    len_element_i(i, 1) = i;
    len_element_i(i, 2) = length;
    len_element = len_element + len_element_i;
end
%
%% 사용자에게 입력 받은 값 출력 - 부재의 길이 출력
%
disp('3. 입력받은 부재의 길이 :');
disp('   LENGTH OF ELEMENTS');
disp('   Node    Length (mm)');
fprintf('   %i       %.3f\n', (len_element)');
%
%% 입력값 - 하중, 모멘트
%
% 하중과 모멘트 입력 받기
LM_input = zeros(No_node,2);
for i=1:No_node
   LM_input_i(i,1)=i;   
end
%
LM_input = [LM_input_i LM_input];
%
LM = inputdlg({'노드 번호와 하중을 입력하세요_단위:N','노드 번호와 모멘트를 입력하세요_단위:Nmm'}...
    ,'하중과 모멘트',[1 70;1 70],{' 5 10000 7 -30000','2 10000000'});
L = transpose(str2num(LM{1}));
M = transpose(str2num(LM{2}));
%
for i=1:No_node
    for j=1:2:size(L,1)
      if LM_input(i,1)== L(j)
          LM_input(i,2)=L(j+1,1);
      end       
    end
end
for i=1:No_node
    for j=1:2:size(M,1)
      if LM_input(i,1)== M(j)
          LM_input(i,3)=M(j+1,1);
      end       
    end
end
Load = LM_input(:,2);
Moment = LM_input(:,3);
%
%% 사용자에게 입력 받은 값 출력 - 하중과 모멘트
%
disp('4. 입력받은 하중과 모멘트 :');
disp('   LOAD AND MOMENT');
disp('   Node    Load (N)   Moment (Nm)');
fprintf('   %i         %i         %i\n',(LM_input)');
%
%% 전체 강성행렬 만들기 (Global Stiffness matrix)
%
KG = zeros(No_node*2, No_node*2); % 수직처짐, 처짐각 총 2개씩
%
for i=1 : No_element
    % 기본 강성행렬 (Local stiffness matrix)
    KG_i = zeros(No_node*2, No_node*2);
    L = len_element(i, 2);
    KL = E*inertia*[12/L^3, 6/L^2, -12/L^3, 6/L^2;
                    6/L^2, 4/L, -6/L^2, 2/L;
                    -12/L^3, -6/L^2, 12/L^3, -6/L^2;
                    6/L^2, 2/L, -6/L^2, 4/L];
    KG_i((i*2-1):(i*2+2), (i*2-1):(i*2+2)) = KL;
    KG = KG + KG_i;
end
%
% *****전체 강성행렬 출력*****
disp('5. 전체 강성행렬 :');
%fprintf('   %i * No_node개 어떻,,,(?)', (KG)');
%
%% 경계조건 (Boundary Condition)
%
% BC 초기화 하기
BC = zeros(No_node,2);
for i=1:No_node
   BC_i(i,1)=i;   
end
BC = [BC_i BC];
%
% BC 입력 받기
Loop=1;
while Loop==1
    Set = inputdlg({'지지점의 이름을 입력하시오(Pin,Roller,Fixed)',...
        'Node를 선택하시오','팝업을 멈추고 싶으면 0을 입력하시오'},...
        'Set',[1 70; 1 40; 1 40],{'Pin','1','1'});
    Set_name=Set{1};
    Set_node=str2num(Set{2});
    Loop=str2num(Set{3});
    tf_pin=strcmpi(Set_name,'Pin');
    tf_Roller=strcmpi(Set_name,'Roller');
    tf_Fixed=strcmpi(Set_name,'Fixed');
    if tf_pin==1
        BC(Set_node,2)=1;
    elseif tf_Roller==1
        BC(Set_node,2)=1;
    elseif tf_Fixed==1
        BC(Set_node,2:3)=1;
    end               
end
%
% *****경계조건 출력*****
disp('6. 경계조건 :');
disp('   BOUNDARY CONDITION');
disp('   Node   Y    Theta');
fprintf('   %i      %i      %i\n', (BC)');
%
% Cancel row & column (at fixed)
BC_p = (BC(:, 2:3))';
Control = 0;
KG_p = KG;
for i=1:No_node * 2
    Check= BC_p(i);
    if Check == 1
        KG_p(i-Control, :) = [];
        KG_p(:, i-Control) = [];
        Control = Control + 1;
    end
end
%
% *****부분 강성행렬 출력*****
disp('7. 부분 강성행렬 :');
%fprintf('   %i * No_node개 어떻,,,(?)', (KG_p)');
%
%% 반력과 처침, 처짐각 구하기 (Force & Deformation)
%
% Load and Moment vector 만들기
LM_vector = zeros(No_node*2, 1);
for i=1:No_node*2
    if mod(i,2) == 1
          LM_vector(i,1)=Load(i/2+0.5,1);
    end
    if mod(i,2) == 0
          LM_vector(i,1)=Moment(i/2,1);
    end
end
%
% ***** 하중, 모멘트 벡터 출력 *****
disp('8. 하중&모멘트 벡터 출력 :');
disp('   LOAD AND MOMENT VECTOR');
fprintf('   %i     \n', (LM_vector)');
%
% Cancel row (at fixed node)
Control = 0;
LM_vector_p = LM_vector;
for i=1:No_node
    Check_1 = BC(i,2);
    Check_2 = BC(i,3);
     if Check_1 == 1
        LM_vector_p(2*i-1-Control) = [];
        Control = Control + 1;
     end
     if Check_2 == 1
        LM_vector_p(2*i-Control) = [];
        Control = Control + 1;
     end
end
%
KG_p_inv = KG_p^(-1);
d_p = KG_p_inv * LM_vector_p;
%
% Reaction Force
%
% Whole displacement
d = zeros(No_node*2,1);
for i=1:No_node
    Check_1 = BC(i,2); %%처짐
    Check_2 = BC(i,3); %%처짐각
    %d_i = zeros(No_node*2, 1);
     if Check_1 == 0
        d(2*i-1) = d_p(1);
        d_p(1) = [];
     end
     if Check_2 == 0
         d(2*i) = d_p(1);
         d_p(1) = [];
     end
end
%
% ***** 처짐과 처침각 출력 *****
disp('9. 처짐&처짐각 출력 :');
fprintf('   %.7f     \n', (d)');
F = KG*d; 
% ***** 반력과 외력 출력 *****
disp('10. 반력과 외력 출력 :');
fprintf('   %.3f     \n', (F)');
%
%
%% Display Table
%
% Displacement
        
d_y=d(1:2:2.*No_node);
d_theta=d(2:2:2.*No_node);
node_num=zeros(No_node,1);
for i=1:No_node
    node_num(i,1)=i;
end
result_disp=[node_num,d_y,d_theta];
row_dist=ones(1,No_node);
column_dist=ones(1,3);
result_disp=mat2cell(result_disp,row_dist,column_dist);

f=figure('Name','Displasement','NumberTitle','off','units', 'pixels', 'pos',[350 500 255 300]);
txtbox = uicontrol(f,'Style','edit',...
                'String','Displacement',...
                'Position',[65 250 130 20]);
uit = uitable(f);
uit.Data=result_disp;
uit.ColumnName = {'절점','처짐[mm]','처짐각[rad]'};

uit.Position=[25 25 210 200];
%
%
% Force

f_y=F(1:2:2.*No_node);
f_theta=F(2:2:2.*No_node);
node_num=zeros(No_node,1);
for i=1:No_node
    node_num(i,1)=i;
end
result_disp=[node_num,f_y,f_theta];
row_dist=ones(1,No_node);
column_dist=ones(1,3);
result_disp=mat2cell(result_disp,row_dist,column_dist);

f=figure('Name','Force','NumberTitle','off','units', 'pixels', 'pos',[350 500 255 300]);
txtbox = uicontrol(f,'Style','edit',...
                'String','Force',...
                'Position',[65 250 130 20]);
uit = uitable(f);
uit.Data=result_disp;
uit.ColumnName = {'절점','하중[N]','모멘트[Nmm]'};

uit.Position=[25 25 210 200];
%

 
