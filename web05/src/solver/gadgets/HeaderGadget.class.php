<?php

class HeaderGadget
{
    private $header_name = '';
    private $header_value = '';

    public function get()
    {
        $header_name = $this->header_name;
        $header_value = $this->header_value;
        if ($header_name != '') {

            header("$header_name: $header_value");
        }
        return $this->header_name;
    }

    public function set($header_name, $header_value)
    {
        $this->header_name = $header_name;
        $this->header_value = $header_value;
    }
}
