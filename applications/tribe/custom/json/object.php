<?php
require __DIR__ . '/../../_init.php';
header('Content-Type: application/json');
$core = new \Tribe\Core;
$object = $core->getObject($_GET['id']);
if ($object['content_privacy'] == 'public') {
	echo json_encode($object);
}
?>