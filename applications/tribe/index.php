<?php
echo "<h1>Tribe is Working</h1>";
echo "<p><strong>PHP:</strong> " . phpversion() . "</p>";
echo "<p><strong>Server:</strong> " . $_SERVER['SERVER_SOFTWARE'] . "</p>";

// Test MySQL connection
try {
    $pdo = new PDO(
        'mysql:host=mysql;dbname=tribe_db',
        'tribe_user',
        'userpassword'
    );
    echo "<p><strong>MySQL Connection:</strong> <span style='color: green;'>Successful</span></p>";
    echo "<p><strong>MySQL Version:</strong> " . $pdo->getAttribute(PDO::ATTR_SERVER_VERSION) . "</p>";
} catch (PDOException $e) {
    echo "<p><strong>MySQL Connection:</strong> <span style='color: red;'>Failed - " . $e->getMessage() . "</span></p>";
}
?>