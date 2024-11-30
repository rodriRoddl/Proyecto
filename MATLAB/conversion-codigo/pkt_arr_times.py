import numpy as np
import matplotlib.pyplot as plt

def pkt_arr_times(type, par1, par2=None, max_pkts=None):
    if type == 'deterministic':
        avg_arr_time = par1
        pkt_arr_time = avg_arr_time * np.ones(max_pkts)

    elif type == 'exponential':
        avg_arr_time = par1
        pkt_arr_time = np.random.exponential(avg_arr_time, max_pkts)

    elif type == 'uniform':
        min_arr_time = par1
        max_arr_time = par2
        pkt_arr_time = min_arr_time + (max_arr_time - min_arr_time) * np.random.rand(max_pkts)

    elif type == 'GP':  # Generalized Pareto distribution
        k = par1
        sigma = par2
        theta = 0  # minimum value for time is 0
        pkt_arr_time = np.random.default_rng().pareto(k, max_pkts) * sigma + theta

    elif type == 'gamma':
        a = par1
        b = par2
        pkt_arr_time = np.random.gamma(a, b, max_pkts)

    elif type == 'Gaussian':
        mean = par1
        variance = par2
        pkt_arr_time = mean + variance * np.abs(np.random.randn(max_pkts))

    else:
        raise ValueError("Unsupported distribution type")

    return pkt_arr_time
