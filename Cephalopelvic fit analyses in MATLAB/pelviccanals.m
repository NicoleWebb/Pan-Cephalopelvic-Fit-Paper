%% Preamble

clc
clear 

%%  Load data
Pelvis = readtable("Pelvis_Data_09_06_2021.csv");
Skull = readtable("Skull_Data_09_06_2021.csv");
P1 = table2array( Pelvis );
P2 = table2array( Skull );

%%

 DistanceMatrix = nan(length(P1),length(P2));
%%

Granularity = 1;% sample every __ point to reduce time

for P1_iter = 1:Granularity:length(P1)
    
    for P2_iter = 1:Granularity:length(P2)
        
        DistanceMatrix(P1_iter,P2_iter) = distancePoints3d(P1(P1_iter,:),P2(P2_iter,:),2);
        
    end
    
    disp([P1_iter length(P1)]);
    
end

%%

save('ResultMatrix','P1','P2','Granularity', 'DistanceMatrix', '-v7.3')

%%

[AllMinDistances PelIndex] = min(DistanceMatrix,[],1); % select unique skull points
[AllMinDistances PelIndex] = min(DistanceMatrix,[],2); % Alternativ 1 select unique pelvis points
% [AllMinDistances PelIndex] = min(DistanceMatrix); % Alternativ 2 select overall min points (loop)

[AllMinDistances_Sorted AllMinDistances_SortIndex] = sort(AllMinDistances);
PelIndex_Sorted = PelIndex(AllMinDistances_SortIndex);

TopPercentageToPlot = 0.1; % User input
NumberOfLines2Plot = ceil(length(find(AllMinDistances>0))*TopPercentageToPlot);
SelectedDistances2Plot = AllMinDistances_Sorted(1:NumberOfLines2Plot);

%%
Granularity = 1;

figure
plot3(P2(1:Granularity:end,1),P2(1:Granularity:end,2),P2(1:Granularity:end,3),'LineStyle','none','Marker','.')
hold all
plot3(P1(1:Granularity:end,1),P1(1:Granularity:end,2),P1(1:Granularity:end,3),'LineStyle','none','Marker','.')

for plot_index = 1:NumberOfLines2Plot % in case you want to plot the top *percentage* of lines
%for plot_index = 1:1400 % in case you want to plot the top *number* of lines
%     plot3([P2(AllMinDistances_SortIndex(plot_index),1) P1(PelIndex_Sorted(plot_index),1)],...
%         [P2(AllMinDistances_SortIndex(plot_index),2) P1(PelIndex_Sorted(plot_index),2)],...
%         [P2(AllMinDistances_SortIndex(plot_index),3) P1(PelIndex_Sorted(plot_index),3)],'k')
    plot3([P2(PelIndex_Sorted(plot_index),1) P1(AllMinDistances_SortIndex(plot_index),1)],...
        [P2(PelIndex_Sorted(plot_index),2) P1(AllMinDistances_SortIndex(plot_index),2)],...
        [P2(PelIndex_Sorted(plot_index),3) P1(AllMinDistances_SortIndex(plot_index),3)],'k')
end

%%

fprintf('The average length of the top %g percent of shortest distances is %gmm. \n',TopPercentageToPlot*100, mean(SelectedDistances2Plot))