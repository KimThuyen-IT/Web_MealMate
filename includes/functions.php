<?php
// includes/functions.php

// Function to set flash message
function set_flash_message($type, $message) {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    $_SESSION['flash_message'] = [
        'type' => $type, // 'success', 'danger', 'warning', 'info'
        'message' => $message
    ];
}

// Function to display flash message
function display_flash_message() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    if (isset($_SESSION['flash_message'])) {
        $type = $_SESSION['flash_message']['type'];
        $message = $_SESSION['flash_message']['message'];

        echo '<div class="alert alert-' . $type . ' alert-dismissible fade show" role="alert">';
        echo htmlspecialchars($message);
        echo '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
        echo '</div>';

        // Clear message after displaying
        unset($_SESSION['flash_message']);
    }
}

// Helper for CSRF token
function generate_csrf_token() {
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function verify_csrf_token($token) {
    return is_string($token) && isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}

function render_pagination_links($current_page, $total_pages, $base_params = []) {
    $current_page = max(1, (int)$current_page);
    $total_pages = max(1, (int)$total_pages);

    if ($total_pages <= 1) {
        return '';
    }

    $build_url = function ($page) use ($base_params) {
        $params = $base_params;
        $params['page'] = (int)$page;
        return '?' . http_build_query($params);
    };

    $pages = [];
    $start = max(1, $current_page - 2);
    $end = min($total_pages, $current_page + 2);

    if ($current_page <= 3) {
        $start = 1;
        $end = min(5, $total_pages);
    }

    if ($current_page >= $total_pages - 2) {
        $start = max(1, $total_pages - 4);
        $end = $total_pages;
    }

    if ($start > 1) {
        $pages[] = 1;
        if ($start > 2) {
            $pages[] = 'ellipsis';
        }
    }

    foreach (range($start, $end) as $page) {
        $pages[] = (int)$page;
    }

    if ($end < $total_pages) {
        if ($end < $total_pages - 1) {
            $pages[] = 'ellipsis';
        }
        $pages[] = $total_pages;
    }

    $html = '<ul class="pagination justify-content-center">';
    $html .= '<li class="page-item ' . ($current_page <= 1 ? 'disabled' : '') . '"><a class="page-link" href="' . $build_url($current_page - 1) . '">Trước</a></li>';

    foreach ($pages as $page) {
        if ($page === 'ellipsis') {
            $html .= '<li class="page-item disabled"><span class="page-link">…</span></li>';
            continue;
        }

        $active = $page == $current_page ? 'active' : '';
        $html .= '<li class="page-item ' . $active . '"><a class="page-link" href="' . $build_url($page) . '">' . $page . '</a></li>';
    }

    $html .= '<li class="page-item ' . ($current_page >= $total_pages ? 'disabled' : '') . '"><a class="page-link" href="' . $build_url($current_page + 1) . '">Sau</a></li>';
    $html .= '</ul>';

    return $html;
}

function is_valid_date($date) {
    if (!is_string($date)) return false;
    $parsed = DateTime::createFromFormat('!Y-m-d', $date);
    return $parsed && $parsed->format('Y-m-d') === $date;
}

function old($key, $default = '') {
    return htmlspecialchars((string)($_POST[$key] ?? $default), ENT_QUOTES, 'UTF-8');
}
function food_image_url($image) {
    $fallback = BASE_URL . '/img/bg1.jpg';
    if (!is_string($image) || trim($image) === '') {
        return $fallback;
    }

    $image = str_replace('\\', '/', trim($image));
    if (preg_match('#^https?://#i', $image)) {
        return filter_var($image, FILTER_VALIDATE_URL) ? $image : $fallback;
    }

    $relative = '/' . ltrim($image, '/');
    $full_path = dirname(__DIR__) . str_replace('/', DIRECTORY_SEPARATOR, $relative);
    if (is_file($full_path)) {
        return BASE_URL . $relative;
    }

    $filename = basename($image);
    foreach (['/uploads/foods/', '/assets/uploads/foods/'] as $directory) {
        $candidate = $directory . $filename;
        $candidate_path = dirname(__DIR__) . str_replace('/', DIRECTORY_SEPARATOR, $candidate);
        if (is_file($candidate_path)) {
            return BASE_URL . $candidate;
        }
    }

    return $fallback;
}
function meal_plan_image_url($image) {
    $fallback = BASE_URL . '/img/bg1.jpg';
    if (!is_string($image) || trim($image) === '') {
        return $fallback;
    }

    $image = str_replace('\\', '/', trim($image));
    if (preg_match('#^https?://#i', $image)) {
        return filter_var($image, FILTER_VALIDATE_URL) ? $image : $fallback;
    }

    $filename = basename($image);
    $relative = '/uploads/meal_plans/' . $filename;
    $full_path = dirname(__DIR__) . str_replace('/', DIRECTORY_SEPARATOR, $relative);

    return is_file($full_path) ? BASE_URL . $relative : $fallback;
}
