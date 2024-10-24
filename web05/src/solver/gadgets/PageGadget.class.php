<?php

class PageGadget{
    private $head;
    private $body;
    private $headers=[];

    public function set($headers, $head, $body){
        $this->headers = $headers;
        $this->head = $head;
        $this->body = $body;
    }

    public function get(){
        global $headers;
        $page = $this->head->get();
        $page .= $this->body->get();

        $this->headers[] = new HeaderGadget("Content-Security-Policy", "default-src 'self';");

        $headers = array_merge($headers, $this->headers);
        if($this->head->headers != null)
            $headers = array_merge($headers, $this->head->headers);

        return $page;
    }
}