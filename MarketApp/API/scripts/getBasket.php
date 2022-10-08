<?php
if(isset($_POST["userId"])){
$id = $_POST["userId"];
$response = array();//Boş array oluşturduk
require_once __DIR__ . '/db_config.php';//Conf verileri alındı
$baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabına baglanıldı
if(!$baglanti){//Eger baglantı yoksa
    die("Hatalı baglantı: ".mysqli_connect_error());//Hata mesaji ver
}
$sqlsorgu = "SELECT b.id, p.Product_name ,p.price,b.piece,b.product_id,p.img from Basket as b INNER JOIN Product as p on p.id = b.product_id WHERE b.user_Id = '$id'";//Sorguy oluşturuldu
$result = mysqli_query($baglanti,$sqlsorgu);//Sorgu çalıştırıldı
if(mysqli_num_rows($result)>0){//Sorgudan donen deger sayısı buyukse 0 dan 
    $response["basket"] = array();//Array içine kişiler keyine ait bir dizi oluşturduk
    while($row = mysqli_fetch_assoc($result)){//her bir deger row içine gelir
        $basket = array();//basket adında boş array
        $basket["id"] = $row["id"];//key value mantıgında degerler oluştrulur
        $basket["name"] = $row["Product_name"];//key value mantıgında degerler oluştrulu
        $basket["price"] = $row["price"];
        $basket["piece"] = $row["piece"];
        $basket["img"] = $row["img"];
        $basket["productId"] = $row["product_id"];
        array_push($response["basket"],$basket);//Array içine kişiler keyine gore degerler eklenir
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
