Here are some information on how to get started with the new function for the 7-parameter drift diffusion model.

You can use the function with cmdstanr/cmdstanpy if you unpack the folder cmdstan-ddm-7pm.zip (3 times) and set the path to it in cmdstanr/cmdstanpy.

For a detailed instruction how to install cmdstan-ddm-7pm see below.

The code can be found here: [https://github.com/Franzi2114/math/tree/feature/issue-2682-Add-7-parameter-DDM-PDF](https://github.com/Franzi2114/math/tree/feature/issue-2682-Add-7-parameter-DDM-PDF)

The stan/math Pull Request is still in progress and can be found here: https://github.com/stan-dev/math/pull/2822

Please feel free to use the function for your purposes and report any bugs or ask questions to the authors:

Franziska Henrich (franziska.henrich@psychologie.uni-freiburg.de) and Valentin Pratz (pratz@stud.uni-heidelberg.de)

## Illustration of the function's behavior
Valentin followed the three-level setup by Boehem et al. (2018) and provides a hands-on illustration of the function's behavior in three blog entries:  
[Level 1](https://valentinpratz.de/posts/2022-12-29-stan-wiener_full-level-1/)  
[Level 2](https://valentinpratz.de/posts/2022-12-30-stan-wiener_full-level-2/)  
[Level 3](https://valentinpratz.de/posts/2023-01-11-stan-wiener_full-level-3/)


## Installation

1) Download the cmdstan-ddm-7pm.zip folder from here [1] and unpack everything. (For example with 7-Zip [2]) You need to unpack 3 times, until a folder with 17 elements is seen.

### Windows
- W2) Install all required dependencies [3, Chapter 1.2.1.3]. You need RTools42, which consists of `g++` and `mingw32-make`. You may install `mingw32-make` separately [6].
- W3) Go to cmdstan-ddm-7pm/bin and rename `windows-stanc` to `stanc.exe`
- W4) You are ready to start. In your file, set the path to the cmdstan-ddm-7pm folder: `set_cmdstan_path(path/to/cmdstan-ddm-7pm)` (insert the path in the brackets)

#### Alternative for a manual installation
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
- L2) Install all required dependencies [3, Chapter 1.2.1.1]. You need `g++` and `make`
- L3) Go to cmdstan-ddm-7pm/bin and rename `linux-stanc` to `stanc`
- L4) You are ready to start. In your file, set the path to the cmdstan-ddm-7pm folder: `set_cmdstan_path(path/to/cmdstan-ddm-7pm)` (insert the path in the brackets)

#### Alternative for a manual installation
- L3) Then type  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ cd cmdstan-ddm-7pm  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ make build  
- L4) To test whether everything works, create a .stan model file in cmdstan/stan/lib/stan_math/models (or use the example models provided in the folder) 
   and compile the model (!!without .stan-extension!!, see [4]):  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ cd cmdstan-ddm-7pm  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ make stan/lib/stan_math/models/wiener_full_lpdf  
- L5a) To open the documentation install doxygen [5]. Then make the documentation:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ cd cmdstan-ddm-7pm/stan/lib/stan_math  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	$ make doxygen  
- L5b) A new folder in stan_math will be created. Double click on: doc/api/html/index.html.  
    Then a webpage opens. On the left handside, navigate to "Internal Docs". Click on "Probability Distributions".  
    Then, on the right hand side, the content of "Probability Distributions" opens. Scroll down to "wiener_full_lpdf".



### Mac
- M2) Install all required dependencies [3, Chapter 1.2.1.2]. You need `clang++`and `make`.
- M3) Go to cmdstan-ddm-7pm/bin and rename `mac-stanc` to `stanc` (with the file extension for the mac executables, not sure if it's just `stanc`)
- M4) You are ready to start. In your file, set the path to the cmdstan-ddm-7pm folder: `set_cmdstan_path(path/to/cmdstan-ddm-7pm)` (insert the path in the brackets)




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
[2] https://7-zip.de/download.html  
[3] https://mc-stan.org/docs/2_29/cmdstan-guide/cmdstan-installation.html   
[4] https://github.com/stan-dev/cmdstan/wiki/Getting-Started-with-CmdStan  
[5] https://doxygen.nl/manual/install.html   
[6] https://www.geeksforgeeks.org/installing-mingw-tools-for-c-c-and-changing-environment-variable/

## References
Boehm, U., Annis, J., Frank, M. J., Hawkins, G. E., Heathcote, A., Kellen, D.,
Krypotos, A.-M., Lerche, V., Logan, G. D., Palmeri, T. J., van Ravenzwaaij, D.,
Servant, M., Singmann, H., Starns, J. J., Voss, A., Wiecki, T. V., Matzke, D., &
Wagenmakers, E.-J. (2018). Estimating across-trial variability parameters of the
Diﬀusion Decision Model: Expert advice and recommendations. Journal of
Mathematical Psychology, 87(4), 46–75. https://doi.org/10.1016/j.jmp.2018.09.004 
