% Function describing the measurement equation used in the UKF
function meas = measFunc(state, noise)
    meas = state(3:4) + noise;
end