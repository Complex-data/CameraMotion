function meas = simple_measurement_v2(state, noise)
    meas = state(1:2, 1) + noise;
end