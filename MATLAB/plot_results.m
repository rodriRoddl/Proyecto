% Function to generate plots to show the summaries

function [] = plot_results(Lambda,polling_cycles,avg_pkt_delay_all,avg_pkt_trx_delay_all)
    close all;
    % ============================ figure 1 ============================
    figure; hold on; grid on; box on;
    plot(Lambda,polling_cycles,'-o','LineWidth',2);

    xlim([0 1]);
    ylim([0 inf]);
    xlabel('Effective network load $(\rho)$','FontWeight','bold','FontSize',12,'Interpreter','latex');
    ylabel('Number of polling cycles','FontWeight','bold','FontSize',12,'Interpreter','latex');
    legend({'Limited service'},'FontWeight','bold','Location','northeast','Interpreter','latex');
    hold off;

    % ============================ figure 2 ============================
    figure;
    semilogy(Lambda,avg_pkt_delay_all,'-o','LineWidth',2);
    grid on; box on;

    xlim([0 1]);
    ylim([1e-4 1e-1]);
    xlabel('Effective network load $(\rho)$','FontWeight','bold','FontSize',12,'Interpreter','latex');
    ylabel('Average packet latency at ONU (sec)','FontWeight','bold','FontSize',12,'Interpreter','latex');
    legend({'Limited service'},'FontWeight','bold','Location','northeast','Interpreter','latex');

    % ============================ figure 3 ============================
    figure;
    semilogy(Lambda,avg_pkt_trx_delay_all,'-o','LineWidth',2);
    grid on; box on;

    xlim([0 1]);
    ylim([1e-4 1e-1]);
    xlabel('Effective network load $(\rho)$','FontWeight','bold','FontSize',12,'Interpreter','latex');
    ylabel('Average end-to-end packet latency (sec)','FontWeight','bold','FontSize',12,'Interpreter','latex');
    legend({'Limited service'},'FontWeight','bold','Location','northeast','Interpreter','latex');
end
