<?php
require __DIR__ . '/_init.php';
$uploads = new \Tribe\Uploads;
$api = new \Tribe\API;

if ($_SERVER['REQUEST_METHOD'] === 'POST')
	$_POST = $api->requestBody;

/* New code that handles file uploading */
if (($_FILES ?? false) || ($_POST ?? false)) {
	header('Content-type: application/json; charset=utf-8');
	echo json_encode($uploads->handleUpload(($_FILES ?? []), ($_POST ?? []), ($_GET ?? [])));
}

/* Old code that handles S3 CDN redirection for uploads folder */
else if ($_ENV['S3_UPLOADS_BUCKET_CDN_URL'] ?? false) {
	$url = $_ENV['S3_UPLOADS_BUCKET_CDN_URL'].'/'.explode('/uploads/', $_SERVER['REQUEST_URI'])[1];
	$cnt = file_get_contents($url, false, stream_context_create(array('ssl' => array('verify_peer' => false, 'verify_peer_name' => false))));
	$mime_type = getMimeType($cnt, 'str');  //get the mime-type of the content in $cnt

	// set the header and outputs the content
	header('Content-Type: '. $mime_type);
	echo $cnt;
	exit;
}

else 'File not found.';

function linux_command($cmd) {
	ob_start();
	passthru($cmd . ' > /dev/null 2>&1 &');
	$tml = ob_get_contents();
	ob_end_clean();
	return $tml;
}

function getMimeType($r, $t='file') {
	//Returns the Mime Type of a file or a string content - from: https://coursesweb.net/
	// $r = the resource: Path to the file; Or the String content
	// $t = type of the resource, needed to be specified as "str" if $r is a string-content
	$finfo = new finfo(FILEINFO_MIME_TYPE);
	return ($t =='str') ? $finfo->buffer($r) : $finfo->file($r);
}