<?php

class HeadGadget {

	private $text;
	public $headers = [];

	public function set( $text ) {

		$this->text = $text;
	}


	public function get() {
		$metas = [];
		$text = $this->text->get();
		if ( $text != null ) {
			preg_match( "/<meta http-equiv=\"([a-zA-Z]+)\" value=\"([a-zA-Z]+)\">/", $text, $metas );
		}

		foreach ( $metas as $m ) {
			$header = new HeaderGadget();
			if ( $m[1] == '' ) {
				continue;
			}
			$header->set( $m[1], $m[2] );
			$this->headers[] = $header;
		}

		return $this->text->get();
	}
}
