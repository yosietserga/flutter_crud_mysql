<?php

final class Ficha {
    private $id = null;
    private $data;

    public function __construct(Int $id = 0) {
        global $db;
        if ($id>0) {
            $res = $db->query("SELECT * FROM `ficha` WHERE `id` = $id");
            if ($res->rows[0]) {
                $this->id = $res->rows[0]["id"];
                $this->data = $res->rows[0];
            }
        } else {
            $this->data = [
                "id"=>0,
                "usuario"=>"",
                "local"=>"",
                "maquina"=>"",
                "repuesto"=>"",
                "observaciones"=>"",
                "fecha"=>"",
                "parada"=>"",
                "foto1"=>"",
                "foto2"=>"",
                "foto3"=>"",
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
        if (isset($d["usuario"]) && !empty($d["usuario"])) $this->data["usuario"] = $d["usuario"];
        if (isset($d["local"]) && !empty($d["local"])) $this->data["local"] = $d["local"];
        if (isset($d["maquina"]) && !empty($d["maquina"])) $this->data["maquina"] = $d["maquina"];
        if (isset($d["repuesto"]) && !empty($d["repuesto"])) $this->data["repuesto"] = $d["repuesto"];
        if (isset($d["observaciones"]) && !empty($d["observaciones"])) $this->data["observaciones"] = $d["observaciones"];
        if (isset($d["fecha"]) && !empty($d["fecha"])) $this->data["fecha"] = $d["fecha"];
        if (isset($d["parada"]) && !empty($d["parada"])) $this->data["parada"] = $d["parada"];
        if (isset($d["foto1"]) && !empty($d["foto1"])) $this->data["foto1"] = $d["foto1"];
        if (isset($d["foto2"]) && !empty($d["foto2"])) $this->data["foto2"] = $d["foto2"];
        if (isset($d["foto3"]) && !empty($d["foto3"])) $this->data["foto3"] = $d["foto3"];
    }

    public function save():void {
        global $db;
        $exists = $this->id ? $this->getFicha(["id"=>$this->id]) : $this->getFicha(["usuario"=>$this->data["usuario"]]);

        $d = $this->data;
        $c = [];

        //if (isset($d["id"]) && !empty($d["id"])) $c["id"] = "`id` = ${(int)$d['id']}";
        if (isset($d["usuario"])) $c["usuario"] = "`usuario` = '". $db->escape($d['usuario'])."'";
        if (isset($d["local"])) $c["local"] = "`local` = '". $db->escape($d['local'])."'";
        if (isset($d["maquina"])) $c["maquina"] = "`maquina` = '". $db->escape($d['maquina'])."'";
        if (isset($d["repuesto"])) $c["repuesto"] = "`repuesto` = '". $db->escape($d['repuesto'])."'";
        if (isset($d["observaciones"])) $c["observaciones"] = "`observaciones` = '". $db->escape($d['observaciones'])."'";
        if (isset($d["fecha"])) $c["fecha"] = "`fecha` = '". $db->escape($d['fecha'])."'";
        if (isset($d["parada"])) $c["parada"] = "`parada` = '". $db->escape($d['parada'])."'";
        if (isset($d["foto1"])) $c["foto1"] = "`foto1` = '". $db->escape($d['foto1'])."'";
        if (isset($d["foto2"])) $c["foto2"] = "`foto2` = '". $db->escape($d['foto2'])."'";
        if (isset($d["foto3"])) $c["foto3"] = "`foto3` = '". $db->escape($d['foto3'])."'";

        if (empty($c)) return;

        if ($this->id && isset($exists["id"])) {
            $sql = "UPDATE `ficha` SET ";
            $sql .= implode(", ", $c);
            $sql .= " WHERE `id` = ". (int)$d["id"];
            $db->query($sql);
        } else {
            $sql = "INSERT INTO `ficha` SET ";
            $sql .= implode(", ", $c);
            $db->query($sql);

            $this->data["id"] = $db->getLastId();
        }

    }

    public function remove(Int $id = 0):Int {
        global $db;
        $user = $id > 0 ? new Ficha($id) : new Ficha($this->id);
        //$user = $id>0 ? $this->getFicha(["id"=>$id]) : $this->getFicha(["id"=>$this->data["id"]]);

        if ($user->id) {
            $this->data = [];
            $sql = "DELETE FROM `ficha` WHERE `id` = ". (int)$user->id;
            $db->query($sql);
        }
        return $db->countAffected();
    }   

    public function getData():Array {
        return $this->data;
    }

    public function getFicha(Array $d=[]):?Array {
        $rows = $this->getFichas($d);
        return $rows[0]??null;
    }

    public function getFichas(Array $d=[]):Array {
        global $db;
        $sql = "SELECT * FROM `ficha`"; 
        $c = [];
        if (isset($d["id"]) && !empty($d["id"])) $c["id"] = "`id` = ". (int)$d['id'];
        if (isset($d["usuario"]) && !empty($d["usuario"])) $c["usuario"] = "`usuario` = '". $db->escape($d['usuario'])."'";

        if (count($c)>0) $sql .= " WHERE ". implode(" AND ", $c);
        $res = $db->query($sql);
        return $res->rows;
    }
}