function [gBest, swarm]= pso(c,iw,mu,max_iter,lower_bound,upper_bound,swarm_size,problem)
%pso is an implementation of particle swarm optimization technique for a
%minimization problem
%   when called pso() it solves the provided example
%% initialize parameters
if nargin==0
    c = [0.1,0.2]; %[cognitive acceleration, social acceleration] coefficients
    iw = [0.5 0.01]; %[starting, ending] inertia weight
    mu = 0.1; % Mutarion rate
    max_iter = 2000; %maximum iterations
    lower_bound = [0,0,0,0]; %lower bound of vars
    upper_bound = [pi/2,pi/2,pi/2,pi/2]; %upper bound of vars
    swarm_size=200; % swarm size
    problem=@cost_fcn; % objective function and constraint function
end
%% initialize particles
w = @(it) ((max_iter - it) - (iw(1) - iw(2)))/max_iter + iw(2);
pm = @(it) (1-(it-1)/(max_iter-1))^(1/mu);
swarm(1,swarm_size) = Particle();
for i =1:swarm_size
    swarm(i)=Particle(lower_bound,upper_bound,problem);
end
[~,I] = min([swarm.pBest_cost]);
gBest = swarm(I);
%% Loop
for it=1:max_iter
    wc = w(it); %current inertia weight
    pc = pm(it); %current mutation probiblity
    for i =1:swarm_size %update particles
        swarm(i)=swarm(i).update(wc,c,pc,gBest,problem);
    end
    [B,I] = min([swarm.cost]);
    if gBest.cost > B %update global best
        gBest = swarm(I);
    end
end
