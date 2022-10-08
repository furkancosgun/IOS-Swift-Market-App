<?php
if(isset($_POST["pass"]) && isset($_POST["email"])){
$email = $_POST["email"];
$pass = $_POST["pass"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$query = "select * from User where email = '$email' and password = '$pass'";
$result = mysqli_query($baglanti,$query);
if(mysqli_num_rows($result)>0){
    $response["user"] = array();//Array içine kişiler keyine ait bir dizi oluşturduk
    while($row = mysqli_fetch_assoc($result)){//her bir deger row içine gelir
        $user = array();//user adında boş array
        $user["userId"] = $row["id"];
        $user["email"] = $row["email"];
        $user["full_name"] = $row["full_name"];
        //array_push($response["user"],$user);//Array içine kişiler keyine gore degerler eklenir
        break;
    }
    $response["success"] = 1;//İşlem başarı degeri
    echo json_encode($user);//ekrana json dosyası olarak yazdırırız
}else{
    $response["success"] = 0;//İşlem başarı degeri
    $response["message"] = "User Not Found";
    echo json_encode($response);//ekrana json dosyası olarak yazdırırız
}
mysqli_close($baglanti);//Baglantı kapatılır
}else{
    $response["success"] = 0;
    $response["message"] = "Send me param";
    echo json_encode($response);
}
?>
