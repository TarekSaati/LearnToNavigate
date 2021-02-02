function [Q, L, Z] = FeedForward(W, obsv, streamSizes, fh, fo)

% nHidden: matrix with size of #Layers, and values of #nodes in layers
nStreams = length(streamSizes); Ni = zeros(1, nStreams); Nh = cell(1, nStreams);
L = cell(1, nStreams); Z = cell(1, nStreams); O = cell(1, nStreams); phi = [];
last_node = 0;
for i=1:nStreams
    Ni(i) = streamSizes{i}(1);
    if length(streamSizes{i}) < 3, Nh{i} = [];
    else, Nh{i} = streamSizes{i}(2:end-1); end
    if i < nStreams && nStreams > 1
        [O{i}, L{i}, Z{i}] = nnFeedForward(W{i}, obsv(last_node+1:last_node+Ni(i)), ...
                                Nh{i}, fh, fh);
        last_node = last_node + Ni(i);
        phi = [phi; O{i}];
    elseif nStreams == 1
        [Q, L{i}, Z{i}] = nnFeedForward(W{i}, obsv, Nh{i}, fh, fo);
    else
        [Q, L{i}, Z{i}] = nnFeedForward(W{i}, phi, Nh{i}, fh, fo);        
    end

end

end

