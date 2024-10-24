<?php
session_start();
require_once 'custom-functions.php';
require_once 'pow.php';

check_pow();


$CHALLENGE_URL = getenv("CHALLENGE_URL");
$BOT_URL = 'http://'.getenv("HEADLESS_HOST");
$FLAG = getenv("FLAG");

$BOT_TOKEN = getenv("HEADLESS_AUTH");


if(!isset($_SESSION['bot_username'])){
    $bot_username = bin2hex(random_bytes(8));
    $bot_password = create_user_in_db($bot_username);

    $_SESSION['bot_username'] = $bot_username;
    $_SESSION['bot_password'] = $bot_password;
}else{
    $bot_username = $_SESSION['bot_username'];
    $bot_password = $_SESSION['bot_password'];
}

echo $bot_username;

if(!isset($_POST['url'])){
    die("Url is not set");
}

if(isset($_POST['url'])){
    $url = $_POST['url'];
    if(!str_starts_with($url, "http://") && !str_starts_with($url, "https://")){
        die("Url is not valid");
    }
}

$actions = [
    'browser' => 'chrome',
    'timeout' => 120,
    'actions' => [
        // LOGIN
        [
            'type' => 'request',
            'url' => $CHALLENGE_URL,
            'timeout' => 20
        ],
        [
            'type' => 'type',
            'element' => 'input#input_username',
            'value' => $bot_username
        ],
        [
            'type' => 'type',
            'element' => 'input#input_password',
            'value' => $bot_password
        ],
        [
            'type' => 'click',
            'element' => 'input#input_go',
        ],
        [
            'type' => 'sleep',
            'time' => 5
        ],

        // VISIT PAGE

        [
            'type' => 'request',
            'url' => $_POST['url'],
            'timeout' => 10
        ],
        [
            'type' => 'sleep',
            'time' => 10
        ],

        // INSERT FLAG
        [
            'type' => 'request',
            'url' => $CHALLENGE_URL,
            'timeout' => 20
        ],
        [
            'type' => 'click',
            'element' => "a[href*=\"db=$bot_username\"]",
        ],
        [
            'type' => 'sleep',
            'time' => 5
        ],
        [
            'type' => 'click',
            'element' => "a[href*=\"db=$bot_username\"]",
        ],
        [
            'type' => 'sleep',
            'time' => 5
        ],
        [
            "type" => "click",
            "element" => "a[href*=\"route=/sql&pos=0&db=$bot_username\"]"
        ],
        [
            'type' => 'sleep',
            'time' => 5
        ],
        [
            'type' => 'click',
            'element' => "a[href*=\"route=/table/change&db=$bot_username\"]",
        ],
        [
            'type' => 'sleep',
            'time' => 5
        ],
        [
            'type' => 'type',
            'element' => 'form#insertForm textarea',
            'value' => $FLAG
        ],
        [
            'type' => 'click',
            'element' => '#buttonYes'
        ],
        [
            'type' => 'sleep',
            'time' => 10
        ],



    ]
        ];
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $BOT_URL);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'X-Auth: ' . $BOT_TOKEN,
    'Content-Type: application/json'
]);
curl_setopt( $ch, CURLOPT_POSTFIELDS, json_encode($actions) );
$result = curl_exec($ch);


curl_close($ch);


session_destroy(); // clear pow


?>
