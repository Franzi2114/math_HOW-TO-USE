functions {
  real partial_sum_fullddm(array[] real rt_slice, int start, int end,
    real a, real t0_m, real t0_s, real zr_m, real zr_s, array[] real v_m, real v_s,
    array[] int resp, array[] int cnd, real precision) {
      real ans = 0;
      for (i in start:end) {
        if (resp[i] == 1) {
          // upper threshold
          ans += wiener_full_prec_lpdf(rt_slice[i+1-start] | a, v_m[cnd[i]], zr_m, t0_m, v_s,  zr_s, t0_s, precision);
        } else {
          // lower threshold (mirror drift and starting point!)
          ans += wiener_full_prec_lpdf(rt_slice[i+1-start] | a, -v_m[cnd[i]], 1 - zr_m, t0_m, v_s,  zr_s, t0_s, precision);
        }
      }
      return ans;
    }
}

data {
  int<lower=0> N;                     // No trials
  int<lower=1> Ncnds;                 // No conditions
  array[N] real rt;                       // response times (seconds)
  array[N] int<lower=1, upper=Ncnds> cnd;       // stimulus type/condition
  array[N] int<lower=0, upper=1> resp;      // responses (0,1)
  real precision;
  int parallel;
}

parameters {
  real<lower=0> a;                    // threshold separation (a>0)
  real<lower=0.001, upper=0.999> zr_m;        // mean starting point (0<zr<1)
  real<lower=0, upper=min([1-zr_m, zr_m])> zr_s;  // sd of starting point (zr_s>0)

  array[Ncnds] real v_m;                        // mean drift for Ncnds stimulus types
  real<lower=0> v_s;                  // sd of drift

  real<lower=0> t0_s;     // sd of non-decision-time
  real<lower=t0_s / 2, upper=min(rt) + t0_s / 2> t0_m;                 // mean non-decision-time
}

model {
  a ~ gamma(2, 1);
  zr_m ~ beta(3, 3);
  zr_s ~ beta(1, 3);
  v_m ~ normal(0, 5);
  v_s ~ normal(0, 3) T[0,];

  t0_m ~ gamma(3, 6);
  t0_s ~ normal(0, 3) T[0,];
  
  if (parallel) {
    target += reduce_sum(partial_sum_fullddm, rt, 1,
      a, t0_m, t0_s, zr_m, zr_s, v_m, v_s, resp, cnd,
      precision);
  } else {
    for (i in 1:N) {
      if (resp[i] == 1) {
        // upper threshold
        target += wiener_full_prec_lpdf(rt[i] | a, v_m[cnd[i]], zr_m, t0_m, v_s,  zr_s, t0_s, precision);
      } else {
        // lower threshold (mirror drift and starting point!)
        target += wiener_full_prec_lpdf(rt[i] | a, -v_m[cnd[i]], 1-zr_m, t0_m, v_s,  zr_s, t0_s, precision);
      }
    }
  }
}
