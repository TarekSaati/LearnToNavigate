function action = chooseAction(inDanger, Q, epsilon, actions)

if rand() < epsilon
    action = randi(length(actions) - ~inDanger);
else
    [~, action] = max(Q);
end

end

