<?php
/**
 * DO NOT MANUALLY MODIFY THIS FILE
 * THIS FILE EXISTS FOR BACKWARD COMPATIBILITY REASONS ONLY, TRY TO USE ".env"
 *
 * add custom variables to ".env" in project root or create a "vars.php"
 * in this directory if you want to add your own variables
 */
date_default_timezone_set($_ENV['DEFAULT_TIMEZONE']);

// set cors headers in PHP server
if ($_ENV['ALLOW_CROSS_ORIGIN'] === 'true') {

	if ($_ENV['ENV'] == 'prod') {
	    $allowed_origins = [
	        'http://localhost:4200',
	        /*
	        'https://domain.tld',
	        'https://tribe.domain.tld',
	        'https://junction.domain.tld',
	        */
	    ];

	    if (in_array($_SERVER['HTTP_ORIGIN'], $allowed_origins)) {
	        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
	    }

	    header("Access-Control-Allow-Headers: *");
	    header("Access-Control-Allow-Methods: *");
	}

	//in dev environment, allowing cross origin *
	else {
		header("Access-Control-Allow-Origin: *");
		header("Access-Control-Allow-Headers: *");
		header("Access-Control-Allow-Methods: *");
	}
}

define('WEB_ROOT', dirname(__DIR__, 2));
define('TRIBE_ROOT', dirname(__DIR__, 1));
define('ABSOLUTE_PATH', dirname(__DIR__, 1));
define('ENV', $_ENV['ENV']);
define('DB_NAME', $_ENV['DB_NAME']);
define('DB_USER', $_ENV['DB_USER']);
define('DB_PASS', $_ENV['DB_PASS']);
define('DB_HOST', $_ENV['DB_HOST']);
define('DB_PORT', $_ENV['DB_PORT']);
define('BARE_URL', $_ENV['WEB_BARE_URL']);
define('BASE_URL', ($_ENV['SSL'] !== 'false' ? 'https' : 'http') . '://' . BARE_URL);