function out = rot(ind,N)

if ind == N || ind == 0
    out = N;
else 
    out = mod(ind, N);

end

