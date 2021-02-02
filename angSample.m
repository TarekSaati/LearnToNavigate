function ang = angSample(validHeads)

r = randi(length(validHeads(:,1)));
set = validHeads(r,:);
ang = rand()*(set(2)-set(1))+set(1);

end

