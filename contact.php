<?php
require_once __DIR__ . '/config/app.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/includes/functions.php';

$page_title = 'Liên hệ';
$success_msg = '';
$error_msg = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $subject = trim($_POST['subject'] ?? '');
    $message = trim($_POST['message'] ?? '');

    $field_errors = [];

    if (!verify_csrf_token($_POST['csrf_token'] ?? '')) {
        $error_msg = 'Yêu cầu không hợp lệ. Vui lòng thử lại.';
    } else {
        if ($name === '') {
            $field_errors['name'] = 'Vui lòng nhập họ và tên.';
        } elseif (mb_strlen($name) > 150) {
            $field_errors['name'] = 'Họ và tên không được vượt quá 150 ký tự.';
        }

        if ($email === '') {
            $field_errors['email'] = 'Vui lòng nhập email.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $field_errors['email'] = 'Email không hợp lệ.';
        }

        if ($subject === '') {
            $field_errors['subject'] = 'Vui lòng nhập chủ đề.';
        } elseif (mb_strlen($subject) > 200) {
            $field_errors['subject'] = 'Chủ đề không được vượt quá 200 ký tự.';
        }

        if ($message === '') {
            $field_errors['message'] = 'Vui lòng nhập nội dung.';
        } elseif (mb_strlen($message) > 5000) {
            $field_errors['message'] = 'Nội dung không được vượt quá 5000 ký tự.';
        }

        if (empty($field_errors)) {
            $conn = (new Database())->getConnection();
            $stmt = $conn->prepare("INSERT INTO contact_messages (full_name, email, subject, message, status) VALUES (:name, :email, :subject, :message, 'new')");
            $stmt->execute([':name' => $name, ':email' => $email, ':subject' => $subject, ':message' => $message]);
            $contact_id = (int)$conn->lastInsertId();

            // Tạo thông báo cho toàn bộ Admin về thư liên hệ mới
            try {
                $stmtAdmins = $conn->query("SELECT id FROM users WHERE role = 'admin' AND status = 'active'");
                $admins = $stmtAdmins->fetchAll(PDO::FETCH_COLUMN);

                if (!empty($admins)) {
                    $notif_title = '📩 Thư liên hệ mới: ' . mb_substr($subject, 0, 80, 'UTF-8');
                    $notif_message = '[MID:' . $contact_id . '] [Từ ' . $name . ' (' . $email . ')]: ' . mb_substr($message, 0, 200, 'UTF-8');

                    $stmtInsertNotif = $conn->prepare("INSERT INTO notifications (user_id, title, message, type, is_read) VALUES (:uid, :title, :message, 'info', 0)");
                    foreach ($admins as $admin_id) {
                        $stmtInsertNotif->execute([
                            ':uid' => $admin_id,
                            ':title' => $notif_title,
                            ':message' => $notif_message
                        ]);
                    }
                }
            } catch (Exception $notifEx) {
                // Tránh lỗi thông báo làm gián đoạn gửi liên hệ
            }

            $success_msg = 'Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi trong thời gian sớm nhất.';
            $_POST = [];
        } else {
            $error_msg = 'Vui lòng kiểm tra lại thông tin nhập liệu.';
        }
    }
}
require_once __DIR__ . '/includes/header.php';
?>

