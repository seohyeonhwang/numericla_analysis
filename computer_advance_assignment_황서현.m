%% Geometry

%������ ���� ���ϱ�
n_num=input("�� ������ ������ ��Դϱ�?\n>>");
if n_num/2==0
    fprintf("������ ������ Ȧ������ �մϴ�.\n>>");
end 
%������ ���� ���ϱ�
n_cd=zeros(n_num,2);
n_cd = n_cd + input("�� ���� ��ǥ�� ����������� �Է��Ͻÿ�\n(�� [node ��ȣ x��ǥ;] - ����: mm\n>>");

%�ʿ��� �ܸ� ������ ź����� �� �ޱ�
area=input("�ܸ��� ������ �Է��Ͻÿ�.-���� mm^2\n>>");
young=input("ź������� �Է��Ͻÿ�.-���� NPa\n>>");

%% stiffness matrix

%element length ���ϱ�
element_num=(n_num/2)-0.5;
element_len=zeros(element_num,2);
for i = 1:element_num
    ith_element_len = zeros(element_num,2);
    len = n_cd(2*i+1,2)-n_cd(2*i-1,2);
    ith_element_len(i,1) = i;
    ith_element_len(i,2) =len;
    element_len=element_len + ith_element_len;
end
element_len

%KG ���ϱ�
KG = zeros(n_num,n_num);
for i = 1:element_num
    ith_KG = zeros(n_num,n_num);
    KL=(young*area)/(3*element_len(i,2))*[7 -8 1 ; -8 16 -8 ; 1 -8 7];
    ith_KG((2*i-1):(2*i+1),(2*i-1):(2*i+1))=KL;
    KG = KG + ith_KG;
end
KG
