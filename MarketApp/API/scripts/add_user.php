<?php
if(isset($_POST["fullname"]) && isset($_POST["email"]) && isset($_POST["phone"]) && isset($_POST["pass"])){
$fullname = $_POST["fullname"];
$email = $_POST["email"];
$phone = $_POST["phone"];
$pass = $_POST["pass"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$query = "select * from User where email = '$email' or phone = '$phone'";
$is_exists = mysqli_query($baglanti,$query);
if(mysqli_num_rows($is_exists)>0){
    $response["success"] = 4;//İşlem başarı degeri
    $response["message"] = "User already exists";
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}else{
$sqlsorgu = "INSERT INTO User (full_name,email,phone,password) values ('$fullname','$email','$phone','$pass')";//Sorguy oluşturuldu
$result = mysqli_query($baglanti,$sqlsorgu);//Sorgu çalıştırıldı
if(mysqli_num_rows($result)>0){//Sorgudan donen deger sayısı buyukse 0 dan 
    $response["success"] = 1;//İşlem başarı degeri
    $response["message"] = "User saved";
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}else{
    $response["success"] = 0;
    $response["message"] = "Bruh";
    echo json_encode($response);
}
}
mysqli_close($baglanti);//Baglantı kapatılır
}else{
    $response["success"] = 0;
    $response["message"] = "Send me param";
    echo json_encode($response);
}
?>