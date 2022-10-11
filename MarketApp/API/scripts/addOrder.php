<?php
if(isset($_POST["orders"])){
$orders = $_POST["orders"];
$userId = $_POST["userId"];
$total = $_POST["total"];
$loct = $_POST["location"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$query = "Insert Into Orders (userId,orders,price,location) values ('$userId','$orders','$total','$loct')";
$isSuccess = mysqli_query($baglanti,$query);
if($isSuccess){
    $response["success"] = 1;//İşlem başarı degeri
    $response["message"] = "Added to Orders";
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}else{
    $response["success"] = 0;
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
