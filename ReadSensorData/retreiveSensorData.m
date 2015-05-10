function data = retreiveSensorData(dataType)

data = zeros(1,77);

switch dataType
   case 'lat'
      id = 1;
    case 'lon'
      id = 2;
    case 'yaw'
      id = 6;
    case 'vn'
      id = 7;
    case 've'
      id = 8;
    case 'vf'
      id = 9;
    case 'wx'
      id = 18;
    case 'wy'
      id = 19;
    case 'wz'
      id = 20;  
   otherwise
      id = -1;
      fprintf('Error, enter valid data type\n')
end

if id ~= -1

    for k = 0:76

        dataTemp = load(['../SensorData/data/', indexToTextFileName(k)]);
        data(k+1) = dataTemp(id);

    end

end



end