%tire du document de reference du cours phs4700

% Solution equations differentielles par methode de RK4
% Equation a resoudre : dq/dt=g(q,t)
% avec
% qs : solution [q(to+DeltaT)]
% q0 : conditions initiales [q(t0)]
% DeltaT : intervalle de temps
% g : membre de droite de ED.
% C’est un m-file de matlab
% qui retourne la valeur de g au temps choisi

function [qs] = RungeKutta (q0,t0,DeltaT,g)
k1=feval(g,q0,t0);
k2=feval(g,q0+k1*DeltaT/2,t0+DeltaT/2);
k3=feval(g,q0+k2*DeltaT/2,t0+DeltaT/2);
k4=feval(g,q0+k3*DeltaT,t0+DeltaT);
qs=q0+DeltaT*(k1+2*k2+2*k3+k4)/6;
endfunction
