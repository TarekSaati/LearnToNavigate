function out = sat(x,bnd)


if abs(x) <= bnd
    out = x;
else
    out = sign(x)*bnd;

end

