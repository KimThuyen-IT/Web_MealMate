<?php
// user/chat-history.php
require_once __DIR__ . '/../includes/auth-check.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/functions.php';

$database = new Database();
$conn = $database->getConnection();
$user_id = $_SESSION['user_id'];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'delete') {
    if (!verify_csrf_token($_POST['csrf_token'] ?? '')) {
        die('Lỗi CSRF token');
    }
    $id = (int)$_POST['id'];
    $stmt = $conn->prepare("DELETE FROM chat_conversations WHERE id = :id AND user_id = :uid");
    $stmt->execute([':id' => $id, ':uid' => $user_id]);
    $_SESSION['success'] = 'Đã xóa đoạn chat.';
    redirect('/user/chat-history.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'bulk_delete') {
    if (!verify_csrf_token($_POST['csrf_token'] ?? '')) {
        set_flash_message('danger', 'Yêu cầu không hợp lệ.');
    } else {
        $selectedIds = $_POST['conversation_ids'] ?? [];
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
            set_flash_message('warning', 'Chọn ít nhất một cuộc trò chuyện để xóa.');
        } else {
            try {
                $conn->beginTransaction();
                $deleteStmt = $conn->prepare('DELETE FROM chat_conversations WHERE id = :id AND user_id = :uid');
                $deletedCount = 0;
                foreach ($cleanIds as $id) {
                    $deleteStmt->execute([':id' => $id, ':uid' => $user_id]);
                    $deletedCount += $deleteStmt->rowCount();
                }
                $conn->commit();
                set_flash_message('success', "Đã xóa {$deletedCount} cuộc trò chuyện.");
            } catch (Throwable $e) {
                if ($conn->inTransaction()) {
                    $conn->rollBack();
                }
                error_log('Không thể xóa hàng loạt lịch sử chatbot cho user #' . (int)$user_id . ': ' . $e->getMessage());
                set_flash_message('danger', 'Không thể xóa các cuộc trò chuyện đã chọn. Vui lòng thử lại.');
            }
        }
    }
    redirect('/user/chat-history.php');
}

$page = max(1, (int)($_GET['page'] ?? 1));
$limit = 10;
$searchFilter = isset($_GET['search']) && is_string($_GET['search']) ? trim($_GET['search']) : '';
$searchCondition = '';
$searchParams = [];
if ($searchFilter !== '') {
    $searchCondition = " AND (
        c.title LIKE :search_title
        OR EXISTS (
            SELECT 1
            FROM chat_messages cm
            WHERE cm.conversation_id = c.id
              AND cm.message LIKE :search_message
        )
    )";
    $searchPattern = '%' . $searchFilter . '%';
    $searchParams = [
        ':search_title' => $searchPattern,
        ':search_message' => $searchPattern
    ];
}
$offset = ($page - 1) * $limit;

$stmtTotal = $conn->prepare("SELECT COUNT(*) FROM chat_conversations c WHERE c.user_id = :uid {$searchCondition}");
$stmtTotal->execute(array_merge([':uid' => $user_id], $searchParams));
$total_chats = (int)$stmtTotal->fetchColumn();
$total_pages = max(1, (int)ceil($total_chats / $limit));
if ($page > $total_pages) {
    $page = $total_pages;
    $offset = ($page - 1) * $limit;
}

$stmt = $conn->prepare("SELECT c.* FROM chat_conversations c WHERE c.user_id = :uid {$searchCondition} ORDER BY c.updated_at DESC LIMIT :limit OFFSET :offset");
$stmt->bindValue(':uid', $user_id, PDO::PARAM_INT);
foreach ($searchParams as $name => $value) {
    $stmt->bindValue($name, $value, PDO::PARAM_STR);
}
$stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
$stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
$stmt->execute();
$chats = $stmt->fetchAll(PDO::FETCH_ASSOC);
$paginationParams = $searchFilter !== '' ? ['search' => $searchFilter] : [];