<style>
    main.min-vh-100 {
        min-height: 0 !important;
    }

    .contact-shell {
        background: rgba(0, 0, 0, 0.02);
        border: 1px solid #d9d9d9;
        border-radius: 26px;
        padding: 42px 40px 30px;
        margin: 18px auto 28px;
        max-width: 1280px;
    }

    .contact-layout {
        display: grid;
        grid-template-columns: 1fr 1.05fr;
        gap: 52px;
        align-items: start;
    }

    .contact-sidebar {
        padding-top: 18px;
    }

    .contact-kicker {
        font-size: 16px;
        color: #4b5563;
        margin-bottom: 18px;
    }

    .contact-title {
        font-size: clamp(2.3rem, 3vw, 4rem);
        line-height: 1.1;
        font-weight: 800;
        letter-spacing: -0.05em;
        margin: 0 0 18px;
        color: #111827;
    }

    .contact-subtext {
        font-size: clamp(1rem, 1.5vw, 1.15rem);
        color: #4b5563;
        line-height: 1.7;
        max-width: 560px;
        margin-bottom: 24px;
    }

    .contact-actions {
        display: flex;
        align-items: center;
        gap: 18px;
        flex-wrap: wrap;
    }

    .contact-email-btn {
        display: inline-flex;
        align-items: center;
        gap: 12px;
        min-height: 58px;
        padding: 0 22px;
        background: linear-gradient(180deg, #1e88ff 0%, #0d73f5 100%);
        color: #fff;
        border-radius: 14px;
        text-decoration: none;
        font-size: 1.05rem;
        font-weight: 600;
        box-shadow: 0 10px 18px rgba(17, 102, 214, 0.16);
    }

    .contact-email-btn:hover {
        color: #fff;
        filter: brightness(0.98);
    }

    .social-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 44px;
        height: 44px;
        border-radius: 12px;
        background: #f3f4f6;
        color: #111827;
        font-size: 1.25rem;
        text-decoration: none;
        border: 1px solid #e5e7eb;
    }

    .social-icon.youtube {
        color: #ff0000;
    }

    .social-icon.mail {
        color: #1d4ed8;
    }

    .contact-form-wrap {
        padding-top: 12px;
    }

    .contact-form {
        width: 100%;
    }

    .contact-form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 18px;
    }

    .contact-field {
        margin-bottom: 18px;
    }

    .contact-field label {
        display: block;
        margin-bottom: 10px;
        font-size: 16px;
        font-weight: 500;
        color: #111827;
    }

    .contact-form .form-control {
        width: 100%;
        min-height: 54px;
        border: 1px solid #d7d7d7;
        border-radius: 12px;
        background: #f3f3f3;
        color: #111827;
        padding: 0.8rem 1rem;
        box-shadow: none;
        transition: border-color 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
    }

    .contact-form textarea.form-control {
        min-height: 160px;
        resize: vertical;
    }

    .contact-form .form-control:focus {
        background: #fff;
        border-color: #bcbcbc;
        box-shadow: none;
        outline: none;
    }

    .contact-submit-wrap {
        position: relative;
        margin-top: 10px;
    }

    .contact-submit-wrap .contact-send-btn {
        position: absolute;
        right: 14px;
        bottom: 12px;
        border: none;
        background: transparent;
        color: #111827;
        font-size: 22px;
        padding: 0;
        cursor: pointer;
    }

    .contact-submit-wrap .contact-send-btn:hover {
        color: #374151;
    }

    .submit-button {
        width: 100%;
        min-height: 56px;
        border: none;
        border-radius: 14px;
        background: linear-gradient(180deg, #1e88ff 0%, #0d73f5 100%);
        color: #fff;
        font-size: 1.2rem;
        font-weight: 700;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        box-shadow: 0 10px 18px rgba(13, 115, 245, 0.16);
    }

    .contact-inline-alert {
        margin-bottom: 18px;
    }

    @media (max-width: 991.98px) {
        .contact-layout {
            grid-template-columns: 1fr;
            gap: 28px;
        }
        .contact-shell {
            padding: 28px 20px 22px;
        }
    }
</style>

<div class="container">
    <div class="contact-shell">
        <div class="contact-layout">
            <div class="contact-sidebar">
                <div class="contact-kicker">Liên hệ</div>
                <h1 class="contact-title">Cùng xây dựng điều tuyệt vời</h1>
                <p class="contact-subtext">Quan tâm đến sản phẩm của chúng tôi hoặc muốn hợp tác? Gửi tin nhắn và chúng tôi sẽ phản hồi trong vòng 24 giờ.</p>

                <div class="contact-actions">
                    <a href="mailto:pltsolutions3010@gmail.com" class="contact-email-btn">
                        <i class="bi bi-envelope-fill"></i>
                        <span>pltsolutions3010@gmail.com</span>
                    </a>
                    <a href="https://www.youtube.com/" target="_blank" rel="noopener noreferrer" class="social-icon youtube" aria-label="YouTube">
                        <i class="bi bi-youtube"></i>
                    </a>
                    <a href="mailto:pltsolutions3010@gmail.com" class="social-icon mail" aria-label="Gửi email">
                        <i class="bi bi-envelope-fill"></i>
                    </a>
                </div>
            </div>

            <div class="contact-form-wrap">
                <form method="POST" action="" class="contact-form">
                    <input type="hidden" name="csrf_token" value="<?php echo generate_csrf_token(); ?>">

                    <?php if ($success_msg): ?>
                        <div class="alert alert-success contact-inline-alert"><i class="bi bi-check-circle-fill me-2"></i><?php echo htmlspecialchars($success_msg); ?></div>
                    <?php endif; ?>
                    <?php if ($error_msg): ?>
                        <div class="alert alert-danger contact-inline-alert"><?php echo htmlspecialchars($error_msg); ?></div>
                    <?php endif; ?>

                    <div class="contact-form-row">
                        <div class="contact-field">
                            <label for="contactName">Họ và tên</label>
                            <input id="contactName" type="text" class="form-control <?php echo isset($field_errors['name']) ? 'is-invalid' : ''; ?>" name="name" maxlength="150" placeholder="Họ tên của bạn" value="<?php echo old('name'); ?>" required>
                            <?php if (isset($field_errors['name'])): ?><div class="invalid-feedback d-block"><?php echo htmlspecialchars($field_errors['name']); ?></div><?php endif; ?>
                        </div>

                        <div class="contact-field">
                            <label for="contactEmail">Email</label>
                            <input id="contactEmail" type="email" class="form-control <?php echo isset($field_errors['email']) ? 'is-invalid' : ''; ?>" name="email" placeholder="ban@congty.com" value="<?php echo old('email'); ?>" required>
                            <?php if (isset($field_errors['email'])): ?><div class="invalid-feedback d-block"><?php echo htmlspecialchars($field_errors['email']); ?></div><?php endif; ?>
                        </div>
                    </div>

                    <div class="contact-field">
                        <label for="contactSubject">Chủ đề</label>
                        <input id="contactSubject" type="text" class="form-control <?php echo isset($field_errors['subject']) ? 'is-invalid' : ''; ?>" name="subject" maxlength="200" placeholder="Chủ đề của bạn" value="<?php echo old('subject'); ?>" required>
                        <?php if (isset($field_errors['subject'])): ?><div class="invalid-feedback d-block"><?php echo htmlspecialchars($field_errors['subject']); ?></div><?php endif; ?>
                    </div>

                    <div class="contact-field contact-submit-wrap">
                        <label for="contactMessage">Nội dung tin nhắn</label>
                        <textarea id="contactMessage" class="form-control <?php echo isset($field_errors['message']) ? 'is-invalid' : ''; ?>" name="message" rows="5" maxlength="5000" placeholder="Hãy cho chúng tôi biết về dự án hoặc câu hỏi của bạn..." required><?php echo old('message'); ?></textarea>
                        <?php if (isset($field_errors['message'])): ?><div class="invalid-feedback d-block"><?php echo htmlspecialchars($field_errors['message']); ?></div><?php endif; ?>
                        <button type="submit" class="contact-send-btn" aria-label="Gửi tin nhắn">
                            <i class="bi bi-arrow-up"></i>
                        </button>
                    </div>

                    <button type="submit" class="submit-button">
                        <i class="bi bi-send-fill"></i>
                        <span>Gửi tin nhắn</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
<?php require_once __DIR__ . '/includes/footer.php'; ?>
