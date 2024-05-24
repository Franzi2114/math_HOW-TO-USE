Here are some information on how to get started with the new function for the 7-parameter drift diffusion model.

The paper introducing the new function to Stan is Henrich et al. (2023). There is the theoratical background and a description on how to set up the diffusion model in Stan.

The function is available in Stan (since release 2.35.0, June 2024).

Please feel free to use the function for your purposes and report any bugs or ask questions to the authors:

Franziska Henrich (franziska.henrich@psychologie.uni-freiburg.de) and Valentin Pratz (pratz@stud.uni-heidelberg.de,

or open an issue on Github referring to the seven-parameter diffusion model: https://github.com/stan-dev/math/issues.

## Remark
1) The function is now called in another way as described in the paper: To call the function use `wiener()` or `wiener_lpdf()` instead of `wiener_full()` or `wiener_full_lpdf()`, respectively (also have this in mind when you look at Valentines example below).
2) The ordering of the variables is the following: `wiener_lpdf(a, t0, w, v, sv, sw, st0)`. In an earlier version of the code we used another ordering. But this will cause weird errors. (Again, in Valentines code below, the old ordering is present. Don't be confused of this.)

## Illustration of the function's behavior
Valentin followed the three-level setup by Boehem et al. (2018) and provides a hands-on illustration of the function's behavior in three blog entries:  
[Level 1](https://valentinpratz.de/posts/2022-12-29-stan-wiener_full-level-1/)  
[Level 2](https://valentinpratz.de/posts/2022-12-30-stan-wiener_full-level-2/)  
[Level 3](https://valentinpratz.de/posts/2023-01-11-stan-wiener_full-level-3/)


## Example R-Code for cmdstanr.

data.rds of the form: condition|resonse|reaction_time

	library(cmdstanr)
	library(readr)
	set_cmdstan_path("path/to/cmdstan")
	file <- file.path("stan/wiener_lpdf.stan")
	mod <- cmdstan_model(file)
	init.full = function(chains=4, N=200){
	  L = list()
	  for (i in 1:chains) {
	    L[[i]] = list(
	      a = 1,
	      zr_m = 0.5,
	      v_m = c(0,0),
	      t0_m = 0.1,
	      zr_s = 0.1,
	      v_s = 0.2,
	      t0_s = 0.1
	    )
	  }
	  return (L)
	}

	sim.data = readRDS("path/to/data.rds")
	stan.data = list(
	  N = nrow(sim.data),     # Number of Trials
	  cnd = sim.data$cnd,     # stimulus type (1,2)
	  Ncnds = length(unique(sim.data$cnd)), # Number of conditions
	  rt = sim.data$rt,       # Rt in seconds!
	  resp = sim.data$resp,    # response (0=lower threshold, 1=upper threshold)
	  precision = 1e-3,
	  parallel = 0
	)
	fit <- mod$sample(
	  data = stan.data,
	  seed = 123,
	  chains = 4,
	  parallel_chains = 4,
	  refresh = 10,
	  iter_warmup = 200,
	  iter_sampling = 300,
	  init = init.full()
	)
 

## References
Boehm, U., Annis, J., Frank, M. J., Hawkins, G. E., Heathcote, A., Kellen, D.,
Krypotos, A.-M., Lerche, V., Logan, G. D., Palmeri, T. J., van Ravenzwaaij, D.,
Servant, M., Singmann, H., Starns, J. J., Voss, A., Wiecki, T. V., Matzke, D., &
Wagenmakers, E.-J. (2018). Estimating across-trial variability parameters of the
Diﬀusion Decision Model: Expert advice and recommendations. Journal of
Mathematical Psychology, 87(4), 46–75. https://doi.org/10.1016/j.jmp.2018.09.004 

Henrich, F., Hartmann, R., Pratz, V., Voss, A., & Klauer, K. C. (2023). The
Seven-parameter Diffusion Model: An Implementation in Stan for Bayesian
Analyses. Behavior Research Methods. https://doi.org/10.3758/s13428-023-02179-1
