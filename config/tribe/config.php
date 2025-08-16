<?php
date_default_timezone_set($_ENV['DEFAULT_TIMEZONE']);
define('BARE_URL', $_ENV['TRIBE_BARE_URL']);
define('BASE_URL', ($_ENV['SSL'] !== 'false' ? 'https' : 'http') . '://' . BARE_URL);