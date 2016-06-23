function ResultTable=Fun_Map_DoC_GUIV2(ROIData,Data_DoC, DensityROI, Path_name)

%cd('Degree_Of_Colocalisation')
Path_name=pwd;
%         if exist('Statistic and Plots for Colocalization','dir')
%             rmdir('Statistic and Plots for Colocalization','s')
%         end
f1 = 'DoC statistics and plots';

mkdir(fullfile(Path_name, f1));

mkdir('Raw data maps'); % Plot 1
mkdir('Raw data maps with outliers removed'); % Plot 2
mkdir('Density and DoC maps'); % Plot 5


Plot1=1; % Raw data 2 Colors
Plot2=1; % 2 colors Removed outliers Data (DataNoOutliers)
Plot3=0; % Colocalisation and Density map: 2 colors, 'No Outliers', colocalisation map + density map
Plot4=0; % Colocalistion with Threshold: 2 colors 'No Outliers' threshold with colocalisation>0.4(ColoThres)
         %
Plot5=1; % 1 colors , 'Outliers' colocalisation map + density map independant for each color


ColoThres=0.4;
%%
        
        for cell=1:size(Data_DoC,2)
            for reg=1:size(Data_DoC,1)
                
        
                DataRaw=ROIData{reg,cell};
                Data_DoC1=Data_DoC{reg,cell};
                DensityROI_temp=DensityROI{reg,cell};
%%      
                if ~isempty(Data_DoC1)

                GenericName=strcat('Table_',num2str(cell),'_Region_',num2str(reg)); %t    
                % test Not a number value in column 5 6 and 12 (x y channel)
                
                TF=ismissing(Data_DoC1(:,:));
                [row col]=find(TF==1);
                Data_DoC1(row,:)=[];
                
