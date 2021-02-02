function [Q, L, Z] = onFeedForward(pol_params, obsv, hidden, fh, fo)

% nHidden: matrix with size of #Layers, and values of #nodes in layers
% First Stream (Spatial obsv)
[phi1, L1, Z1] = nnFeedForward(pol_params{1}, obsv(1:end-4), hidden{1}, fh, fh);

% Second Stream (Temporal obsv)
[phi2, L2, Z2] = nnFeedForward(pol_params{2}, obsv(end-3:end), hidden{2}, fh, fh);

% Output Stream
[Q, L3, Z3] = nnFeedForward(pol_params{3}, [phi1; phi2], hidden{3}, fh, fo);
L(1:3) = {L1 L2 L3}; Z(1:3) = {Z1 Z2 Z3};

end

