function d = dis(X,p,s)
if s == 'p'
    d = sqrt((X(1)-p(1))^2+(X(2)-p(2))^2);
elseif s == 'l'
    d = abs((X(2,2)-X(1,2))*p(1) - (X(2,1)-X(1,1))*p(2) + X(2,1)*X(1,2) - X(2,2)*X(1,1))...
        /sqrt((X(2,2) - X(1,2))^2 + (X(2,1) - X(1,1))^2);
end
end

