<?php
header('Content-Type: application/json');
include "konekdb.php";

$id = $_POST['id'];
$kode_produk = $_POST['kode_produk'];
$nama_produk = $_POST['nama_produk'];
$harga = $_POST['harga'];

$stmt = $db->prepare("UPDATE produk SET kode_produk = ?, nama_produk = ?, harga  =  ? WHERE id = ?");
$result = $stmt -> execute([$kode_produk, $nama_produk, $harga, $id]);


echo json_encode([
    'success' => $result
]);
?>