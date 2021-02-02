function moveObstacles(speeds, headings)

global h_circ centers

for j=1:length(h_circ)
    P = get(h_circ(j),'Vertices');
    for i=1:length(P)
        P(i,1) = P(i,1) + speeds(j)*cos(headings(j));
        P(i,2) = P(i,2) + speeds(j)*sin(headings(j));
    end
    set(h_circ(j),'Vertices', P);
    centers(j, :) = [(min(P(:,1))+max(P(:,1)))/2, (min(P(:,2))+max(P(:,2)))/2];
end
