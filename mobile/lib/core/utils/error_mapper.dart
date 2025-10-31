class ErrorMapper {
  static String toVietnamese(String message) {
    if (message.isEmpty) return 'Đã xảy ra lỗi không xác định.';

    final lower = message.toLowerCase();

    // 🔐 Xác thực
    if (lower.contains('invalid credentials')) return 'Tên đăng nhập hoặc mật khẩu không đúng.';
    if (lower.contains('username already exists')) return 'Tên tài khoản đã tồn tại. Vui lòng chọn tên khác.';
    if (lower.contains('user not found')) return 'Không tìm thấy tài khoản này.';
    if (lower.contains('account disabled')) return 'Tài khoản của bạn đã bị khóa hoặc chưa được kích hoạt.';
    if (lower.contains('access denied')) return 'Bạn không có quyền truy cập chức năng này.';
    if (lower.contains('unauthorized')) return 'Bạn cần đăng nhập để tiếp tục.';
    if (lower.contains('token expired')) return 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.';
    if (lower.contains('invalid token')) return 'Mã xác thực không hợp lệ, vui lòng đăng nhập lại.';

    // 📦 Dữ liệu & nghiệp vụ
    if (lower.contains('resource not found')) return 'Không tìm thấy dữ liệu yêu cầu.';
    if (lower.contains('record not found')) return 'Không tìm thấy bản ghi tương ứng.';
    if (lower.contains('duplicate')) return 'Dữ liệu đã tồn tại trong hệ thống.';
    if (lower.contains('invalid request')) return 'Yêu cầu không hợp lệ, vui lòng kiểm tra lại thông tin.';
    if (lower.contains('missing required field')) return 'Thiếu thông tin bắt buộc, vui lòng điền đầy đủ.';
    if (lower.contains('invalid field value')) return 'Giá trị nhập không hợp lệ.';
    if (lower.contains('operation not allowed')) return 'Hành động này không được phép.';
    if (lower.contains('cannot delete')) return 'Không thể xóa vì dữ liệu đang được sử dụng.';
    if (lower.contains('course not found')) return 'Không tìm thấy khóa học.';
    if (lower.contains('exam not found')) return 'Không tìm thấy bài thi.';
    if (lower.contains('assignment not found')) return 'Không tìm thấy bài được giao.';

    // ⚙️ Hệ thống
    if (lower.contains('internal server error')) return 'Lỗi hệ thống, vui lòng thử lại sau.';
    if (lower.contains('database error')) return 'Lỗi cơ sở dữ liệu. Vui lòng liên hệ quản trị viên.';
    if (lower.contains('connection refused')) return 'Không thể kết nối đến máy chủ.';
    if (lower.contains('service unavailable')) return 'Dịch vụ tạm thời không khả dụng.';
    if (lower.contains('timeout')) return 'Kết nối quá hạn. Vui lòng thử lại sau.';
    if (lower.contains('unexpected error')) return 'Đã xảy ra lỗi không xác định.';

    // Mặc định
    return 'Lỗi: $message';
  }
}
