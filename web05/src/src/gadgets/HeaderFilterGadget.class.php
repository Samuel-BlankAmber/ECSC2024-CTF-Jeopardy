<?php

class HeaderFilterGadget {
	private $header_name = '';

	public function __construct( $header_name ) {
		$this->header_name = $header_name;
	}

	public function set() {
		header_remove( $this->header_name );
	}

	public function get() {
		return $this->header_name;
	}
}
