<?php

class TextGadget {
	private $text;

	public function set( $t ) {
		$this->text = $t;
	}

	public function get() {
		return $this->text;
	}
}