<?php
if(isset($_POST["text"]) && isset($_POST["user_id"]) && isset($_POST["product_id"])){
$text = $_POST["text"];
$user_id = $_POST["user_id"];
$product_id = $_POST["product_id"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$sqlsorgu = "INSERT INTO Comments (product_id,user_id,text) values ('$product_id','$user_id','$text')";//Sorguy oluşturuldu
$result = mysqli_query($baglanti,$sqlsorgu);//Sorgu çalıştırıldı
if(mysqli_num_rows($result)>0){//Sorgudan donen deger sayısı buyukse 0 dan 
    $response["success"] = 1;//İşlem başarı degeri
    $response["message"] = "Comment saved";
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}else{
    $response["success"] = 0;
    $response["message"] = "No data found";
    echo json_encode($response);
}
mysqli_close($baglanti);//Baglantı kapatılır
}else{
    $response["success"] = 0;
    $response["message"] = "Send me param";
    echo json_encode($response);
}
?>
