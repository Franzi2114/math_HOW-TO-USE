Here are some information on how to get started with the new function for the 7-parameter drift diffusion model.

You can use the function with cmdstanr/cmdstanpy if you unzip the folder cmdstan-ddm-7pm.zip and set the path to it in cmdstanr/cmdstanpy.

For an instruction how to install cmdstan-ddm-7pm see below.

The code can be found here: git@github.com:Franzi2114/math.git

The stan/math Pull Request is still in progress and can be found here: https://github.com/stan-dev/math/pull/2822

Please feel free to use the function for your purposes and report any bugs or ask questions to the authors:

Franziska Henrich (franziska.henrich@psychologie.uni-freiburg.de) and Valentin Pratz (pratz@stud.uni-heidelberg.de)


## Installation
You need to follow these steps: 

1) Download the cmdstan-ddm-7pm.zip folder from here [1] and unpack everything.

### Windows
- W2) Install all required dependencies [2], Chapter 1.2.1.3. You need RTools42, which consists of g++ and mingw32-make.
- W3) Add the following two lines to cmdstan-ddm-7pm/make/local (to use RTools42 with cmdstan). Type in the command line/a terminal:  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ cd cmdstan-ddm-7pm  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ vim make/local  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;press i (for insert), type the following two lines:  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	CXXFLAGS += -Wno-nonnull  
 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	TBB_CXXFLAGS= -U__MSVCRT_VERSION__ -D__MSVCRT_VERSION__=0x0E00  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;press Esc, and :x Enter (to save and exit)  
- W4) build cmdstan in the cmdstan-ddm-7pm folder:  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ mingw32-make build
- W5) Add the path to tbb to your PATH-variable by typing  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ mingw32-make install-tbb
- W6) Close the shell and use a new shell to test installation (you may restart your PC)  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;create .exe: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			$ mingw32-make examples/bernoulli/bernoulli.exe  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;test whether this worked:	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ ./examples/bernoulli/bernoulli.exe sample data file=examples/bernoulli/bernoulli.data.json  
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;summarize parameter estimates:	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ bin/stansummary.exe output.csv  



### Linux  
- L2) Install all required dependencies [2]. Then type  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ cd cmdstan-ddm-7pm  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ make build  
- L3) To test whether everything works, create a .stan model file in cmdstan/stan/lib/stan_math/models (or use the example models provided in the folder) 
   and compile the model (!!without .stan-extension!!, see [4]):  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ cd cmdstan-ddm-7pm  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ make stan/lib/stan_math/models/wiener_full_lpdf  
- L4a) To open the documentation install doxygen [3]. Then make the documentation:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ cd cmdstan-ddm-7pm/stan/lib/stan_math  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ make doxygen  
- L4b) A new folder in stan_math will be created. Double click on: doc/api/html/index.html.  
    Then a webpage opens. On the left handside, navigate to "Internal Docs". Click on "Probability Distributions".  
    Then, on the right hand side, the content of "Probability Distributions" opens. Scroll down to "wiener_full_lpdf".



### Mac
- M2) Follow the instructions on [2].



## Example R-Code for cmdstanr.

data.rds of the form: condition|resonse|reaction_time

	library(cmdstanr)
	library(readr)
	set_cmdstan_path("path/to/cmdstan-ddm-7pm-folder")
	file <- file.path("stan/wiener_full_lpdf.stan")
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

[1] https://github.com/Franzi2114/math_HOW-TO-USE  
[2] https://mc-stan.org/docs/2_29/cmdstan-guide/cmdstan-installation.html  
[3] https://doxygen.nl/manual/install.html  
[4] https://github.com/stan-dev/cmdstan/wiki/Getting-Started-with-CmdStan
