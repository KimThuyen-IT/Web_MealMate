<?php
// admin/contact-messages.php
require_once __DIR__ . '/../includes/admin-check.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/functions.php';

$database = new Database();
$conn = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'bulk_delete') {
    if (!verify_csrf_token($_POST['csrf_token'] ?? '')) {
        $_SESSION['error'] = 'Yêu cầu không hợp lệ.';
    } else {
        $selectedIds = $_POST['message_ids'] ?? [];
        $cleanIds = [];
        if (is_array($selectedIds)) {
            foreach ($selectedIds as $selectedId) {
                $id = filter_var($selectedId, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
                if ($id !== false) {
                    $cleanIds[] = (int)$id;
                }
            }
        }
        $cleanIds = array_values(array_unique($cleanIds));

        if (!$cleanIds) {
            $_SESSION['error'] = 'Chọn ít nhất một tin nhắn để xóa.';
        } else {
            try {
                $conn->beginTransaction();
                $deleteMessage = $conn->prepare('DELETE FROM contact_messages WHERE id = :id');
                $deleteNotifications = $conn->prepare('DELETE FROM notifications WHERE message LIKE :pattern');
                $deletedCount = 0;
                foreach ($cleanIds as $id) {
                    $deleteNotifications->execute([':pattern' => '%[MID:' . $id . ']%']);
                    $deleteMessage->execute([':id' => $id]);
                    $deletedCount += $deleteMessage->rowCount();
                }
                $conn->commit();
                $_SESSION['success'] = "Đã xóa {$deletedCount} tin nhắn liên hệ.";
            } catch (Throwable $e) {
                if ($conn->inTransaction()) {
                    $conn->rollBack();
                }
                error_log('Không thể xóa hàng loạt tin nhắn liên hệ: ' . $e->getMessage());
                $_SESSION['error'] = 'Không thể xóa các tin nhắn đã chọn. Vui lòng thử lại.';
            }
        }
    }
    redirect('/admin/contact-messages.php');
}

// Xử lý cập nhật trạng thái hoặc xóa
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    if (!verify_csrf_token($_POST['csrf_token'] ?? '')) {
        die('Lỗi CSRF token');
    }
    
    $id = (int)$_POST['id'];
    
    if ($_POST['action'] === 'delete') {
        $stmt = $conn->prepare("DELETE FROM contact_messages WHERE id = :id");
        $stmt->execute([':id' => $id]);
        try {
            $conn->prepare("DELETE FROM notifications WHERE message LIKE :pat")->execute([':pat' => '%[MID:' . $id . ']%']);
        } catch (Exception $e) {}
        $_SESSION['success'] = 'Đã xóa tin nhắn liên hệ.';
    } elseif ($_POST['action'] === 'update_status') {
        $status = $_POST['status'];
        if (in_array($status, ['new', 'read', 'replied'])) {
            $stmt = $conn->prepare("UPDATE contact_messages SET status = :status WHERE id = :id");
            $stmt->execute([':status' => $status, ':id' => $id]);
            if ($status !== 'new' && isset($_SESSION['user_id'])) {
                try {
                    $conn->prepare("UPDATE notifications SET is_read = 1 WHERE user_id = :uid AND message LIKE :pat")
                         ->execute([':uid' => (int)$_SESSION['user_id'], ':pat' => '%[MID:' . $id . ']%']);
                } catch (Exception $e) {}
            }
            $_SESSION['success'] = 'Đã cập nhật trạng thái tin nhắn.';
        }
    }
    redirect('/admin/contact-messages.php');
}

// Lấy danh sách tin nhắn theo trang
$page = max(1, (int)($_GET['page'] ?? 1));
$limit = 10;
$searchFilter = isset($_GET['search']) && is_string($_GET['search']) ? trim($_GET['search']) : '';
$statusFilter = isset($_GET['status']) && is_string($_GET['status']) && in_array($_GET['status'], ['new', 'read', 'replied'], true)
    ? $_GET['status']
    : '';
