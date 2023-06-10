<?php
require_once("includes.php");

switch(strtolower($_GET["route"])) {
	default:
	case "index": 
	 	break;

	case "getuser":
		$id = (int)$_POST["id"];
		$c = new User((int)$id);
		set_response($c->getData());
		break; 

	case "login":
		$username = $_POST["username"];
		$password = $_POST["password"];
		$c = new User();
		$u = $c->getUser([
			"username"=>$username,
			"password"=>md5($password),
		]);
		isset($u["id"]) ? set_response($u) : set_response([]);
		break; 

	case "adduser":
		$c = new User();
		$_POST["password"] = md5($_POST["password"]);
		$data = $c->prepareData($_POST);
		$c->save();
		set_response($c->getData());
		break;

	case "updateuser":
		$id = $_POST["id"];
		$c = new User((int)$id);
		if (!$c->id) set_response(["code"=>404, "http_response"=>"NOT_FOUND"]);

		$c->prepareData($_POST);
		$c->save();
		set_response($c->getData());
		break; 

	case "deleteuser":
		$id = (int)$_POST["id"];
		$c = new User($id);
		if (!$c->id) set_response(["code"=>404, "http_response"=>"NOT_FOUND"]);
		$affectedrows = $c->remove($id);
		set_response(["affected_rows"=>$affectedrows]);
		break; 

	case "getficha":
		$id = (int)$_POST["id"];
		$c = new Ficha($id);
		set_response($c->getData());
		break; 

	case "getfichas":
		$c = new Ficha();
		set_response($c->getFichas());
		break; 

	case "addficha":
		$c = new Ficha();
		$c->prepareData($_POST);
		$c->save();
		set_response($c->getData());
		break;

	case "updateficha":
		$id = (int)$_POST["id"];
		$c = new Ficha($id);
		if (!$c->id) set_response(["code"=>404, "http_response"=>"NOT_FOUND"]);

		$c->prepareData($_POST);
		$c->save();
		set_response($c->getData());
		break; 

	case "deleteficha":
		$id = (int)$_POST["id"];
		$c = new Ficha($id);
		if (!$c->id) set_response(["code"=>404, "http_response"=>"NOT_FOUND"]);
		$affectedrows = $c->remove($id);
		set_response(["affected_rows"=>$affectedrows]);
		break; 

	case "upload":
		$c = new FileManager();
		$result = $c->upload();
		if ($result["success"]) {
			$id = (int)$_GET["id"];
			$field_foto = $_GET["fieldname"];
			$data = [];
			$c = new Ficha($id);
			$c->prepareData([
				"id"=>$id,
				"$field_foto"=>$result["url"]
			]);
			$c->save();
			set_response($c->getData());
		} else {
			set_response($result);
		}
		break; 

}

function set_response(Array $data) {
	header('Content-Type: application/json; charset=utf-8');

	$json = json_encode($data);
	echo $json;
	die;
}