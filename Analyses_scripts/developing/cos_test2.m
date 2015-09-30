for i=1:min(size(conv_kernel_trans))
% figure(1);clf;area(ZONES')
% hold on;plot(conv_kernel_trans(:,i),'r')
% pause(.1)

conv_Center_kernel1=(CENTER_zones.*conv_kernel_trans(:,i)');
conv_Open_kernel1=(OPEN_zones.*conv_kernel_trans(:,i)');
conv_Close_kernel1=(CLOSE_zones.*conv_kernel_trans(:,i)');


% a=inputdlg('enter:','open_close arm score',2)
% temp=str2num(char(a));
% open_score(i)=temp(1);
% close_score(i)=temp(2);
% 
CenterGrade(i)=length(find(conv_Center_kernel1>0))/length(find(conv_kernel_trans(:,i)>0));
OpenGrade(i)=length(find(conv_Open_kernel1>0))/length(find(conv_kernel_trans(:,i)>0))*3.74;
CloseGrade(i)=length(find(conv_Close_kernel1>0))/length(find(conv_kernel_trans(:,i)>0));

% figure(1);

abs_conv_kernel=(norm_transients);
for ii=1:length(zoneYtoX)

on_score(ii,i)=mean(abs_conv_kernel(zoneYtoX(ii)-50:zoneYtoX(ii),i));
off_score(ii,i)=mean(abs_conv_kernel(zoneYtoX(ii):zoneYtoX(ii)+50,i));



on_off_score(ii,i)=on_score(ii,i)-off_score(ii,i);


% hold on;scatter(off_score,on_score,'ro')
end

% for ii=1:length(zoneXtoX)
% on_score=mean(abs_conv_kernel(zoneXtoX(ii)-50:zoneXtoX(ii),i));
% off_score=mean(abs_conv_kernel(zoneXtoX(ii):zoneXtoX(ii)+50,i));
% 
% off_off_score(ii,i)=on_score-off_score;
% 
% end



end

pass1=[144:209];pass2=[408:480];pass3=[884:909];pass4=[973:1045];pass5=[1352:1417];pass6=[1841:1876];pass7=[2399:2486];