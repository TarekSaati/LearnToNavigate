function moveRobot(force, Vmax, Wmax)

global center angle h_car

Amp = force(1); Ang = force(2);
v = min(Vmax, Amp);
w = max(-Wmax, min(Wmax, Ang-angle));
angle = angle + w;
angle = angle+2*pi*(angle<=-pi)-2*pi*(angle>pi);
center = moveCarCircle(v, angle, w, h_car(1));
moveSensor(v, center, angle, w, h_car(2));

end