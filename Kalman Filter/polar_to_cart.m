% To keep it generic the function has to take a vector of inputs and
% output a vector of outputs.
function cart_out = polar_to_cart(polar_in)
    r = polar_in(1, :);
    phi = polar_in(2, :);

    x = r.*cos(phi);
    y = r.*sin(phi);
    
    cart_out = [x; y];
end