<?php

final class FileManager {

    private $error = [];

    public function upload() {
        header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
        header("Last-Modified: " . gmdate("D, d M Y H:i:s") . "GMT");
        header("Cache-Control: no-cache, must-revalidate");
        header("Pragma: no-cache");
        header("Content-type: application/json");

        $json = [];

        $files = $_FILES['image'];

        if (isset($files) && $files['tmp_name']) {
            if ((strlen(utf8_decode($files['name'])) < 3) || (strlen(utf8_decode($files['name'])) > 255)) {
                $json['error'] = "Error en la longitud del nombre del archivo";
            }

            $name = $files['name'];
            $size = $files['size'];
            $type = $files['type']; 
            $ext  = strtolower(strrchr($files['name'], '.'));

            $directory = DIR_IMAGE;

            if (!is_dir($directory)) {
                $json['error'] = "Error: el fichero destino no existe";
            }

            if ($files['size'] > 2000000) {
                $json['error'] = "Error en el tamano del archivo";
            }

            $allowed = array(
                '.jpg',
                '.jpeg',
                '.png',
            );

            if (!in_array($ext, $allowed)) {
                $json['error'] = "Error en el tipo de archivo";
            }

            if ($files['error'] != UPLOAD_ERR_OK) {
                $json['error'] = 'error_upload_' . $files['error'];
            }
        } else {
            $json['error'] = "Error: archivo invalido";
        }

        if (!isset($json['error'])) {
            if (@move_uploaded_file($files['tmp_name'], $directory ."/". basename($name))) {
                $json['success'] = "subido con exito";
                $json['name'] = $name;
                $json['ext']  = $ext;
                $json['size'] = $size;
                $json['type'] = $type;
                $json['url']  = "uploads/" . $name;
            } else {
                $json['error'] = "algo fallo en la subida";
            }
        }

        return $json;
    }

    public function uploader() {
        header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
        header("Last-Modified: " . gmdate("D, d M Y H:i:s") . "GMT");
        header("Cache-Control: no-cache, must-revalidate");
        header("Pragma: no-cache");
        header("Content-type: application/json");

        $json = [];

        $directory = DIR_IMAGE;
        if (!is_dir($directory)) {
            $json['error'] = "Error: fichero no existe";
        }

        $files = $_FILES['files'];
        if (isset($files) && !$json['error']) {
            $name = $files['name'][0];
            $ext = strtolower(substr($files['name'][0], (strrpos($files['name'][0], '.') + 1)));
            $tmp_name = $files['tmp_name'][0];
            $size = $files['size'][0];
            $type = $files['type'][0];
            $error = $files['error'][0];

            $name = str_replace('.' . $ext, '', $name);
            if ($name !== mb_convert_encoding(mb_convert_encoding($name, 'UTF-32', 'UTF-8'), 'UTF-8', 'UTF-32'))
                $name = mb_convert_encoding($name, 'UTF-8', mb_detect_encoding($name));
            $name = htmlentities($name, ENT_NOQUOTES, 'UTF-8');
            $name = preg_replace('`&([a-z]{1,2})(acute|uml|circ|grave|ring|cedil|slash|tilde|caron|lig);`i', '\1', $name);
            $name = html_entity_decode($name, ENT_NOQUOTES, 'UTF-8');
            $name = preg_replace(array('`[^a-z0-9]`i', '`[-]+`'), '-', $name);
            $name = strtolower(trim($name, '-'));

            if ($size > 5000000) {
                $json['error'] = "Error en el tamano del archivo";
            }

            $mime_types_allowed = array(
                'image/jpg',
                'image/jpeg',
                'image/pjpeg',
                'image/png',
                'image/x-png',
            );

            if (!in_array(strtolower($type), $mime_types_allowed)) {
                $return['error'] = 1;
                $return['msg'] = "Error: Archivo no permitido";
            }

            $extension_allowed = array(
                'jpg',
                'jpeg',
                'pjpeg',
                'png'
            );

            if (!in_array(strtolower($ext), $extension_allowed)) {
                $return['error'] = 1;
                $return['msg'] = "Error: Archivo no permitido";
            }

            if ($size == 0 && !$return['error']) {
                $return['error'] = 1;
                $return['msg'] = "Error: El archivo est&aacute; vac&iacute;o";
            }

            if (($size / 1024 / 1024) > 50 && !$return['error']) {
                $return['error'] = 1;
                $return['msg'] = "Error: El tama&ntilde;o del archivo es muy grande, solo se permiten archivos hasta 50MB";
            }

            if ($error > 0 && !$return['error']) {
                $return['error'] = 1;
                $return['msg'] = $error;
            }

            if ($error == UPLOAD_ERR_INI_SIZE)
                $json['error'] = 'UPLOAD_ERR_INI_SIZE';
            if ($error == UPLOAD_ERR_FORM_SIZE)
                $json['error'] = 'UPLOAD_ERR_FORM_SIZE';
            if ($error == UPLOAD_ERR_PARTIAL)
                $json['error'] = 'UPLOAD_ERR_PARTIAL';
            if ($error == UPLOAD_ERR_NO_FILE)
                $json['error'] = 'UPLOAD_ERR_NO_FILE';
            if ($error == UPLOAD_ERR_NO_TMP_DIR)
                $json['error'] = 'UPLOAD_ERR_NO_TMP_DIR';
            if ($error == UPLOAD_ERR_CANT_WRITE)
                $json['error'] = 'UPLOAD_ERR_CANT_WRITE';
            if ($error == UPLOAD_ERR_EXTENSION)
                $json['error'] = 'UPLOAD_ERR_EXTENSION';

            if (!isset($json['error'])) {
                $filename = basename($name . '.' . $ext);
                if (@move_uploaded_file($tmp_name, $directory . $filename)) {
                    $json['success'] = "success";
                    $json['name'] = $name . '.' . $ext;
                    $json['size'] = $size;
                    $json['type'] = $type;
                    $json['url'] = "uploads/" . $name . '.' . $ext;
                } else {
                    $json['error'] = "Error: algo ha fallado";
                }
            }
        } else {
            $json['error'] = "Error: algo ha fallado";
        }

        return $json;
    }

}