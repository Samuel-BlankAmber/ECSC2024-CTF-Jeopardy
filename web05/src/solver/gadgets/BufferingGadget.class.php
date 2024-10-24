<?php

class BufferingGadget
{

    public function get()
    {

        return ob_get_clean();
    }

    public function set()
    {

        ob_start();
    }
}
