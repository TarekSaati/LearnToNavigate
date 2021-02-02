function [Q, L, Z] = nnFeedForward(W, input, Nh, fh, fo)
    
if isa(fh, 'function_handle') && isa(fo, 'function_handle')
    if isempty(Nh)              % No Hidden Layers (Linear Network)
        L{1} = [1; input];
        Z{1} = W{1}*L{1};
        Q = fo(Z{1});
    else
        NLh = length(Nh);       % number of Hidden Layers        
        % input is a scaled column vector
        L = cell(1,NLh+1);        % "L" contains Input & Hidden Layers
        L{1} = [1; input]; 
        Z = cell(1,NLh+1);        % "Z" includes Hidden & Output expressions
        for i=1:NLh
            Z{i} = W{i}*L{i};   % W{i} connects L{i} with L{i+1}
            L{i+1} = [1; fh(Z{i})];
        end
        Z{end} = W{end}*L{end};
        Q = fo(Z{end});         % Output Layer     
    end
end