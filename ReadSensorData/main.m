clc, clear

t = readTimeStamps();
wx = retreiveSensorData('wx');
wy = retreiveSensorData('wy');
wz = retreiveSensorData('wz');

yaw = retreiveSensorData('yaw');

plot(t, yaw)