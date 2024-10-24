<?php

class FlagGadget extends HeaderGadget {

	public function __construct() {
		parent::set( "FLAG", getenv( 'FLAG' ) );
	}

	public function set( $h, $v ) {
		throw new Exception( "Cannot change flag" );
	}
}
