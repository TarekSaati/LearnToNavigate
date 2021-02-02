function u = controller(err,uM,T,lampda,sigma)

e_past = err(1);
e = err(2);
edot = (e-e_past)/T;
if abs(e) <= sigma
    gamma = lampda*e;
else
    gamma = lampda*sigma*sign(e);
end

u = uM*tanh(edot + gamma);

end

