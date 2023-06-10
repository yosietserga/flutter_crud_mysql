<?php
require_once("config/config.php");
require_once("lib/db.php");

global $db;
$db = new DB(DB_DRIVER, DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

require_once("model/user.php");
require_once("model/ficha.php");
require_once("model/filemanager.php");