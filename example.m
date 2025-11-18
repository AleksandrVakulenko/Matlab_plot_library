
freq = 10.^linspace(log10(0.01), log10(10000), 30);


amp = 1./freq;


plot3(freq, freq, amp);
% plot(freq, amp);

% set(gca, 'xscale', 'log')
% set(gca, 'yscale', 'log')
% log_scale_ticks("SI")

log_scale("auto", "xyz")





