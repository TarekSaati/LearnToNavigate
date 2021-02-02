function [G, dI] = nnBackPropagation(W, L, Z, dY, nHidden, dfh, dfo)

if isa(dfh, 'function_handle') && isa(dfo, 'function_handle')
    if isempty(nHidden)              % No Hidden Layers (Linear Network)
        dZ = dY.*dfo(Z{1});
        dI = W{1}'*dZ;
        G{1} = dZ*L{1}';
    else
        NLh = length(nHidden);       % number of Hidden Layers  
        G = cell(1,NLh+1);
        dZ = dY.*dfo(Z{end}); 
        G{end} = dZ*L{end}';
        for i=1:NLh
            dL = W{end-i+1}'*dZ;
            dZ = dL(2:end).*dfh(Z{end-i});   % W{i} connects L{i} with L{i+1}
            G{end-i} = dZ*L{end-i}';
        end  
        dI = W{1}'*dZ;
    end       
end
