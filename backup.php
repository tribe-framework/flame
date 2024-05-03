<?php
require __DIR__ . '/_init.php';
$backup = new \Tribe\Backup;
$backup->mysqlDatabase();
$backup->uploadsFolder();
$backup->deleteOldMySQLBackups();
?>