function r = rot3p(pre,pt,pst)

a = dis(pre, pt, 'p');
b = dis(pt, pst, 'p');
c = dis(pre, pst, 'p');
% w = 0;
r = a*b*c/(sqrt(max(0,(a+b+c)*(-a+b+c)*(a+b-c)*(a-b+c))));
% if r < inf
%     syms x y
%     [cx,cy]= solve((pre(1)-x)^2+(pre(2)-y)^2==(pt(1)-x)^2+(pt(2)-y)^2, ...
%         (pst(1)-x)^2+(pst(2)-y)^2==(pt(1)-x)^2+(pt(2)-y)^2);
%     cx = double(cx);
%     cy = double(cy);
%     thpre = atan2(pre(2)-cy,pre(1)-cx) + 0.0001;
%     thpt = atan2(pt(2)-cy,pt(1)-cx) + 0.0001;
%     thpre = thpre - (sign(thpre)-1)*pi;
%     thpt = thpt - (sign(thpt)-1)*pi;
%     if (thpre - thpt < 0 && thpre - thpt > -pi) || thpre - thpt > pi
%         w = vr/r;
%     elseif (thpre - thpt > 0 && thpre - thpt < pi) || thpre - thpt < -pi
%         w = -vr/r;
%     end
% end
end