$searchConditions = [];
$searchParams = [];
if ($searchFilter !== '') {
    $searchConditions[] = "(CAST(id AS CHAR) LIKE :search_id
        OR full_name LIKE :search_name
        OR email LIKE :search_email
        OR subject LIKE :search_subject
        OR message LIKE :search_message)";
    $searchPattern = '%' . $searchFilter . '%';
    $searchParams = [
        ':search_id' => $searchPattern,
        ':search_name' => $searchPattern,
        ':search_email' => $searchPattern,
        ':search_subject' => $searchPattern,
        ':search_message' => $searchPattern
    ];
}
if ($statusFilter !== '') {
    $searchConditions[] = 'status = :status';
    $searchParams[':status'] = $statusFilter;
}
$searchWhere = $searchConditions ? 'WHERE ' . implode(' AND ', $searchConditions) : '';
$offset = ($page - 1) * $limit;

$countStmt = $conn->prepare("SELECT COUNT(*) FROM contact_messages {$searchWhere}");
$countStmt->execute($searchParams);
$total_messages = (int)$countStmt->fetchColumn();
$total_pages = $total_messages > 0 ? (int)ceil($total_messages / $limit) : 1;

if ($page > $total_pages) {
    $page = $total_pages;
    $offset = ($page - 1) * $limit;
}

$query = "SELECT * FROM contact_messages {$searchWhere} ORDER BY created_at DESC LIMIT :limit OFFSET :offset";
$stmt = $conn->prepare($query);
foreach ($searchParams as $name => $value) {
    $stmt->bindValue($name, $value, PDO::PARAM_STR);
}
$stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
$stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
$stmt->execute();
$messages = $stmt->fetchAll(PDO::FETCH_ASSOC);
$paginationParams = [];
if ($searchFilter !== '') {
    $paginationParams['search'] = $searchFilter;
}
if ($statusFilter !== '') {
    $paginationParams['status'] = $statusFilter;
}