$page_title = 'Lịch sử Chatbot AI';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="container py-5">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0 text-success"><i class="bi bi-clock-history me-2"></i>Lịch sử trò chuyện với AI</h4>
                <a href="<?php echo BASE_URL; ?>/user/chatbot.php" class="btn btn-success"><i class="bi bi-plus-circle me-2"></i>Tạo chat mới</a>
            </div>

            <?php if (isset($_SESSION['success'])): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <?php echo $_SESSION['success']; unset($_SESSION['success']); ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <?php endif; ?>

            <form method="GET" action="<?php echo BASE_URL; ?>/user/chat-history.php" class="card border-0 shadow-sm mb-4" data-live-search="reload">
                <div class="card-body">
                    <div class="row g-3 align-items-end">
                        <div class="col-12 col-lg-9">
                            <label for="chat_history_search" class="form-label small fw-semibold">Tìm kiếm cuộc trò chuyện</label>
                            <input type="search" class="form-control" id="chat_history_search" name="search" value="<?php echo htmlspecialchars($searchFilter, ENT_QUOTES, 'UTF-8'); ?>" placeholder="Nhập tiêu đề hoặc nội dung tin nhắn">
                        </div>
                        <div class="col-12 col-lg-3 d-flex justify-content-end gap-2">
                            <a href="<?php echo BASE_URL; ?>/user/chat-history.php" class="btn btn-outline-secondary rounded-pill px-3">Xóa lọc</a>
                            <button type="submit" class="btn btn-success rounded-pill px-4">
                                <i class="bi bi-search me-1"></i>Tìm kiếm
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <form method="POST" id="bulkChatDeleteForm" data-bulk-delete="chat-history" class="mb-3">
                <input type="hidden" name="csrf_token" value="<?php echo generate_csrf_token(); ?>">
                <input type="hidden" name="action" value="bulk_delete">
                <label class="form-check form-check-inline me-2">
                    <input type="checkbox" class="form-check-input" data-bulk-select-all="chat-history" aria-label="Chọn tất cả cuộc trò chuyện">
                    <span class="form-check-label">Chọn tất cả</span>
                </label>
                <button type="submit" class="btn btn-outline-danger rounded-pill" disabled>
                    <i class="bi bi-trash me-1"></i>Xóa đã chọn (<span data-bulk-count>0</span>)
                </button>
            </form>

            <div class="row">
                <?php foreach ($chats as $chat): ?>
                    <div class="col-md-6 mb-4">
                        <div class="card shadow-sm border-0 h-100 card-hover">
                            <div class="card-body">
                                <div class="form-check mb-2">
                                    <input type="checkbox" class="form-check-input" name="conversation_ids[]" value="<?php echo (int)$chat['id']; ?>" form="bulkChatDeleteForm" data-bulk-select="chat-history" aria-label="Chọn cuộc trò chuyện <?php echo htmlspecialchars($chat['title'], ENT_QUOTES, 'UTF-8'); ?>">
                                    <label class="form-check-label small text-muted">Chọn để xóa</label>
                                </div>
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="fw-bold text-truncate pe-2" title="<?php echo htmlspecialchars($chat['title']); ?>">
                                        <a href="<?php echo BASE_URL; ?>/user/chatbot.php?id=<?php echo $chat['id']; ?>" class="text-decoration-none text-dark">
                                            <?php echo htmlspecialchars($chat['title']); ?>
                                        </a>
                                    </h5>
                                </div>
                                <div class="text-muted small mb-3">
                                    <i class="bi bi-calendar2-check me-1"></i>
                                    Cập nhật lần cuối: <?php echo date('H:i - d/m/Y', strtotime($chat['updated_at'])); ?>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <a href="<?php echo BASE_URL; ?>/user/chatbot.php?id=<?php echo $chat['id']; ?>" class="btn btn-sm btn-outline-success">
                                        Tiếp tục chat <i class="bi bi-arrow-right"></i>
                                    </a>
                                    <form method="POST" onsubmit="return confirm('Xóa đoạn hội thoại này? Mọi tin nhắn sẽ bị mất.');">
                                        <input type="hidden" name="csrf_token" value="<?php echo generate_csrf_token(); ?>">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<?php echo $chat['id']; ?>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
                
                <?php if (empty($chats)): ?>
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-chat-left-dots text-muted" style="font-size: 3rem;"></i>
                        <h5 class="text-muted mt-3"><?php echo $searchFilter !== '' ? 'Không tìm thấy cuộc trò chuyện phù hợp.' : 'Bạn chưa có cuộc trò chuyện nào với AI.'; ?></h5>
                        <?php if ($searchFilter === ''): ?>
                            <a href="<?php echo BASE_URL; ?>/user/chatbot.php" class="btn btn-outline-success mt-3">Bắt đầu trò chuyện ngay</a>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
            </div>

            <?php if ($total_pages > 1): ?>
                <nav aria-label="Page navigation" class="mt-4">
                    <?php echo render_pagination_links($page, $total_pages, $paginationParams); ?>
                </nav>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
