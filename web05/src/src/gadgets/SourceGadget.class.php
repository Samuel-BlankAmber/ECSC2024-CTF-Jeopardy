<?php

class SourceGadget {
	private $filename;


	public function set( $filename ) {
		$this->filename = $filename;
	}

	public function get() {
		$filename = str_replace( '.', '', $this->filename );

		if ( str_contains( $filename, 'Gadget' ) ) :
			$this->filename = __DIR__ . "/$filename.class.php";
		else :
			$this->filename = __DIR__ . "/../$filename.php";
		endif;

		return file_get_contents( $this->filename );
	}

}