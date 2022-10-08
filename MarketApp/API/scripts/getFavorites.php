<?php
if(isset($_POST["userId"])){
$id = $_POST["userId"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$sqlsorgu = "SELECT Product.* FROM `Favorites` 
INNER JOIN Product on Product.id = Favorites.productId
    WHERE userId = '$id'";//Sorguy oluşturuldu
$result = mysqli_query($baglanti,$sqlsorgu);//Sorgu çalıştırıldı
if(mysqli_num_rows($result)>0){//Sorgudan donen deger sayısı buyukse 0 dan 
    $response["favorites"] = array();//Array içine kişiler keyine ait bir dizi oluşturduk
    while($row = mysqli_fetch_assoc($result)){//her bir deger row içine gelir
        $favorites = array();//favorites adında boş array
        $favorites["id"] = $row["id"];//key value mantıgında degerler oluştrulur
        $favorites["name"] = $row["Product_name"];//key value mantıgında degerler oluştrulur
        $favorites["category"] = $row["category_name"];
        $favorites["price"] = $row["price"];
        $favorites["img"] = $row["img"];
        array_push($response["favorites"],$favorites);//Array içine kişiler keyine gore degerler eklenir
    }
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
