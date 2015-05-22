function meas = measFunc(state, noise)
    meas = state(3:4) + noise;
end