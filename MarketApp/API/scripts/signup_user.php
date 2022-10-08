<?php
$response = array();//Response adında boş array
if(isset($_POST["full_name"]) && isset($_POST["email"]) && isset($_POST["phone"]) && isset($_POST["password"])){//Eger post methoud ile degerler gelmişse
    $full_name = $_POST["full_name"];//Degeri degişkene atarız
    $email = $_POST["email"];//Degeri degişkene atarız
    $phone = $_POST["phone"];//Degeri degişkene atarız
    $password = $_POST["password"];

    require_once __DIR__ . '/db_config.php';//conf verileri alınır
    $baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);//Veritabanı baglantısı saglanır
    if(!$baglanti){//eger baglantı yoksa
        die("Hatalı baglantı: ".mysqli_connect_error());//session oldurulur ve alt satırlar okunmaz
    }
    $sqlsorgu = "insert into User (full_name,email,phone,passwrod) values ('$full_name','$email','$phone','$password')";
   
    if(mysqli_query($baglanti,$sqlsorgu)){
        $response["success"] = 1;
        $response["message"] = "succesfuly inserted";
        echo json_encode($response);
    }else{
        $response["success"] = 0;
        $response["message"] = "not inserted err..";
        echo json_encode($response);
    }
}else{
    $response["success"] = 0;
    $response["message"] = "Required filed(s) is missing";
    echo json_encode($response);
}
mysqli_close($baglanti);
?>