function filteredData = outlierControl(data, startDay, id)
    EXPECTEDMAX = 500;
    outlierVector = data > EXPECTEDMAX;
    filteredData = data;
    filteredData(outlierVector == 1) = NaN;
    
    indicesOutliers = find(outlierVector);
    secondCol = indicesOutliers > length(outlierVector);
    indicesOutliers(secondCol) = indicesOutliers(secondCol) - length(outlierVector);
    indicesOutliers = unique(indicesOutliers);
    % Initialize a Date array of correct size
    n = length(indicesOutliers);
    
    
    days_outliers = cell(n, 1); 
    % The - 1 is because the first day should be startDay
    for ii = 1:1:n
        index = indicesOutliers(ii);
        days_str = date2str(startDay.add_days(index - 1));
        outlier_str = sprintf(':\t%s%.2f\t%s%.2f\n', 'Computed: ', data(index, 1), 'Predicted: ', data(index, 2));
        days_outliers{ii} = [days_str outlier_str];
    end
    
    filename = sprintf('%s%d%s', 'outlierLog_', id, '.txt');
    fileID = fopen(filename, 'wt');
    fprintf(fileID, '%s', transpose(char(days_outliers)));
    fclose(fileID);
end