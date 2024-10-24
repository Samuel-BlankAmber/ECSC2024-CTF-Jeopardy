<?php
session_start();

require_once 'custom-functions.php';
require_once 'pow.php';

check_pow();


if(!isset($_POST['username'])) {
    die();
}

$random_password = create_user_in_db($_POST['username']);

echo "User created with password: $random_password";
session_destroy(); // clear pow
?>