$page_title = 'Quản lý Liên hệ';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-md-2">
            <?php require __DIR__ . '/includes/sidebar.php'; ?>
        </div>
        <div class="col-md-10">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
                <h3 class="fw-bold mb-0">Hộp thư Liên hệ</h3>
                <button type="submit" form="bulkContactDeleteForm" class="btn btn-sm btn-outline-danger rounded-pill px-3 text-nowrap" disabled>
                    <i class="bi bi-trash me-1"></i>Xóa đã chọn (<span data-bulk-count>0</span>)
                </button>
            </div>

            <?php if (isset($_SESSION['success'])): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <?php echo $_SESSION['success']; unset($_SESSION['success']); ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <?php endif; ?>
            <?php if (isset($_SESSION['error'])): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <?php echo htmlspecialchars($_SESSION['error'], ENT_QUOTES, 'UTF-8'); unset($_SESSION['error']); ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <?php endif; ?>

            <form method="POST" id="bulkContactDeleteForm" data-bulk-delete="contact-messages">
                <input type="hidden" name="csrf_token" value="<?php echo generate_csrf_token(); ?>">
                <input type="hidden" name="action" value="bulk_delete">
            </form>

            <form method="GET" action="<?php echo BASE_URL; ?>/admin/contact-messages.php" class="card glass-card border-0 rounded-4 shadow-sm mb-4" data-live-search="reload">
                <div class="card-body">
                    <div class="row g-3 align-items-end">
                        <div class="col-12 col-lg-6">
                            <label for="filter_contact_search" class="form-label small fw-semibold">Tìm kiếm tin nhắn</label>
                            <input type="search" class="form-control" id="filter_contact_search" name="search" value="<?php echo htmlspecialchars($searchFilter, ENT_QUOTES, 'UTF-8'); ?>" placeholder="Nhập ID, người gửi, email, chủ đề hoặc nội dung">
                        </div>
                        <div class="col-12 col-lg-3">
                            <label for="filter_contact_status" class="form-label small fw-semibold">Trạng thái</label>
                            <select class="form-select" id="filter_contact_status" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="new" <?php echo $statusFilter === 'new' ? 'selected' : ''; ?>>Chưa đọc</option>
                                <option value="read" <?php echo $statusFilter === 'read' ? 'selected' : ''; ?>>Đã đọc</option>
                                <option value="replied" <?php echo $statusFilter === 'replied' ? 'selected' : ''; ?>>Đã xử lý</option>
                            </select>
                        </div>
                        <div class="col-12 col-lg-3 d-flex justify-content-end gap-2">
                            <a href="<?php echo BASE_URL; ?>/admin/contact-messages.php" class="btn btn-outline-secondary rounded-pill px-3">Xóa lọc</a>
                            <button type="submit" class="btn btn-success rounded-pill px-4">
                                <i class="bi bi-search me-1"></i>Tìm kiếm
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <div class="card glass-card border-0 rounded-4 shadow-sm overflow-hidden mb-4">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead style="background: rgba(243, 244, 246, 0.7);">
                                <tr>
                                    <th><input type="checkbox" class="form-check-input" data-bulk-select-all="contact-messages" aria-label="Chọn tất cả tin nhắn"></th>
                                    <th>Thời gian</th>
                                    <th>Người gửi</th>
                                    <th>Email</th>
                                    <th>Chủ đề</th>
                                    <th>Trạng thái</th>
                                    <th class="text-end">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($messages as $msg): ?>
                                <tr id="contact-row-<?php echo $msg['id']; ?>" class="<?php echo $msg['status'] === 'new' ? 'table-warning' : ''; ?>">
                                    <td><input type="checkbox" class="form-check-input" name="message_ids[]" value="<?php echo (int)$msg['id']; ?>" form="bulkContactDeleteForm" data-bulk-select="contact-messages" aria-label="Chọn tin nhắn #<?php echo (int)$msg['id']; ?>"></td>
                                    <td><?php echo date('d/m/Y H:i', strtotime($msg['created_at'])); ?></td>
                                    <td class="fw-bold"><?php echo htmlspecialchars($msg['full_name']); ?></td>
                                    <td><a href="mailto:<?php echo htmlspecialchars($msg['email']); ?>"><?php echo htmlspecialchars($msg['email']); ?></a></td>
                                    <td><?php echo htmlspecialchars($msg['subject']); ?></td>
                                    <td id="status-col-<?php echo $msg['id']; ?>">
                                        <?php if ($msg['status'] === 'new'): ?>
                                            <span id="status-badge-<?php echo $msg['id']; ?>" class="badge bg-danger">Chưa đọc</span>
                                        <?php elseif ($msg['status'] === 'read'): ?>
                                            <span id="status-badge-<?php echo $msg['id']; ?>" class="badge bg-primary">Đã đọc</span>
                                        <?php else: ?>
                                            <span id="status-badge-<?php echo $msg['id']; ?>" class="badge bg-success">Đã xử lý</span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-sm btn-outline-info rounded-pill me-1" title="Xem chi tiết" onclick='openContactModal(<?php echo htmlspecialchars(json_encode($msg, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE), ENT_QUOTES, "UTF-8"); ?>)'>
                                            <i class="bi bi-eye"></i> Xem
                                        </button>
                                        <form method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa tin nhắn này?');">
                                            <input type="hidden" name="csrf_token" value="<?php echo generate_csrf_token(); ?>">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<?php echo $msg['id']; ?>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php if (empty($messages)): ?>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted"><?php echo $searchFilter !== '' || $statusFilter !== '' ? 'Không tìm thấy tin nhắn phù hợp.' : 'Không có tin nhắn liên hệ nào.'; ?></td>
                                </tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <?php if ($total_pages > 1): ?>
                <nav aria-label="Phân trang hộp thư liên hệ" class="mt-3">
                    <?php echo render_pagination_links($page, $total_pages, $paginationParams); ?>
                </nav>
            <?php endif; ?>
        </div>
    </div>
</div>

