function cd_paths = generate_paths(circles, curves, graph, p0, G, AB_pts, stp, targets)

paths = {};
% "paths" includes: path points, state[S,D,O], info[#Obs #ABpnt #Aprime lastPntOnCircle], targetObs
paths{1} = {p0(1:2) 'S' [1 1 1 1] []};
cd_paths = {}; cd_paths{1} = {[] 0 0};
count = 0;
for k=1:2
    for j=1:length(AB_pts{k}{2})
        c = 0;
        count = count + 1;
        paths{count}{3}(3) = 1;
        paths{count}{4} = graph{k}{j}(2,3)+1;
        paths{count}{3}(1:2) = [k j];
        paths{count}{2} = 'S';
        for i=1:AB_pts{k}{2}(j)
            if (mod(i,5) == 1 && AB_pts{k}{2}(j) > 5) || (mod(i,2) == 1 ...
                    && AB_pts{k}{2}(j) <= 5)
                c = c+1;
                paths{count}{1}(c,:) = circles{k}(i,:);
            end
        end
        paths{count}{3}(4) = c;
    end
end
% concurrent path generation loop 
d = 0; cd = 0;
while d ~= length(paths)
    for j = 1:count
%         disp('---------');
        i = length(paths{j}{1}(:,1)) + 1;
        switch paths{j}{2}
            
            case 'O'
                idx = paths{j}{3};
                nObj = graph{idx(1)}{idx(2)}(idx(3)+1,3);                % index of object in graph_curves: 1--> Goal , 2 --> obs1 ...
                pos = graph{idx(1)}{idx(2)}(idx(3)+1,4);                 % # of A'(B') point
                obj = curves{targets(nObj)};
                A = graph{idx(1)}{idx(2)}(1,1:2);
                Ap = obj(pos,:);
                dir = atan2(Ap(2)-A(2),Ap(1)-A(1));
                ang = atan2(obj(rot(pos+1,length(obj)),2)-Ap(2),obj(rot(pos+1,length(obj)),1)-Ap(1));
                switch pos
                    case 1
                        sorted = obj;
                    case length(obj)
                        sorted = [Ap; obj(1:end-1,:)];
                    otherwise
                        sorted = [obj(pos:end,:); obj(1:pos-1,:)];
                end
                if abs(dir - ang) > pi/2
                    sorted = [Ap; flipud(sorted(2:end,:))];
                end
                m = 0;
                istp = 0;
                p = j;
                first_time = true;
                tmp_path = paths{j}{1};
                buffer = [];
                while m < length(sorted)
                    m = m + 1;
                    ind = isApnt(sorted(m,:), nObj+1, AB_pts, (m==1)*stp+1e-3);
                    if ind ~= -1
                        for c=2:length(graph{nObj+1}{ind}(:,1))
                        i1 = graph{nObj+1}{ind}(c,3);
                        if i1 == 1                      % goal segment
                            d1 = dis(sorted(m,:),G,'p');
                            d2 = dis(sorted(rot(m-1,length(sorted)),:),G,'p');
                            isCloser = true;
                        else
                            target_curve = curves{targets(i1)};
                            i2 = graph{nObj+1}{ind}(c,4);
                            d1 = dis(sorted(m,:),target_curve(i2,:),'p');
                            d2 = dis(sorted(rot(m-1,length(sorted)),:), ...
                                target_curve(i2,:),'p');
                            
                            isCloser = min(pdist2(target_curve, G)) < ...
                                min(pdist2(sorted, G));
                        end
                        if  isCloser && d1 < d2 && ~ismember(i1+1, buffer)
                            if ~first_time
%                                 disp(['path',num2str(j),' ++ ',num2str(count)]);
                                count = count + 1;
                                p = count;
                            end
                            if c == 2
                                istp = istp + 1;
                                tmp_path(i+istp-1,:) = sorted(m,:);
                            end
                            paths{p}{1} = tmp_path;
                            paths{p}{2} = 'S';
                            paths{p}{3} = [nObj+1, ind, c-1, paths{j}{3}(4)];
                            if ismember(i1+1, paths{j}{4}), buffer  = [buffer, i1+1]; end
                            paths{p}{4} = [paths{j}{4}, i1+1];
                            first_time = false;
                        else
                                istp = istp + 1;
                                tmp_path(i+istp-1,:) = sorted(m,:);
                        end
                        end
                    else
                        
                        istp = istp + 1;
                        tmp_path(i+istp-1,:) = sorted(m,:);
                    end
                    if paths{j}{2} == 'O' && m == length(sorted)
                        
                        d = d+1; paths{j}{2} = 'D';
                    end
                end
                
            case 'S'
                idx = paths{j}{3};                                           % [#Obs #ABpnt #Aprime Initcircle]
                A = graph{idx(1)}{idx(2)}(1,1:2);                           % A & B points
%                 for c=1:length(graph{idx(1)}{idx(2)}(:,1))-1
                    Ap = graph{idx(1)}{idx(2)}(idx(3)+1,1:2);
                    L = floor(dis(A, Ap, 'p')/stp+1);
                    line = linspace(0,1,L)';
                    line = line(2:end);
%                     if c > 1
%                         count = count + 1;
%                         paths{count} = paths{j};
%                         paths{count}{3}(3) = 2;
%                         paths{count}{1}(i:i+L-2,:) = [A(1) + line*(Ap(1)-A(1)), ...
%                             A(2) + line*(Ap(2)-A(2))];
%                         if dis(paths{count}{1}(end,:), G, 'p') < stp
%                             paths{count}{2} = 'D';
%                             d = d + 1; cd = cd+1;
%                             cd_paths{cd}{1} = paths{count}{1};
%                             cd_paths{cd}{2} = length(paths{count}{1}(:,1));             % path length
%                             cd_paths{cd}{3} = paths{count}{3}(3);
%                         elseif isApnt(paths{count}{1}(end,:),graph{idx(1)}{idx(2)}(c+1,3)+1,AB_pts,stp) ~= -1
%                             ind = isApnt(paths{count}{1}(end,:),graph{idx(1)}{idx(2)}(c+1,3)+1,AB_pts,stp);
%                             paths{count}{3} = [graph{idx(1)}{idx(2)}(c+1,3)+1, ind, c, paths{j}{3}(4)];
%                         else
%                             paths{count}{2} = 'O';
%                         end
%                     else
                        paths{j}{1}(i:i+L-2,:) = [A(1) + line*(Ap(1)-A(1)), ...
                            A(2) + line*(Ap(2)-A(2))];
                        if isequal(Ap, G)
                            paths{j}{2} = 'D';
                            d=d+1; cd = cd+1;
                            cd_paths{cd}{1} = paths{j}{1};
                            cd_paths{cd}{2} = length(paths{j}{1});             % path length
                            cd_paths{cd}{3} = paths{j}{3}(4);
%                         elseif isApnt(paths{j}{1}(end,:),graph{idx(1)}{idx(2)}(c+1,3)+1,AB_pts,stp) ~= -1
%                             ind = isApnt(paths{j}{1}(end,:),graph{idx(1)}{idx(2)}(c+1,3)+1,AB_pts,stp);
%                             paths{j}{3} = [graph{idx(1)}{idx(2)}(c+1,3)+1, ind, c, paths{j}{3}(4)];
                        else
                            paths{j}{2} = 'O';
                        end
%                     end
%                 end
                
        end
    end
end


end

