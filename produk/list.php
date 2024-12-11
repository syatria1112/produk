<?php
header('Content-Type: application/json');
include "konekdb.php";

$stmt = $db->prepare("SELECT id, kode_produk, nama_produk, harga FROM produk");
$stmt->execute();
$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);
?>