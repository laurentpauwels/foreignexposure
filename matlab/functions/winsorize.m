function winsorizedData = winsorize(data, trimPercent)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% winsorize.m trims both ends of the data by x percent
% Inputs:
%       data            Double  data series to winsorize.
%       trimPercent     int     decimal value of % to trim.
% Output:
%       winsorizedData  Double  data winsorized.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort the data
sortedData = sort(data);

% Calculate the number of elements to trim
n = length(data);
trimCount = round(trimPercent * n);

% Determine the trim thresholds
lowerThreshold = sortedData(trimCount+1);
upperThreshold = sortedData(end-trimCount);

% Winsorize the data
winsorizedData = data;
winsorizedData(data < lowerThreshold) = lowerThreshold;
winsorizedData(data > upperThreshold) = upperThreshold;
end