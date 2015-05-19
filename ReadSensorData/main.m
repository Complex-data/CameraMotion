clc, clear

t = readTimeStamps();

x = retreiveSensorData(4);
y = retreiveSensorData(12);

plot(x, y)