function out = imod(ind,N)

if mod(ind, N) == 0
    out = N;
else 
    out = mod(ind, N);
end

