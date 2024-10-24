<?php


function create_user_in_db($user) {
    // check user is alphanumeric

    if (!preg_match('/^[a-zA-Z0-9._]+$/', $user)) {
        die("Invalid username");
    }

    $host = getenv('DB_HOST');
    $pass = getenv("MYSQL_ROOT_PASSWORD");
    $conn = new mysqli($host, "root", $pass);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // create user
    $random_password = "a" . bin2hex(random_bytes(8));
    $sql = $conn->prepare("CREATE USER '$user'@'%' IDENTIFIED BY '$random_password'");
    $sql->execute();

    if ($sql->error) {
        die("Error creating user");
    }

    //create db
    $sql = $conn->prepare("CREATE DATABASE $user");
    $sql->execute();

    if ($sql->error) {
        die("Error creating database");
    }

    // grant privileges
    $sql = $conn->prepare("GRANT ALL PRIVILEGES ON $user . * TO '$user'@'%'");
    $sql->execute();

    if ($sql->error) {
        die("Error granting privileges");
    }


    // create table
    $conn->select_db($user);
    $sql = $conn->prepare("CREATE TABLE flag (flag VARCHAR(255));");
    $sql->execute();

    if ($sql->error) {
        die("Error creating table");
    }

    $conn->close();

    return $random_password;
}
