%% Geometry

%절점의 개수 구하기
n_num=input("총 절점의 개수는 몇개입니까?\n>>");
if n_num/2==0
    fprintf("절점의 개수는 홀수여야 합니다.\n>>");
end 
%절점과 길이 구하기
n_cd=zeros(n_num,2);
n_cd = n_cd + input("각 점의 좌표를 행렬형식으로 입력하시오\n(예 [node 번호 x좌표;] - 단위: mm\n>>");

%필요한 단면 면적과 탄성계수 값 받기
area=input("단면의 면적을 입력하시오.-단위 mm^2\n>>");
young=input("탄성계수를 입력하시오.-단위 NPa\n>>");

%% stiffness matrix

%element length 구하기
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

%KG 구하기
KG = zeros(n_num,n_num);
for i = 1:element_num
    ith_KG = zeros(n_num,n_num);
    KL=(young*area)/(3*element_len(i,2))*[7 -8 1 ; -8 16 -8 ; 1 -8 7];
    ith_KG((2*i-1):(2*i+1),(2*i-1):(2*i+1))=KL;
    KG = KG + ith_KG;
end
KG
