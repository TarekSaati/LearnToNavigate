function [Lp, Cp, Sp] = evaluate_path(path, obs, rmin)

Lp = 0; k =0; r=zeros(1,length(path)-2);
for i=1:length(path)-1
   Lp = Lp + dis(path(i,:), path(i+1,:),'p'); 
   if i>1
       k = k+1;
       r(k) = min(1000,rot3p(path(i-1,:), path(i,:), path(i+1,:)));
   end
end
Cp = 100*(1-rmin*(sum(abs(1./r)))/length(r));
obs_mat = [];
for j=1:length(obs)
   obs_mat = [obs_mat; obs{j}]; 
end
Sp = min(min(pdist2(path, obs_mat)));

end

