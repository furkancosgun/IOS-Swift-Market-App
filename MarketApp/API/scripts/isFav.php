<?php
if(isset($_POST["productId"]) && isset($_POST["userId"])){
$productId = $_POST["productId"];
$userId = $_POST["userId"];

$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$query = "select * from Favorites where userId = '$userId' and productId = '$productId'";
$isSuccess = mysqli_query($baglanti,$query);
if(mysqli_num_rows($isSuccess)>0){
    $response["success"] = 1;//İşlem başarı degeri
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}else{
    $response["success"] = 4;
    $response["message"] = "Error";
    echo json_encode($response);
}
mysqli_close($baglanti);//Baglantı kapatılır
}else{
    $response["success"] = 0;
    $response["message"] = "Send me param";
    echo json_encode($response);
}
?>
