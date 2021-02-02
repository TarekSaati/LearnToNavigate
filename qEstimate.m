function Q_est = qEstimate(tar_params, pol_params, nextObsv, streamSizes, ...
                            fh, fo, reward, gamma)
    if ~isempty(nextObsv) 
        Q_tar = FeedForward(tar_params, nextObsv, streamSizes, fh, fo);   
        Q_pol = FeedForward(pol_params, nextObsv, streamSizes, fh, fo);
        [~, i] = max(Q_pol);
    
        Q_est = reward + gamma*Q_tar(i);
    else
        Q_est = reward;
    end
    
end