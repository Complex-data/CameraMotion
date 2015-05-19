function data = retreiveSensorData(dataType)
    %% Retreives ground truth data, 4 and 12 is position
    data = zeros(1,77);

    tempData = load('..\SensorData\00.txt');

    data = tempData(1:1035, dataType);  % We only have images
                                        % 0-1034
end