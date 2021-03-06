function p = deco_rk4_isp_noise_test(noise_level)
	% Set up the unit
	u = ra.unit.deco_10;
	noise_mu = [0.31 0];
	noise_sigma = [noise_level noise_level];
	u.E.P = struct('mu',noise_mu(1),'sigma',noise_sigma(1),'name','gaussian');
	u.I.P = struct('mu',noise_mu(2),'sigma',noise_sigma(2),'name','gaussian');

	% Set up the network, global coupling, and delays
	net = ra.network.import('stam_cortical');
	coupling = 0.14;
	[c,d] = net.netmats;
	mean_distance = mean(d(logical(triu(ones(size(d)),1))));
	min_distance = min(d(logical(triu(ones(size(d)),1)))); % The maximum allowed velocity is min_distance/tstep. The smallest delay is then  mean_distance/(min_distance/tstep) 
	% For 5e-5, cortical has 
	mean_delays = 1e-3*(9);
	velocity = mean_distance./mean_delays;

	% Set up ISP parameters
	isp_target = 0.15;

	% Return the simulation Pepper object
	p = ra.sweep.simulate_plasticity(ra.network.import('stam_cortical'),u,velocity,coupling,isp_target)


