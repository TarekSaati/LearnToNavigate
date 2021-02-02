function a = nnEpsilonGreedyExploration(Q, actions, epsilon)

    n_actions = length(actions);
    if (rand() >= epsilon)
        [~, a] = max(Q);
    else
        a = randi(n_actions);
    end
end