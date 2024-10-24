<?php


class Base64Gadget
{

    private $str;

    public function get()
    {
        return base64_decode($this->str);
    }

    public function set($str)
    {
        $this->str = $str;
    }
}
