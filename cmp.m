clc; clear; close all;


hw_lines = readlines('C:/Xilinx/Lab/Final_Project/final_test/final_test.sim/sim_1/behav/xsim/output.hex');
hw_lines = erase(hw_lines, '"');
hw_lines = strtrim(hw_lines);
hw_lines = hw_lines(hw_lines ~= "");
hw = hex2dec(hw_lines);

sw_lines = readlines('C:/Python/hardware_layernorm_expected_128.mem');
sw_lines = strtrim(sw_lines);
sw_lines = sw_lines(sw_lines ~= "");
sw = hex2dec(sw_lines);



% CHECK LENGTH
if length(hw) ~= length(sw)
    error('HW_even và SW không cùng số mẫu!');
end

% TÍNH % ERROR
epsilon = 1e-12;
percent_error = abs(hw - sw) ./ (abs(sw) + epsilon) * 100;


% THỐNG KÊ
max_error  = max(percent_error);
mean_error = mean(percent_error);
std_error  = std(percent_error);

fprintf('\n===== ERROR SUMMARY =====\n');
fprintf('Mean error = %.4f %%\n', mean_error);

% PHÂN BỐ ERROR
cnt_1  = sum(percent_error < 1);
cnt_2  = sum(percent_error >= 1  & percent_error < 2);
cnt_3  = sum(percent_error >= 2  & percent_error < 3);
cnt_4  = sum(percent_error >= 3  & percent_error < 4);
cnt_5  = sum(percent_error >= 4);

N = length(percent_error);

fprintf('\n===== ERROR DISTRIBUTION =====\n');
fprintf('< 1%%   : %d mẫu (%.2f%%)\n', cnt_1, cnt_1/N*100);
fprintf('1–2%%   : %d mẫu (%.2f%%)\n', cnt_2, cnt_2/N*100);
fprintf('2–3%%   : %d mẫu (%.2f%%)\n', cnt_3, cnt_3/N*100);
fprintf('3–4%%   : %d mẫu (%.2f%%)\n', cnt_4, cnt_4/N*100);
fprintf('> 4%%   : %d mẫu (%.2f%%)\n', cnt_5, cnt_5/N*100);

% HIỂN THỊ 10 GIÁ TRỊ CUỐI (DẠNG Q6.26)
scaling_factor = 2^26;

% Chuyển đổi sang giá trị thực (Double) để tính toán chính xác
hw_real = double(hw) / scaling_factor;
sw_real = double(sw) / scaling_factor;

% Tính lại sai số dựa trên giá trị thực
percent_error_real = abs(hw_real - sw_real) ./ (abs(sw_real) + 1e-12) * 100;

fprintf('\n===== LAST 10 SAMPLES (FORMAT Q6.26) =====\n');
fprintf('%-5s | %-10s | %-10s | %-10s | %-10s | %-8s\n', ...
        'No', 'HW Hex', 'SW Hex', 'HW (Real)', 'SW (Real)', 'Error(%)');
fprintf('--------------------------------------------------------------------------\n');

for i = length(sw)-9 : length(sw)
    % Lấy lại mã Hex ban đầu để hiển thị
    hw_hex_str = dec2hex(hw(i), 8);
    sw_hex_str = dec2hex(sw(i), 8);
    
    fprintf('%-5d | %-10s | %-10s | %-10.6f | %-10.6f | %-8.4f%%\n', ...
            i, hw_hex_str, sw_hex_str, hw_real(i), sw_real(i), percent_error_real(i));
end

% PLOT ERROR
figure;
plot(percent_error, 'LineWidth', 1.5);
grid on;
title('Percent Error (HW vs SW)');
xlabel('Sample Index');
ylabel('Error (%)');

% HISTOGRAM
figure;
histogram(percent_error, 50);
grid on;
title('Error Distribution');
xlabel('Error (%)');
ylabel('Count');

% PLOT HW vs SW
figure;
plot(hw, 'b'); hold on;
plot(sw, 'r--');
grid on;
legend('HW (even samples)', 'Software');
title('HW vs Software');
xlabel('Sample Index');
ylabel('Value');