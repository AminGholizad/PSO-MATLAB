function options = psooptions()
%% problem params
options.max_iter = 200; %maximum iterations
options.lower_bound = [0,0,0,0]; %lower bound of vars
options.upper_bound = [pi/2,pi/2,pi/2,pi/2]; %upper bound of vars
options.swarm_size=20; % swarm size
options.problem=@cost_fcn; % objective function and constraint function
%% pso coefficients
options.c = [0.1,0.2]; %[cognitive acceleration, social acceleration] coefficients
options.iw = [0.5 0.01]; %[starting, ending] inertia weight
options.mu = 0.1; % Mutarion rate
%% display
options.display = true;
