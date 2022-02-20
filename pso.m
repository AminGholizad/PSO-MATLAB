function [gBest, swarm]= pso(options)
%pso is an implementation of particle swarm optimization technique for a
%minimization problem
%   when called pso() it solves the provided example
%% initialize parameters
if nargin==0
    options=psooptions();
end
%% initialize particles
w = @(it) ((options.max_iter - it) - (options.iw(1) - options.iw(2)))/options.max_iter + options.iw(2);
pm = @(it) (1-(it-1)/(options.max_iter-1))^(1/options.mu);
swarm(1,options.swarm_size) = Particle();
for i =1:options.swarm_size
    swarm(i)=Particle(options.lower_bound,options.upper_bound,options.problem);
end
[~,I] = min([swarm.pBest_cost]);
gBest = swarm(I);
%% Loop
for it=1:options.max_iter
    wc = w(it); %current inertia weight
    pc = pm(it); %current mutation probiblity
    for i =1:options.swarm_size %update particles
        swarm(i)=swarm(i).update(wc,options.c,pc,gBest,options.problem);
    end
    [B,I] = min([swarm.cost]);
    if gBest.cost > B %update global best
        gBest = swarm(I);
    end
    if options.display
        M = mean([swarm.cost]);
        if mod(it,10)==0 || it==1
            fprintf("\t\t\t\tBest\t\t\t\tMean\n")
            fprintf("Generation\t\tf(x)\t\t\t\tf(x)\n")
        end
        fprintf("%d\t\t\t%0.06f\t\t\t\t%0.06f\n",it,B,M)
    end
end
