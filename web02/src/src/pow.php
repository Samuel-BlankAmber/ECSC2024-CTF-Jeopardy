<?php

require_once 'Hashcash.php';

function is_solved_pow($pow, $submitted_pow){

    if($submitted_pow === getenv("CHECKER_TOKEN")) return true;

    if(empty($submitted_pow)) {
        return false;
    }

    try{
        $hashcash = new \TheFox\Pow\Hashcash(26, $pow);
        return $hashcash->verify($submitted_pow);
    } catch (Exception $e) {
        return false;
    }
}

function get_pow(){
    return bin2hex(random_bytes(6));
}


function dump_pow($challenge){
    return "POW NOT SOLVED!!! <br> Solve with <kbd>hashcash -mCb26 \"$challenge\"</kbd> or <a href=\"https://pow.cybersecnatlab.it/?data=$challenge&bits=26\">using the online tool</a>";
}


function check_pow(){
    if(!isset($_SESSION['pow'])){
        $_SESSION['pow'] = get_pow();
    }
    
    if(!isset($_POST['pow'])){
        die(dump_pow($_SESSION['pow']));
    }

    if(!is_solved_pow($_SESSION['pow'], $_POST['pow'])){
        die(dump_pow($_SESSION['pow']));
    }

    
}