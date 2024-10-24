<?php

class BodyGadget
{
    private $text;

    public function set($t)
    {
        $this->text = $t;
    }

    public function get()
    {
        $highlighted = highlight_string($this->text->get());
        $this->text->set($highlighted);
        return $this->text->get();
    }
}
