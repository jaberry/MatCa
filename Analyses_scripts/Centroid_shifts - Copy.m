
%   Image_dir=([savedir,'/Images']);
% function Centroid_shifts_GUI
% Centroid.fh = figure('Visible','on','Position',[20,20,1500,1000],'Units','normalized');
% set(gcf,'Name','StableCellImaging','Color',[0.98 0.98 0.99],'NumberTitle','off')

% Centroid.load=uicontrol('Parent', Centroid.fh,'Style','pushbutton','String','Load Data','Position',[220,840,100,50],'Callback',@images,'FontSize',16,'Units','normalized');

function Centroid_shifts
tic

Image_dir1=uigetdir('','Locate the reference Images');
root_dir=fileparts(Image_dir1);
Image_dir2=uigetdir('','Locate the 2.day Images');
mkdir(root_dir,'stableICs');
SaveIm=char(inputdlg('Would you like to save the image files? (y/n)   ', 's'));
MaxDist=str2double(char(inputdlg('Enter the Max inter-cell allowance: ')));
nn=str2double(char(inputdlg('Enter a saving number for the inter cell distance matrix:')));

% Image_dir=pwd;
     num_cell1=length(dir([Image_dir1,'/ic*.tif']));
     num_cell2=length(dir([Image_dir2,'/ic*.tif']));
  xy_cell1=zeros(num_cell1,2);
   xy_cell2=zeros(num_cell2,2);
Comb_cell1=imread([Image_dir1,'/ic.tif']); Comb_cell2=imread([Image_dir2,'/ic.tif']); 
        BW1=im2bw(Comb_cell1);BW2=im2bw(Comb_cell2);
        [x1,y1]=find(BW1>0);[x2,y2]=find(BW2>0);
        xc1=mean(y1);yc1=mean(x1);xc2=mean(y2);yc2=mean(x2);
        xy_cell1(1,1)=xc1;xy_cell1(1,2)=yc1;xy_cell2(1,1)=xc2;xy_cell2(1,2)=yc2;
%%
    for i=1:num_cell1-1
        cell1=imread([Image_dir1,'/ic',num2str(i),'.tif']);
        BW1=im2bw(cell1);
        [x1,y1]=find(BW1>0);
        xc1=mean(y1);yc1=mean(x1);
        xy_cell1(i+1,1)=xc1;xy_cell1(i+1,2)=yc1;
        Comb_cell1=imadd(Comb_cell1,cell1);
    end
%     Comb_cell(find(Comb_cell>0))=20;
    BW_combcell1=im2bw(Comb_cell1);
%     figure;
   figure;subplot(231); imshow(BW_combcell1);hold on
    hold on;plot(xy_cell1(:,1),xy_cell1(:,2),'b.','MarkerSize',5)
    colormap(gray);title('Cells-1');axis normal;
    %
    imwrite(Comb_cell1,[Image_dir1,'/BaseImage.jpeg'])
    save([Image_dir1 '/xy_cell.mat'],'xy_cell1')
    save([Image_dir1 '/xy_cell'],'xy_cell1','-ascii')
    
    for i=1:num_cell2-1
        cell2=imread([Image_dir2,'/ic',num2str(i),'.tif']);
        BW2=im2bw(cell2);
        [x2,y2]=find(BW2>0);
        xc2=mean(y2);yc2=mean(x2);
        xy_cell2(i+1,1)=xc2;xy_cell2(i+1,2)=yc2;
        Comb_cell2=imadd(Comb_cell2,cell2);
    end
%     Comb_cell(find(Comb_cell>0))=20;
    BW_combcell2=im2bw(Comb_cell2);
%     figure;
   subplot(232); imshow(BW_combcell2);hold on
    hold on;plot(xy_cell2(:,1),xy_cell2(:,2),'r.','MarkerSize',5)
    colormap(gray);title('Cell-2');axis normal;
    %
    imwrite(Comb_cell2,[Image_dir2,'/BaseImage.jpeg'])
    save([Image_dir2 '/xy_cell.mat'],'xy_cell2')
    save([Image_dir2 '/xy_cell'],'xy_cell2','-ascii')
    
    subplot(233);contour(BW_combcell1);hold on;contour(BW_combcell2);axis normal;view(0,-90)
    hold on;plot(xy_cell1(:,1),xy_cell1(:,2),'b.','MarkerSize',5);plot(xy_cell2(:,1),xy_cell2(:,2),'r.','MarkerSize',5);title('Merged');box off
    
    %%Sele
    xy1=zeros(length(xy_cell1),length(xy_cell1));
    for i=1:length(xy_cell1)
