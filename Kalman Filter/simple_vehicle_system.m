function state = simple_vehicle_system(state, ~)
    state = state + ...
        [state(4)*cos(state(3))*0.01; state(4)*sin(state(3))*0.01;0;0];
end