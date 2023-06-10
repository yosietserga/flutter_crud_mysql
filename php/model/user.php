<?php

final class User {
    private $id = null;
    private $data;

    public function __construct(Int $id = 0) {
        global $db;
        if ($id>0) {
            $res = $db->query("SELECT * FROM `users` WHERE `id` = $id");
            if ($res->rows[0]) {
                $this->id = $res->rows[0]["id"];
                $this->data = $res->rows[0];
            }
        } else {
            $this->data = [
                "id"=>0,
                "email"=>"",
                "username"=>"",
                "password"=>"",
            ];
        }
    }

    public function __get(String $k) {
        return $this->data[$k]??"";
    }
    
    public function __set(String $k, $v) {
        return $this->data[$k] = $v;
    }

    public function __isset(String $k) {
        return isset($this->data[$k]);
    }

    public function prepareData(Array $d):void {
        //$this->data = [];

        if (isset($d["id"]) && !empty($d["id"])) $this->data["id"] = $d["id"];
        if (isset($d["email"]) && !empty($d["email"])) $this->data["email"] = $d["email"];
        if (isset($d["username"]) && !empty($d["username"])) $this->data["username"] = $d["username"];
        if (isset($d["password"]) && !empty($d["password"])) $this->data["password"] = $d["password"];
    }

    public function save():void {
        global $db;
        $exists = (int)$this->id ? $this->getUser(["id"=>$this->id]) : $this->getUser(["username"=>$this->data["username"]]);

        $d = $this->data;
        $c = [];
        //if (isset($d["id"]) && !empty($d["id"])) $c["id"] = "`id` = ". (int)$d['id'] ;
        if (isset($d["email"])) $c["email"] = "`email` = '". $db->escape($d['email']) ."'";
        if (isset($d["username"])) $c["username"] = "`username` = '". $db->escape($d['username'])."'";
        if (isset($d["password"])) $c["password"] = "`password` = '". $db->escape($d['password'])."'";
        
        if ($this->id && isset($exists["id"])) {
            $sql = "UPDATE `users` SET ";
            $sql .= implode(", ", $c);
            $sql .= " WHERE id = '${$exists["id"]}'";
            $db->query($sql);
        } else {
            $sql = "INSERT INTO `users` SET ";
            $sql .= implode(", ", $c);
            $db->query($sql);

            $this->data["id"] = $db->getLastId();
        }

    }

    public function remove(Int $id = 0):Int {
        global $db;
        $user = $id > 0 ? new User($id) : new User($this->id);
        //$user = $id>0 ? $this->getUser(["id"=>$id]) : $this->getUser(["id"=>$this->data["id"]]);

        if ($user->id) {
            $this->data = [];
            $sql = "DELETE FROM `users` WHERE `id` = ". (int)$user->id;
            $db->query($sql);
        }
        return $db->countAffected();
    }   

    public function getData():Array {
        return $this->data;
    }

    public function getUser(Array $d=[]):?Array {
        $rows = $this->getUsers($d);
        return $rows[0]??null;
    }

    public function getUsers(Array $d=[]):Array {
        global $db;
        $sql = "SELECT * FROM `users` WHERE "; 
        $c = [];
        if (isset($d["id"]) && !empty($d["id"])) $c["id"] = "`id` = ". (int)$d['id'];
        if (isset($d["email"]) && !empty($d["email"])) $c["email"] = "`email` = '". $db->escape($d['email'])."'";
        if (isset($d["username"]) && !empty($d["username"])) $c["username"] = "`username` = '". $db->escape($d['username']) ."'";
        if (isset($d["password"]) && !empty($d["password"])) $c["password"] = "`password` = '". $db->escape($d['password']) ."'";

        $sql .= implode(" AND ", $c);
        $res = $db->query($sql);
        return $res->rows;
    }
}