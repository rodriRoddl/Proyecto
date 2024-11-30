import numpy as np
import matplotlib.pyplot as plt

def plot_results(Lambda, polling_cycles, avg_pkt_delay_all, avg_pkt_trx_delay_all):
    # ============================ figure 1 ============================
    plt.figure()
    plt.plot(Lambda, polling_cycles, '-o', linewidth=2)
    plt.grid(True)
    plt.box(True)
    plt.xlim([0, 1])
    plt.ylim([0, np.inf])
    plt.xlabel('Effective network load $(\\rho)$', fontweight='bold', fontsize=12)
    plt.ylabel('Number of polling cycles', fontweight='bold', fontsize=12)
    plt.legend(['Limited service'], loc='northeast', fontsize=10)
    plt.title('Polling Cycles vs Effective Load')
    plt.show()

    # ============================ figure 2 ============================
    plt.figure()
    plt.semilogy(Lambda, avg_pkt_delay_all, '-o', linewidth=2)
    plt.grid(True)
    plt.box(True)
    plt.xlim([0, 1])
    plt.ylim([1e-4, 1e-1])
    plt.xlabel('Effective network load $(\\rho)$', fontweight='bold', fontsize=12)
    plt.ylabel('Average packet latency at ONU (sec)', fontweight='bold', fontsize=12)
    plt.legend(['Limited service'], loc='northeast', fontsize=10)
    plt.title('Average Packet Latency vs Effective Load')
    plt.show()

    # ============================ figure 3 ============================
    plt.figure()
    plt.semilogy(Lambda, avg_pkt_trx_delay_all, '-o', linewidth=2)
    plt.grid(True)
    plt.box(True)
    plt.xlim([0, 1])
    plt.ylim([1e-4, 1e-1])
    plt.xlabel('Effective network load $(\\rho)$', fontweight='bold', fontsize=12)
    plt.ylabel('Average end-to-end packet latency (sec)', fontweight='bold', fontsize=12)
    plt.legend(['Limited service'], loc='northeast', fontsize=10)
    plt.title('End-to-End Packet Latency vs Effective Load')
    plt.show()