<!-- Modal Xem Chi Tiết & Xử Lý Tin Nhắn Liên Hệ (In-Page) -->
<div class="modal fade" id="contactMsgModal" tabindex="-1" aria-labelledby="contactMsgModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <form method="POST">
                <input type="hidden" name="csrf_token" value="<?php echo generate_csrf_token(); ?>">
                <input type="hidden" name="action" value="update_status">
                <input type="hidden" name="id" id="msg_modal_id" value="0">

                <div class="modal-header border-0 bg-health text-white p-4 d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-envelope-open-fill fs-5"></i>
                        <h5 class="modal-title fw-bold mb-0" id="contactMsgModalLabel">Chi Tiết Tin Nhắn Liên Hệ</h5>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold mb-1">Người gửi:</label>
                            <div class="fw-bold fs-6" id="msg_modal_name"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold mb-1">Email:</label>
                            <div><a href="#" id="msg_modal_email" class="text-decoration-none fw-bold"></a></div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold mb-1">Thời gian gửi:</label>
                            <div class="text-muted" id="msg_modal_time"></div>
                        </div>
                        <div class="col-md-6">
                            <label class="text-muted small fw-bold mb-1">Cập nhật trạng thái:</label>
                            <select class="form-select form-select-sm rounded-pill" name="status" id="msg_modal_status">
                                <option value="new">Chưa đọc</option>
                                <option value="read">Đã đọc</option>
                                <option value="replied">Đã xử lý / Đã trả lời</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="text-muted small fw-bold mb-1">Chủ đề:</label>
                        <div class="p-2 bg-light rounded-3 fw-bold text-success" id="msg_modal_subject"></div>
                    </div>

                    <div class="mb-2">
                        <label class="text-muted small fw-bold mb-1">Nội dung tin nhắn:</label>
                        <div class="p-3 bg-light rounded-3 border" id="msg_modal_content" style="white-space: pre-wrap; min-height: 120px; line-height: 1.6;"></div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-4 pt-0 justify-content-between">
                    <a href="#" id="msg_modal_reply_btn" class="btn btn-outline-success rounded-pill px-4">
                        <i class="bi bi-reply-fill me-1"></i>Phản hồi qua Email
                    </a>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold shadow-sm">
                            <i class="bi bi-check2-circle me-1"></i>Lưu trạng thái
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openContactModal(msg) {
    document.getElementById('msg_modal_id').value = msg.id;
    document.getElementById('msg_modal_name').textContent = msg.full_name || '';
    
    const emailEl = document.getElementById('msg_modal_email');
    emailEl.textContent = msg.email || '';
    emailEl.href = 'mailto:' + (msg.email || '');

    document.getElementById('msg_modal_time').textContent = msg.created_at || '';
    document.getElementById('msg_modal_status').value = msg.status || 'read';
    document.getElementById('msg_modal_subject').textContent = msg.subject || '(Không có chủ đề)';
    document.getElementById('msg_modal_content').textContent = msg.message || '';

    const replyBtn = document.getElementById('msg_modal_reply_btn');
    replyBtn.href = 'mailto:' + encodeURIComponent(msg.email || '') + '?subject=' + encodeURIComponent('Phản hồi: ' + (msg.subject || '')) + '&body=' + encodeURIComponent('\n\n--- Tin nhắn gốc ---\n' + (msg.message || ''));

    const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('contactMsgModal'));
    modal.show();

    if (msg.status === 'new') {
        fetch('<?php echo BASE_URL; ?>/api/mark_contact_read.php', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + encodeURIComponent(msg.id)
        })
        .then(res => res.json())
        .then(data => {
            if (data && data.success) {
                msg.status = 'read';
                const badge = document.getElementById('status-badge-' + msg.id);
                if (badge) {
                    badge.className = 'badge bg-primary';
                    badge.textContent = 'Đã đọc';
                }
                const row = document.getElementById('contact-row-' + msg.id);
                if (row) {
                    row.classList.remove('table-warning');
                }
                const sidebarBadge = document.getElementById('adminSidebarContactBadgeContainer');
                if (sidebarBadge) {
                    if (data.unread_contacts > 0) {
                        sidebarBadge.innerHTML = '<span class="badge bg-danger rounded-pill">' + data.unread_contacts + '</span>';
                    } else {
                        sidebarBadge.innerHTML = '';
                    }
                }
                // Trigger polling if function exists
                if (typeof pollUnreadCounts === 'function') {
                    pollUnreadCounts();
                }
            }
        })
        .catch(() => {});
    }
}
</script>

<?php 
require_once __DIR__ . '/../includes/footer.php'; 
?>
