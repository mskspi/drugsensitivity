clear all
close all

load('./data/distance_matrix_drugs')
load('./data/drug_data')

D= linkage(DrugDist, 'ward');
NumCluster=6;
C_D = cluster(D,'Maxclust',NumCluster);

figure(1)
leafOrder_D = optimalleaforder(D, DrugDist);
drugs=DrugsName;

S_C=C_D(leafOrder_D);
color = D(end-NumCluster+2,3)-eps;
H = dendrogram(D, 0,'ReOrder', leafOrder_D,'ColorThreshold', color);

myColours =  [
        0.882       0.529       0.153;  
        0.737       0.235       0.161;
        0.4940      0.1840      0.5560;
        0.525       0.525       0.525;
        0           0.451       0.761;
        0.125       0.522       0.306;
        0.561       0.4667      0;
        0.435       0.600       0.678;
        ];
    
color = D(end-NumCluster+2,3)-eps;
lineColours = cell2mat(get(H,'Color'));
colourList = unique(lineColours, 'rows');
for colour = 2:size(colourList,1)
    idx = ismember(lineColours, colourList(colour,:), 'rows');
    lineColours(idx, :) = repmat(myColours(colour-1,:),sum(idx),1);
end

for line = 1:size(H,1)
    set(H(line), 'Color', lineColours(line,:));
end

set(H,'LineWidth',3)
h = gca();
eva = evalclusters(DrugDist,'linkage','silhouette','KList',[1:5]);

s = silhouette(DrugDist,C_D);
s_m=mean(s);

C_S=C_D(leafOrder_D);
s=s(leafOrder_D);
L=zeros(NumCluster,1);
cnt=1;
f=find(C_S==C_S(1)); 
L(cnt,1)=length(f);
 
while cnt<NumCluster
  f=find(C_S==C_S(sum(L)+1));
  cnt=cnt+1;
  L(cnt)=length(f);
end
 
C_D(C_D==6)=5;    

