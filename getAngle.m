function [angle, new_pr, new_pl] = getAngle(Rw, W, posr, posl, pr, pl, theta)

new_pr = Rw*wb_position_sensor_get_value(posr);
new_pl = Rw*wb_position_sensor_get_value(posl);
dr = new_pr - pr;
dl = new_pl - pl;
angle = theta + (dr - dl)/W;

end

