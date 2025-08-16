<?php
//composer autoload
require __DIR__ . '/vendor/autoload.php';

//dotenv for loading variables in .env as $_ENV
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__, '.env');
$dotenv->load();

//php vars file
require_once __DIR__.'/config/config.php';
