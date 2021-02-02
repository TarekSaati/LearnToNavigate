function out = inRange(i,j,N,r)

out = false;
for k=1:r
   if rot(i-k,N) == j || rot(i+k,N) == j
       out = true;
   end
end

end