%                 [col row]=find(isnan(DataNoOutliers(:,:)));
%                 DataNoOutliers(col,:)=[];

                
                x1=Data_DoC1.X(Data_DoC1.Ch==1); %  data from channel 1
                y1=Data_DoC1.Y(Data_DoC1.Ch==1); %  data from channel 2
                x2=Data_DoC1.X(Data_DoC1.Ch==2);
                y2=Data_DoC1.Y(Data_DoC1.Ch==2);

                x=Data_DoC1.X;
                y=Data_DoC1.Y;
                Lr=Data_DoC1.Lr;
                ch=Data_DoC1.Ch;
                d=Data_DoC1.Density; % Local Absolute Density
                Colo=Data_DoC1.DoC;
                D1_D2=Data_DoC1.D1_D2; % Local Absolute Density per Channel

                % Plotting Raw Data 2 colors
                if Plot1==1

                figure; hold on
                plot( DataRaw(DataRaw(:,12)==1,5), DataRaw(DataRaw(:,12)==1,6),'Marker'...
                                          ,'.','MarkerSize',4,'LineStyle','none','color','green');

                plot( DataRaw(DataRaw(:,12)==2,5), DataRaw(DataRaw(:,12)==2,6),'Marker'...
                                          ,'.','MarkerSize',4,'LineStyle','none','color','red');

                axis equal
                axis tight
                ax = gca;
                Xlimit=get(ax,'xlim');Ylimit=get(ax,'ylim');
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                
                saveas(gcf,strcat('Raw data 2 Colors\',GenericName ,'Raw_data'), 'tif');
                close gcf
                
                end

                % Plotting Remove outliers Data 2colors 

                if Plot2==1
                figure;  hold on 
                plot( DataRaw(:,5), DataRaw(:,6),'Marker','.','MarkerSize',4,'LineStyle','none','color','black');
                plot( x1, y1,'Marker','.','MarkerSize',4,'LineStyle','none','color','green');
                plot( x2, y2,'Marker','.','MarkerSize',4,'LineStyle','none','color','red');
                axis equal
                axis tight
                ax = gca;
                Xlimit=get(ax,'xlim');Ylimit=get(ax,'ylim');
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                saveas(gcf,strcat('Removed Outliers 2 Colors\',GenericName ,'Outliers'), 'tif');
                close gcf
                end

          %%    Map of Degree of Colocalisation and Density (+ Normalisation)
          
                dn=d./max(d);
                D1_D2_Norm=D1_D2/max(D1_D2);
                %zn=Colo./max(Colo);
                %prod=dn.*zn; % Product no used

                if Plot3==1
                figure;
                scatter(x,y,2,Colo);
                colorbar
                caxis([-1,1])
                axis equal
                axis tight
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                xlim(Xlimit);
                ylim(Ylimit);
                tt = getframe(gcf);
                %saveas(gcf,strcat('Colocalisation and Density map\',GenericName ,'Colocalisation_Map'), 'tif');
                imwrite(tt.cdata, strcat('Colocalisation and Density map\',GenericName ,'Colocalisation_Map.tif'))
                %export_fig(strcat('Plot3\',GenericName ,'Plot3a.tif'));
                %print(gcf,'dtiff',strcat('Colocalisation and Density map\',GenericName ,'Colocalisation_Map'))
                close gcf
                
                figure;
                scatter(x,y,2,dn);
                colorbar
                caxis([0,1])
                axis equal
                axis tight
                
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                tt = getframe(gcf);
                imwrite(tt.cdata, strcat('Colocalisation and Density map\',GenericName ,'Density_map.tif'));
                close gcf
                end
   
                %%

                if Plot4==1
                
                % Colocalisation Threshold
                figure;hold on
                figure4=plot( DataRaw(:,5), DataRaw(:,6),'Marker','.','MarkerSize',4,'LineStyle','none','color','black');
                plot( x, y,'Marker','.','MarkerSize',4,'LineStyle','none','color','blue');
                plot( x(Colo>=ColoThres & ch==1),y(Colo>=ColoThres & ch==1),'Marker','.','MarkerSize',4,'LineStyle','none','color','green');
                plot( x(Colo>=ColoThres & ch==2),y(Colo>=ColoThres & ch==2),'Marker','.','MarkerSize',4,'LineStyle','none','color','red');
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                axis equal
                axis tight
                xlim(Xlimit);
                ylim(Ylimit);
                tt = getframe(gcf);
                imwrite(tt.cdata, strcat('Colocalistion with Threshold\',GenericName ,'Coloc_Thres.tif'))
                %saveas(gcf,strcat('Plot5\',GenericName ,'Plot5'), 'tif');
                close gcf
                
                % Binary map Ch1
                figure;hold on
                plot( x(ch==1), y(ch==1),'Marker','.','MarkerSize',4,'LineStyle','none','color','blue');
                plot( x(Colo>=ColoThres & ch==1),y(Colo>=ColoThres & ch==1),'Marker','.','MarkerSize',4,'LineStyle','none','color','red');
                %plot( x(Colo>=ColoThres & ch==2),y(Colo>=ColoThres & ch==2),'Marker','.','MarkerSize',4,'LineStyle','none','color','red');
                set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                set(gcf,'Color',[1 1 1])
                axis equal
                axis tight
                xlim(Xlimit);
                ylim(Ylimit);
                tt = getframe(gcf);
                imwrite(tt.cdata, strcat('Colocalistion with Threshold\',GenericName ,'Binary_map_Ch1.tif'))
                %saveas(gcf,strcat('Plot5\',GenericName ,'Plot5'), 'tif');
                close gcf
                
                end
             
                %% Scatter plot of normalised density Ch1 or Ch2 vs colocalisation coefficient
                
                %% 1 colors density map, 'Outliers' independant for each color
                
                % Channel Ch1
                D1=Data_DoC1.D1_D2(Data_DoC1.Ch==1);
                DoC1=Data_DoC1.DoC (Data_DoC1.Ch==1);
                D1_Norm=D1/max(D1);
                
                Result.Correlation_Coloc1_vs_Density1=corr(D1,DoC1,'Type','Spearman');
                
                % Channel Ch2                
                D2=Data_DoC1.D1_D2(Data_DoC1.Ch==2);
                DoC2=Data_DoC1.DoC (Data_DoC1.Ch==2);
                D2_Norm=D2/max(D2);
                
                Result.Correlation_Coloc2_vs_Density2=corr(D2,DoC2,'Type','Spearman');
                                
%%                                                
                if Plot5==1
                    
                % Colocalisation and Density map per C   
                
                    figure
                    scatter( x1, y1,2,D1_Norm); 
                    axis equal
                    axis tight
                    xlim(Xlimit);
                    ylim(Ylimit);
                    colorbar
                    caxis([0,1])
                    set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                    set(gcf,'Color',[1 1 1])
                    tt = getframe(gcf);
                    imwrite(tt.cdata, strcat('Colocalisation and Density map per Ch\'...
                        ,GenericName ,'Density_Ch',num2str(1),'.tif'))
                    %saveas(gcf,strcat('Plot6\',GenericName ,'Plot6',strcat('_Ch',num2str(i))), 'tif');
                    close gcf
                    
                    figure
                    scatter( x2, y2,2,D2_Norm); 
                    axis equal
                    axis tight 
                    xlim(Xlimit);
                    ylim(Ylimit);
                    colorbar
                    caxis([0,1])
                    set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                    set(gcf,'Color',[1 1 1])
                    tt = getframe(gcf);
                    imwrite(tt.cdata, strcat('Colocalisation and Density map per Ch\'...
                        ,GenericName ,'Density_Ch',num2str(2),'.tif'))
                    %saveas(gcf,strcat('Plot6\',GenericName ,'Plot6',strcat('_Ch',num2str(i))), 'tif');
                    close gcf
                    
                    figure
                    scatter( x1, y1,2,DoC1); 
                    axis equal
                    axis tight 
                    xlim(Xlimit);
                    ylim(Ylimit);
                    colorbar
                    caxis([-1,1])
                    set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                    set(gcf,'Color',[1 1 1])
                    tt = getframe(gcf);
                    imwrite(tt.cdata, strcat('Colocalisation and Density map per Ch\'...
                        ,GenericName ,'DoC_Ch',num2str(1),'.tif'))
                    %saveas(gcf,strcat('Plot6\',GenericName ,'Plot6',strcat('_Ch',num2str(i))), 'tif');
                    close gcf
                    
                    figure
                    scatter( x2, y2,2,DoC2); 
                    axis equal
                    axis tight 
                    xlim(Xlimit);
                    ylim(Ylimit);
                    colorbar
                    caxis([-1,1])
                    set(gca, 'box','on','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])
                    set(gcf,'Color',[1 1 1])
                    tt = getframe(gcf);
                    imwrite(tt.cdata, strcat('Colocalisation and Density map per Ch\'...
                        ,GenericName ,'DoC_Ch',num2str(2),'.tif'))
                    %saveas(gcf,strcat('Plot6\',GenericName ,'Plot6',strcat('_Ch',num2str(i))), 'tif');
                    close gcf
                end

                %% Result Part
                
                % Percentage of molecules above the threshold

                Result.Percent_Ch1_ColocAbove04=length(x(Colo>=ColoThres & ch==1))/length( x(ch==1)); % 
                Result.Percent_Ch2_ColocAbove04=length(x(Colo>=ColoThres & ch==2))/length( x(ch==2));  %
                
                % Density Ch1 + Ch2
                Result.AvNorm_DensityAbove04=mean(dn(Colo>=ColoThres));
                Result.AvRela_DensityAbove04=mean(d(Colo>=ColoThres)/DensityROI_temp(1));
                Result.AvNorm_DensityBelow04=mean(dn(Colo<ColoThres));
                Result.AvRela_DensityBelow04=mean(d(Colo<ColoThres)/DensityROI_temp(1));
                
                Result.Correlation_ColocVsDensity=corr(d,Colo,'Type','Spearman');
                
                % Lr Above threshold channel 1
                
%                 Lr1=Data_DoC.Lr(Data_DoC.Ch==1);
%                 Lr1Norm=Lr1./max(Lr1);
%                 Result.PercentLrAbove05_Ch1=length(find(Lr1Norm>0.5))/length(Lr1);
%                 
%                 % Lr Above threshold channel 2
%                 Lr2=Data_DoC.Lr(Data_DoC.Ch==2);
%                 Lr2Norm=Lr2./max(Lr1);
%                 Result.PercentLrAbove05_Ch2=length(find(Lr2Norm>0.5))/length(Lr2);
                
                %%  Calculate the average normalised density for individual channel above/beow the threshold (0.4)

                % Channel 1
                D1=Data_DoC1.D1_D2(Data_DoC1.Ch==1);
                Result.Av_Rela_Density_Ch1=mean(D1/DensityROI_temp(2));
                Result.AvNorm_Density_Ch1=mean(D1_Norm);
                
                % Above threshold
                D1_above_04=Data_DoC1.D1_D2(Data_DoC1.Ch==1 & Data_DoC1.DoC>=ColoThres);
                
                Result.Av_DensityAbove04_Ch1=mean(D1_above_04);
                Result.Av_Rela_DensityAbove04_Ch1=mean(D1_above_04/DensityROI_temp(2));
                Result.AvNorm_DensityAbove04_Ch1=mean(D1_above_04/max(D1));
                
                % Below Threshold
                D1_below_04=Data_DoC1.D1_D2(Data_DoC1.Ch==1 & Data_DoC1.DoC<ColoThres);
                
                Result.Av_DensityBelow04_Ch1=mean(D1_below_04);
                Result.Av_Rela_DensityBelow04_Ch1=mean(D1_below_04/DensityROI_temp(2));
                Result.AvNorm_DensityBelow04_Ch1=mean(D1_below_04/max(D1));
                
                
                
                % Channel 2
                D2=Data_DoC1.D1_D2(Data_DoC1.Ch==2);
                Result.Av_Rela_Density_Ch2=mean(D2/DensityROI_temp(3));
                Result.AvNorm_Density_Ch2=mean(D2_Norm);
                
                % Above threshold
                D2_above_04=Data_DoC1.D1_D2(Data_DoC1.Ch==2 & Data_DoC1.DoC>=ColoThres);
                
                Result.Av_DensityAbove04_Ch2=mean(D2_above_04);
                Result.Av_Rela_DensityAbove04_Ch2=mean(D2_above_04/DensityROI_temp(3));
                Result.AvNorm_DensityAbove04_Ch2=mean(D2_above_04/max(D2));
                
                % Below Threshold
                D2_below_04=Data_DoC1.D1_D2(Data_DoC1.Ch==2 & Data_DoC1.DoC<ColoThres);
                
                Result.Av_DensityBelow04_Ch2=mean(D2_below_04);
                Result.Av_Rela_DensityBelow04_Ch2=mean(D2_below_04/DensityROI_temp(3));
                Result.AvNorm_DensityBelow04_Ch2=mean(D2_below_04/max(D2));
                

                ResultTable{reg,cell}=Result;
                else
                    ResultTable{reg,cell}=[];
                
                end
            
            end

        end  
        
 %% Annexes Convert to Xcel
 
A=ResultTable(:);
A=A (~cellfun('isempty',A),1);
ResultTable=A;
 
 %  small routine to extract and sort out the data
 %  Example to help build your own routines
 

    
    % Percent Colocalisaton above threshold
    Percent_Ch1_ColocAbove04=arrayfun(@(x) x{:}.Percent_Ch1_ColocAbove04,ResultTable);
    Percent_Ch2_ColocAbove04=arrayfun(@(x) x{:}.Percent_Ch2_ColocAbove04,ResultTable);
    
    % Density above threshold
%     AvNorm_DensityAbove04=arrayfun(@(x) x{:}.AvNorm_DensityAbove04,ResultTable);
%     AvRela_DensityAbove04=arrayfun(@(x) x{:}.AvRela_DensityAbove04,ResultTable);
%     
%     AvNorm_DensityBelow04=arrayfun(@(x) x{:}.AvNorm_DensityBelow04,ResultTable);
%     AvRela_DensityBelow04=arrayfun(@(x) x{:}.AvRela_DensityBelow04,ResultTable);
%     
%     % 
%     Correlation_ColocVsDensity=arrayfun(@(x) x{:}.Correlation_ColocVsDensity,ResultTable);
%    PercentLrAbove05_Ch1=arrayfun(@(x) x{:}.PercentLrAbove05_Ch1,ResultTable)
%    PercentLrAbove05_Ch2=arrayfun(@(x) x{:}.PercentLrAbove05_Ch2,ResultTable)
    
    Array1=[{'Percentage of colocalized Ch1 molecules'}, ...
        {'Percentage of colocalized Ch1 molecules'}]; %, ...
%         {'AvNormDensity>0.4'},	{'AvNormDensity<0.4'},...
%         {'AvRelaDensity>0.4'}, {'AvRelaDensity<0.4'}, {'Correlation DC vs Density'}];
    
    Matrix_Result1=[Percent_Ch1_ColocAbove04...
                    Percent_Ch2_ColocAbove04]; %...
%                     AvNorm_DensityAbove04...
%                     AvNorm_DensityBelow04...
%                     AvRela_DensityAbove04... 
%                     AvRela_DensityBelow04...
%                     Correlation_ColocVsDensity];% PercentLrAbove05_Ch1 PercentLrAbove05_Ch2];
     
    RegionName1=strcat('DoC Results'); % name of the sheet
    xlswrite('DoC Results',Array1,RegionName1,'A1'); %'Regiion' = name of the filename xcel shee, Array1 = data to put in the spreadsheet, 'A1' where to start
    xlswrite('DoC Results',Matrix_Result1,RegionName1,'A2');
    
    %% Density ch1 ch2
    
    
%     % Ch1 Above
%     Av_DensityAbove04_Ch1 = arrayfun(@(x) x{:}.Av_DensityAbove04_Ch1,ResultTable);
%     Av_Rela_DensityAbove04_Ch1 = arrayfun(@(x) x{:}.Av_Rela_DensityAbove04_Ch1,ResultTable);
%     Av_Norm_DensityAbove04_Ch1 = arrayfun(@(x) x{:}.AvNorm_DensityAbove04_Ch1,ResultTable);
%     
%     % Ch1 Below
%     Av_DensityBelow04_Ch1 = arrayfun(@(x) x{:}.Av_DensityBelow04_Ch1,ResultTable);
%     Av_Rela_DensityBelow04_Ch1 = arrayfun(@(x) x{:}.Av_Rela_DensityBelow04_Ch1,ResultTable);
%     Av_Norm_DensityBelow04_Ch1 = arrayfun(@(x) x{:}.AvNorm_DensityBelow04_Ch1,ResultTable);
%     
%     % Ch2 Above
%     Av_DensityAbove04_Ch2 = arrayfun(@(x) x{:}.Av_DensityAbove04_Ch2,ResultTable);
%     Av_Rela_DensityAbove04_Ch2 = arrayfun(@(x) x{:}.Av_Rela_DensityAbove04_Ch2,ResultTable);
%     Av_Norm_DensityAbove04_Ch2 = arrayfun(@(x) x{:}.AvNorm_DensityAbove04_Ch2,ResultTable);    
%     
%     % Ch2 Above
%     Av_DensityBelow04_Ch2 = arrayfun(@(x) x{:}.Av_DensityBelow04_Ch2,ResultTable);
%     Av_Rela_DensityBelow04_Ch2 = arrayfun(@(x) x{:}.Av_Rela_DensityBelow04_Ch2,ResultTable);
%     Av_Norm_DensityBelow04_Ch2 = arrayfun(@(x) x{:}.AvNorm_DensityBelow04_Ch2,ResultTable);    
%     
%     
%      Array2=[{'AvNormDensityCh1>0.4'},	{'AvNormDensityCh1<0.4'},...
%     {'AvRelaDensityCh1>0.4'},	{'AvRelaDensityCh1<0.4'}, ...
%     {'AvNormDensityCh2>0.4'},	{'AvNormDensityCh2<0.4'},...
%     {'AvRelaDensityCh2>0.4'},	{'AvRelaDensityCh2<0.4'}];
    
%     Matrix_Result2=[100*Av_Norm_DensityAbove04_Ch1...
%                     100*Av_Norm_DensityBelow04_Ch1... 
%                     Av_Rela_DensityAbove04_Ch1...
%                     Av_Rela_DensityBelow04_Ch1... 
%                     Av_Norm_DensityAbove04_Ch2...
%                     Av_Norm_DensityBelow04_Ch2... 
%                     Av_Rela_DensityAbove04_Ch2...
%                     Av_Rela_DensityBelow04_Ch2];
    
%     RegionName2=strcat('DC Results2');
%     xlswrite('Region',Array2,RegionName2,'A1');
%     xlswrite('Region',Matrix_Result2,RegionName2,'A2');   
% 
%         
        save('ResultTable','ResultTable');
        toc      
cd ..
end    
    
    
        
        