for k=1:length(xy_cell1)
xy1(i,k)=sqrt([power(xy_cell1(i,1) - xy_cell1(k,1),2) + power(xy_cell1(i,2) - xy_cell1(k,2),2)]);
end
    end
   minxy1= min(xy1(find(xy1>0)));
% [xmin,ymin]=find(xy==min(xy(find(xy>0))))

%%
 xy=zeros(length(xy_cell1),length(xy_cell2));
   for i=1:length(xy_cell1)
for k=1:length(xy_cell2)
    xy(i,k)=sqrt([power(xy_cell1(i,1) - xy_cell2(k,1),2) + power(xy_cell1(i,2) - xy_cell2(k,2),2)]);
end
   end
   
% end
if(MaxDist>0)
minxy1=MaxDist;
end
bb=zeros(1,length(xy1));
for i=1:length(xy1)
if(min(xy(i,:))<minxy1)
plot(xy_cell1(i,1),xy_cell1(i,2),'b.');hold on

% a=a+1
b=find(xy(i,:)==min(xy(i,:)));
plot(xy_cell2(b,1),xy_cell2(b,2),'r.')
bb(i)=b
end
end
    overlaps=find(bb>0);
    Comb_cell=Comb_cell1;
    Comb_cell(find(Comb_cell>0))=5;
  for i=1:length(overlaps)
        if(overlaps(i)==1)
        cell=imread([Image_dir1,'/ic.tif']);
        else   
        cell=imread([Image_dir1,'/ic',num2str(overlaps(i)-1),'.tif']);
        if(SaveIm=='y')
        copyfile([Image_dir1,'/ic',num2str(overlaps(i)-1),'.tif'],[root_dir,'/stableICs/ic',num2str(overlaps(i)-1) '.tif'])
        end
        end
        Comb_cell=imadd(Comb_cell,cell);
  end
    Comb_cell(find(Comb_cell>5))=20;
    subplot(234);imagesc(Comb_cell);title(['Stably Monitored in two sessions: ' num2str(length(overlaps)) ' Cells'])

for i=1:length(xy1)-1
xxyy1(i)=min(xy1(i,i+1:end));
end
meanxy1=mean(xxyy1);

minxy=min(xy);
meanxy=mean(minxy);
mminxy=min(minxy);


xy1cell_loc=sqrt(xy_cell1(:,1).^2+xy_cell1(:,2).^2);
xy2cell_loc=sqrt(xy_cell2(:,1).^2+xy_cell2(:,2).^2);
for i=1:length(overlaps)
temp(i,1)=xy1cell_loc(overlaps(i))
temp(i,2)=xy2cell_loc(bb(overlaps(i)))
end
[h,p,k]=ttest2(temp(:,1),temp(:,2))
mmdiff=mean(abs(diff(temp')));

subplot(235);
hist(xxyy1,50)
set(get(gca,'child'),'FaceColor','none','EdgeColor','b');axis tight;box off;
hold on;hist(minxy,50);legend('Reference Image','2.Image')
% bar([1 2],[meanxy1 minxy1],'b') ;hold on;bar([3 4],[meanxy mminxy],'r');xlabel(['1.cells Mean-Min'  '   '  '1-2 Cells Mean-Min']);box off
ylabel('inter-cell distances (�m)');title([num2str(length(xy_cell1)) '  -->  ' num2str(length(xy_cell2)) '  Cells'],'FontSize',12)
subplot(236);bar(2,[mmdiff+mean(xy2cell_loc)],0.2,'r');
hold on;bar([1 2],[mean(xy1cell_loc) mean(xy2cell_loc)],0.2,'b');box off

if h>0
    sstitle='Significant'
else
    sstitle='NOT Significant'
    title([sstitle,' ','meanError= ',num2str(mmdiff),'�m'])
end    

%%
figure;subplot(211);hist(xxyy1,50)
set(get(gca,'child'),'FaceColor','none','EdgeColor','b');axis tight;box off;
hold on;hist(minxy,50);legend('Within','Between')
subplot(212);ksdensity(xxyy1)
hold on
ksdensity(minxy);legend('Within','Between');axis tight;box off;;title('KS Distribution')
save([root_dir '/cell2cell_dist' num2str(nn) '.mat'],'xy')
save([root_dir '/minbetweenses_dist' num2str(nn) '.mat'],'minxy')
save([root_dir '/matched_cells' num2str(nn) '.mat'],'overlaps')

toc
end
%%
