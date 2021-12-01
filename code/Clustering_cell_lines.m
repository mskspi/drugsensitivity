clear all
close all

load('./data/distance_matrix_cell_lines.mat')
load('./data/cell_line_data')

D= linkage(distanceM, 'ward');
NumCluster=6;  
C = cluster(D,'Maxclust',NumCluster);

myColours =  [
        0.737       0.235       0.161;
        0.4940      0.1840      0.5560;
        0.525       0.525       0.525;
        0           0.451       0.761;
        0.125       0.522       0.306;
        0.882       0.529       0.153;
        0.561       0.4667      0;
        0.435       0.600       0.678;
        ];

figure(1)

leafOrder = optimalleaforder(D, distanceM);
cases_s=SampleID_Cancer(leafOrder);
CancerType_s=Cancer_Type(leafOrder);

S_C=C(leafOrder);
color = D(end-NumCluster+2,3)-eps;
H = dendrogram(D, 0,'ReOrder', leafOrder,'ColorThreshold', color);

set(H,'LineWidth',1.5)
h = gca();

lineColours = cell2mat(get(H,'Color'));
colourList = unique(lineColours, 'rows');
for colour = 2:size(colourList,1)
    idx = ismember(lineColours, colourList(colour,:), 'rows');
    lineColours(idx, :) = repmat(myColours(colour-1,:),sum(idx),1);
end

for line = 1:size(H,1)
    set(H(line), 'Color', lineColours(line,:));
end

eva = evalclusters(distanceM,'linkage','silhouette','KList',[1:5]);
s = silhouette(distanceM,C);
s_m=mean(s);
    
C_S=C(leafOrder);
s=s(leafOrder);
L=zeros(NumCluster,1);
cnt=1;
f=find(C_S==C_S(1)); 
L(cnt,1)=length(f);
 
 while cnt<NumCluster
  f=find(C_S==C_S(sum(L)+1));
  cnt=cnt+1;
  L(cnt)=length(f);
 end
 

 

