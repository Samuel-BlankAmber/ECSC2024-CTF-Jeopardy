<?php

class SerializationGadget{
    private $payload;
    
    public function set($b64)
    {
        $this->payload = new Base64Gadget();
        $this->payload->set($b64);
    }
    
    public function get(){

        $allowed_classes = [];
        $classes = glob('gadgets/*');
        
        foreach($classes as $class){
            $class = str_replace('gadgets/', '', $class);
            $allowed_classes[] = str_replace('.class.php', '', $class);
        }

        return unserialize($this->payload->get(), ['allowed_classes' => $allowed_classes]);
    }

}