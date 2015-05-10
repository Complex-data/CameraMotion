function t = readTimeStamps()


data = load('../SensorData/timestamps.txt');


t = (data - data(1)).';

end