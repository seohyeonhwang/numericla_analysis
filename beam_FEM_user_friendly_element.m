%% �Է� ��

%������ ���� �ޱ�
No_node = inputdlg({'������ ������ �Է��ϼ��� :'},'������ ����',[1 70],{'3'});
No_node = str2num(No_node{1})

%������ ��ǥ �Է��ϱ�/�ƹ���ó�� �� ���� �ް� �;����� inputdlg�� ������ ������
coordinates_of_node = inputdlg({'������ ��ǥ�� �Է��ϼ��� :','������ ������ �Է��ϼ���:'},'������ ��ǥ',[1 70; 1 40],{'��) 0 3000 6000','��)mm^2'});
%������ ���� ��ȯ�ϱ�
unit = coordinates_of_node{2};

%������ ������ ��ǥ�� ���� Ȯ���ϱ�
coordinates_of_node = str2num(coordinates_of_node{1});
if length(coordinates_of_node) ~= No_node
    error('Error : ������ ������ ��ǥ�� ������ ��ġ�ؾ� �մϴ�');
end
coordinates_of_node = transpose(coordinates_of_node);

%���� ������ ��ǥ�� ����������� ǥ���ϱ�
for i=1:No_node
   coordinates_of_node_i(i,1)=i;   
end
coordinates_of_node = [coordinates_of_node_i coordinates_of_node;]

%% BC ����Ʈ
BC = zeros(No_node,2);
for i=1:No_node
   BC_i(i,1)=i;   
end
BC = [BC_i BC];

y_theta = inputdlg({'y���� fix�� node ��ȣ�� �Է��ϼ���','theta���� fix�� node ��ȣ�� �Է��ϼ���'},'y_and_theta value fix',[1 70; 1 70],{'0 6 (��)','2 3 (��)'});
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

%�̰Ŵ� �� �ڽ��� 1����Ÿ, 1�� y, 2�� ��Ÿ, 2�� y�� �̷������� �� ����Ʈ�� �ְ� fix�ϰ� ���� �ָ� ������ �ڵ����� ���
%����°� �ϰ� �;��µ� �ʹ� �������,,, ����
%for i=1:No_node
   % BC_list(1,i)={'y��'};
   % for 2*i=1:No_node
    %    BC_list(1,i)={'theta��'};
    %end
%end
%BC_list = {'i�� y��','i�� ��Ÿ��','j�� y��','j�� ��Ÿ��'};
%[BC,tf] = listdlg('listString',BC_list);

%% load ����Ʈ

LM_vector = zeros(No_node,2);
for i=1:No_node
   LM_vector_i(i,1)=i;   
end
LM_vector = [LM_vector_i LM_vector];

LM = inputdlg({'��� ��ȣ�� ������ �Է��ϼ���','��� ��ȣ�� ���Ʈ�� �Է��ϼ���'},'���߰� ���Ʈ',[1 70;1 70],{' 0 -1000 3 5000','2 30 3 200'});
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
