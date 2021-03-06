function ExportDBSCANDataToExcelFiles(cellROIPair, Result, outputFolder, chan)

    % Formerly Final_Result_DBSCAN_GUIV2
    % Extracts and exports Results table into Excel format

    A = Result(:);
    A = A(~cellfun('isempty', A));
    Percent_in_Cluster_column = cell2mat(cellfun(@(x) x.Percent_in_Cluster, A, 'UniformOutput', false));
    Number_column = cell2mat(cellfun(@(x) x.Number, A, 'UniformOutput', false));
    Area_column = cell2mat(cellfun(@(x) x.Area, A , 'UniformOutput', false));
    Density_column = cell2mat(cellfun(@(x) x.Density, A, 'UniformOutput', false));
    RelativeDensity_column = cell2mat(cellfun(@(x) x.RelativeDensity, A, 'UniformOutput', false));
    TotalNumber = cell2mat(cellfun(@(x) x.TotalNumber, A, 'UniformOutput', false));
    Circularity_column = cell2mat(cellfun(@(x) x.Mean_Circularity, A,'UniformOutput', false));
    Number_Cluster_column = cell2mat(cellfun(@(x) x.Number_Cluster, A, 'UniformOutput', false));

    %export data into Excel

    HeaderArray=[{'Cell'},{'ROI'},{'x bottom corner'},{'y bottom corner'},{'Size of ROI (nm)'},{'Comments'},{'Percentage of molecules in clusters'},...
        {'Average number of molecules per cluster'}, {'Average cluster area (nm^2)'}, {'Abslute density in clusters (molecules / um^2)'}, ...
        {'Relative density in clusters'}, {'Total number of molecules in ROI'}, ...
        {'Circularity'}, {'Number of clusters in ROI'}, {'Density of clusters (clusters / um^2)'}];

    Matrix_Result = [Percent_in_Cluster_column*100 , Number_column(:,1) , Area_column(:,1) , Density_column*1e6 ,...
        RelativeDensity_column, TotalNumber, Circularity_column, Number_Cluster_column, Number_Cluster_column./(1e-6*cellROIPair(:,5))];

    xlswrite(fullfile(outputFolder, 'DBSCAN Results.xls'), cellROIPair, sprintf('Chan%d', chan), 'A2');
    xlswrite(fullfile(outputFolder, 'DBSCAN Results.xls'), HeaderArray, sprintf('Chan%d', chan), 'A1');
    xlswrite(fullfile(outputFolder, 'DBSCAN Results.xls'), Matrix_Result, sprintf('Chan%d', chan), 'G2');

end