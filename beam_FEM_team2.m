%% Beam (Team 02)
% �ۼ��� : 2019.06.06
clear all;  
clc;
%
% ���� ������ �ð� �����ֱ�
disp('*********** START ANALYSIS ************');
c = clock;
fprintf('%i�� %i�� %i�� %i�� %i�� %2.1f��',transpose(c))
fprintf('\n');
%
%
%% �Է� �� - ���� ����, ������ ��ǥ
%
% ������ ���� �Է� �ޱ�
No_node = inputdlg({'������ ������ �Է��ϼ��� :'},'������ ����',[1 70],{'7'});
No_node = str2num(No_node{1}); % *****������ ���� ���*****
if No_node < 2 || No_node ~= fix(No_node)
    error('Error: Beam�� �����ϱ� ���� ������ ������ 2�̻��� �������� �մϴ�.')
end
%
% ������ ��ǥ �Է� �ޱ�
coordinates_of_node = inputdlg({'������ ��ǥ�� �Է��ϼ��� :',...
    '������ ������ �Է��ϼ���:'},...
    '������ ��ǥ',[1 70; 1 40],{'0 0.5 2 3 4 5.5 6','m'});
%
%������ ���� ��ȯ�ϱ� (m -> mm)
unit = coordinates_of_node{2};
tf=strcmpi(unit,'m');
if tf==1
    coordinates_of_node = str2num(coordinates_of_node{1})*(10^3);
elseif tf==0
    coordinates_of_node = str2num(coordinates_of_node{1});
end
%
%������ ������ ��ǥ�� ���� Ȯ���ϱ�
if length(coordinates_of_node) ~= No_node
    error('Error : ������ ������ ��ǥ�� ������ ��ġ�ؾ� �մϴ�');
end
coordinates_of_node = transpose(coordinates_of_node);
%
%���� ������ ��ǥ�� ����������� ǥ���ϱ�
for i=1:No_node
   coordinates_of_node_i(i,1)=i;   
end
coordinates_of_node = [coordinates_of_node_i coordinates_of_node;]; % *****��ǥ ���*****
%
%
%% ����ڿ��� �Է� ���� �� ��� - ���� ����, ������ ��ǥ
%
fprintf('\n1. �Է¹��� Node ���� : %d��\n\n', No_node);
disp('2. �Է¹��� Node ��ǥ :');
disp('   COORDINATES OF NODE');
disp('   Node    Coordinate (mm)');
fprintf('   %i       %.3f\n', (coordinates_of_node)');
%
%% �Է� �� - �ܸ�2�����Ʈ, ź�����
%
% �ܸ�2�����Ʈ �ޱ�
inertia = inputdlg({'�ܸ��� �ܸ�2�� ���Ʈ ũ�⸦ �Է��Ͻÿ� :',...
    '�ܸ�2�����Ʈ�� ����(mm^2/m^2)�� �Է��ϼ���:'},...
    '�ܸ�2�����Ʈ',[1 70; 1 40],{'2*10^8','mm^4'});
%
% �ܸ�2�����Ʈ�� ���� ��ȯ�ϱ� (m^4 -> mm^4)
unit = inertia{2};
tf=strcmpi(unit,'m^4');
if tf==1
    inertia = str2num(inertia{1})*(10^12);
elseif tf==0
    inertia = str2num(inertia{1});
end
%
% ź����� �Է� �ޱ�
E = inputdlg({'ź������� �Է��Ͻÿ� :',...
    'ź������� ����(MPa/GPa)�� �Է��ϼ���:'},...
    '�ܸ�2�����Ʈ',[1 70; 1 40],{'300','GPa'});
%
% ź������� ���� ��ȯ�ϱ� (GPa -> MPa)
unit = E{2};
tf=strcmpi(unit,'GPa');
if tf==1
    E = str2num(E{1})*(10^3);
elseif tf==0
    E = str2num(E{1});
end

%
% ������ ���� ����ϱ�
No_element = No_node-1; % ���� ���� ���
len_element = zeros(No_element, 2);
for i=1 : No_element
    len_element_i = zeros(No_element, 2);
    length = coordinates_of_node(i+1, 2) - coordinates_of_node(i, 2);
    len_element_i(i, 1) = i;
    len_element_i(i, 2) = length;
    len_element = len_element + len_element_i;
end
%
%% ����ڿ��� �Է� ���� �� ��� - ������ ���� ���
%
disp('3. �Է¹��� ������ ���� :');
disp('   LENGTH OF ELEMENTS');
disp('   Node    Length (mm)');
fprintf('   %i       %.3f\n', (len_element)');
%
%% �Է°� - ����, ���Ʈ
%
% ���߰� ���Ʈ �Է� �ޱ�
LM_input = zeros(No_node,2);
for i=1:No_node
   LM_input_i(i,1)=i;   
end
%
LM_input = [LM_input_i LM_input];
%
LM = inputdlg({'��� ��ȣ�� ������ �Է��ϼ���_����:N','��� ��ȣ�� ���Ʈ�� �Է��ϼ���_����:Nmm'}...
    ,'���߰� ���Ʈ',[1 70;1 70],{' 5 10000 7 -30000','2 10000000'});
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
%% ����ڿ��� �Է� ���� �� ��� - ���߰� ���Ʈ
%
disp('4. �Է¹��� ���߰� ���Ʈ :');
disp('   LOAD AND MOMENT');
disp('   Node    Load (N)   Moment (Nm)');
fprintf('   %i         %i         %i\n',(LM_input)');
%
%% ��ü ������� ����� (Global Stiffness matrix)
%
KG = zeros(No_node*2, No_node*2); % ����ó��, ó���� �� 2����
%
for i=1 : No_element
    % �⺻ ������� (Local stiffness matrix)
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
% *****��ü ������� ���*****
disp('5. ��ü ������� :');
%fprintf('   %i * No_node�� �,,,(?)', (KG)');
%
%% ������� (Boundary Condition)
%
% BC �ʱ�ȭ �ϱ�
BC = zeros(No_node,2);
for i=1:No_node
   BC_i(i,1)=i;   
end
BC = [BC_i BC];
%
% BC �Է� �ޱ�
Loop=1;
while Loop==1
    Set = inputdlg({'�������� �̸��� �Է��Ͻÿ�(Pin,Roller,Fixed)',...
        'Node�� �����Ͻÿ�','�˾��� ���߰� ������ 0�� �Է��Ͻÿ�'},...
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
% *****������� ���*****
disp('6. ������� :');
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
% *****�κ� ������� ���*****
disp('7. �κ� ������� :');
%fprintf('   %i * No_node�� �,,,(?)', (KG_p)');
%
%% �ݷ°� óħ, ó���� ���ϱ� (Force & Deformation)
%
% Load and Moment vector �����
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
% ***** ����, ���Ʈ ���� ��� *****
disp('8. ����&���Ʈ ���� ��� :');
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
    Check_1 = BC(i,2); %%ó��
    Check_2 = BC(i,3); %%ó����
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
% ***** ó���� óħ�� ��� *****
disp('9. ó��&ó���� ��� :');
fprintf('   %.7f     \n', (d)');
F = KG*d; 
% ***** �ݷ°� �ܷ� ��� *****
disp('10. �ݷ°� �ܷ� ��� :');
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
uit.ColumnName = {'����','ó��[mm]','ó����[rad]'};

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
uit.ColumnName = {'����','����[N]','���Ʈ[Nmm]'};

uit.Position=[25 25 210 200];
%

 
