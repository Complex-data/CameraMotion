function state = f(x, v)
    state = x + [x(4)*cos(x(3))*0.01, x(4)*sin(x(3))*0.01, 0, 0]' ...
        + [0, 0, v(1), v(2)]';
end