<?php
if(isset($_POST["id"]) && isset($_POST["piece"])){
$id = $_POST["id"];
$piece = $_POST["piece"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
if($piece > 0){
    $sqlsorgu = "update Basket set piece = '$piece' where id = $id";
}else{
    $sqlsorgu = "delete from Basket where id = $id";//Sorguy oluşturuldu
}
$result = mysqli_query($baglanti,$sqlsorgu);//Sorgu çalıştırıldı
if($result){//Sorgudan donen deger sayısı buyukse 0 dan
    $response["success"] = 1;//İşlem başarı degeri
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}else{
    $response["success"] = 0;
    $response["message"] = "No data found";
    echo json_encode($response);
}
mysqli_close($baglanti);//Baglantı kapatılır
}else{
    $response["success"] = 0;
    $response["message"] = "Send me parameters";
    echo json_encode($response);
}
?>
