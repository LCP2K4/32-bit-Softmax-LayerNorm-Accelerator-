import torch
import torch.nn as nn

# Hàm chuyển đổi Float Tensor sang danh sách Hex 32-bit (Q6.26)
def tensor_to_32bit_hex(tensor):
    scaled = torch.round(tensor * (2**26))
    int_vals = scaled.to(torch.int64).flatten()
    hex_list = []
    for val in int_vals:
        data_32bit = val.item() & 0xFFFFFFFF
        hex_str = f"{data_32bit:08X}"
        hex_list.append(hex_str)
    return hex_list

def write_mem_file(filename, hex_list):
    with open(filename, 'w') as f:
        for hex_val in hex_list:
            f.write(hex_val + '\n')
    print(f"Đã lưu thành công: {filename} ({len(hex_list)} dòng)")

# HÀM CHUẨN HÓA VỀ [-4, 4]
def scale_to_range(tensor, min_val=-4.0, max_val=4.0):
    t_min = tensor.min()
    t_max = tensor.max()
    # Tránh chia cho 0 nếu tất cả phần tử bằng nhau
    if t_max == t_min:
        return torch.full_like(tensor, (min_val + max_val) / 2.0)
    
    # Đưa về [0, 1] rồi scale sang [min_val, max_val]
    normalized = (tensor - t_min) / (t_max - t_min)
    scaled = min_val + (max_val - min_val) * normalized
    return scaled


# Khởi tạo dữ liệu ngẫu nhiên phối Gauss (randn)
raw_input = torch.randn(128, 128)

# Thực hiện ép dải dữ liệu về đúng [-4, 4]
input_tensor = scale_to_range(raw_input, min_val=-4.0, max_val=4.0)

# Kiểm tra lại biên độ
print(f"Min hiện tại: {input_tensor.min().item():.4f}")
print(f"Max hiện tại: {input_tensor.max().item():.4f}")

layer_norm = nn.LayerNorm(128)
softmax = nn.Softmax(dim=-1)

# Chạy tính toán giả lập PyTorch từ input đã chuẩn hóa
ln_output = layer_norm(input_tensor)
sm_output = softmax(input_tensor)

# Chuyển đổi toàn bộ sang 32-bit Hex
hex_input = tensor_to_32bit_hex(input_tensor)
hex_ln_out = tensor_to_32bit_hex(ln_output)
hex_sm_out = tensor_to_32bit_hex(sm_output)

# Ghi ra các file cấu hình .mem
write_mem_file("hardware_input_128.mem", hex_input)
write_mem_file("hardware_layernorm_expected_128.mem", hex_ln_out)
write_mem_file("hardware_softmax_expected_128.mem", hex_sm_out)