<?php
error_reporting( 0 );

ini_set( "display_errors", false );

function autoload( $class_name ) {
	include "gadgets/$class_name.class.php";
}

spl_autoload_register( 'autoload' );

function header_callback() {
	global $headers;

	if ( $headers == null ) {
		die();
	}

	$filters = [];

	foreach ( $headers as $h ) {
        if ( in_array( $h->get(), [ 'FLAG', 'Location' ] ) ) {
            $filters[] = new HeaderFilterGadget( 'FLAG' );
			$filters[] = new HeaderFilterGadget( 'Location' );
		}
	}

	foreach ( $filters as $f ) {
		if ( $f == NULL )
			continue;
		$f->set();
	}
}
header_register_callback( 'header_callback' );


$buffer = new BufferingGadget();
$buffer->set();

$filenames = glob( 'gadgets/*' );
$filenames[] = "index.php";

$payloads = [];
foreach ( $filenames as $file ) {
	$file_s = str_replace( '.class.php', '', $file );
	$file_s = str_replace( 'gadgets/', '', $file_s );
	$source = new SourceGadget;
	$source->set( $file_s );
	$body = new BodyGadget;
	$body->set( $source );
	$csp = new HeaderGadget();
	$csp->set( 'Content-Security-Policy', 'Default \'self\'' );
	$head = new HeadGadget();
	$head->set( new TextGadget );
	$page = new PageGadget();
	$page->set( [ $csp ], $head, $body );
	$payloads[] = [ $file, base64_encode( serialize( $page ) ) ];
}

if ( isset( $_POST['payload'] ) ) {
	$headers = [];
	$payload = $_POST['payload'];
	$ser = new SerializationGadget;
	$ser->set( $payload );
	$page = $ser->get();


	$get_filename = function () {
		$body = $this->body;
		$text = ( fn() => $this->text )->call( $body );
		return ( fn() => $this->filename )->call( $text );
	};


	echo '// class: ' . $get_filename->call( $page ) . " <br>\n";

	echo $page->get();
	$headers[] = new FlagGadget;
	echo $buffer->get();

	exit;
}

?>

<!DOCTYPE html>
<html lang="it">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>A Fever Dream</title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
	<header class="bg-primary text-white text-center py-5">
		<h1>A Fever Dream</h1>
		<p class="lead">The title of the challenge speaks for itself</p>
	</header>
	<div class="container my-5">
		<p class="text-center">
			Enjoy an overly complicated source code viewer!
			<small></small>
		</p>
	</div>
	<footer class="bg-light py-5">
		<div class="container">
			<form method="POST">
				<div class="mb-3">
					<label for="file" class="form-label">Select a file</label>
					<select class="form-select" name="payload" id="file">
						<?php
						foreach ( $payloads as $p ) {
							echo '<option value="' . $p[1] . '">' . $p[0] . '</option>';
						}
						?>

					</select>
				</div>
				<button class="btn btn-primary" type="submit">Get the source!</button>
			</form>
		</div>
	</footer>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>

<?php


echo $buffer->get();
