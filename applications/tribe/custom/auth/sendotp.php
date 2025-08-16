<?php
require __DIR__ . '/../../_init.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

$api = new \Tribe\API;

if ($_SERVER['REQUEST_METHOD'] === 'POST')
  $_POST = $api->requestBody;

header('Content-Type: application/json');

if (($_ENV['MAILPACE_SERVER_TOKEN'] ?? false) && ($_POST['otp'] ?? false)) {
  //Create an instance; passing `true` enables exceptions
  $mail = new PHPMailer(true);

  try {
      //Server settings
      //$mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
      $mail->isSMTP();                                            //Send using SMTP
      $mail->Host       = 'smtp.mailpace.com';                     //Set the SMTP server to send through
      $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
      $mail->Username   = $_ENV['MAILPACE_SERVER_TOKEN'];                     //SMTP username
      $mail->Password   = $_ENV['MAILPACE_SERVER_TOKEN'];                               //SMTP password
      //$mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
      $mail->Port       = 25;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

      //Recipients
      $mail->setFrom('no-reply@'.$_ENV['MAILPACE_DOMAIN'].'', 'Tribe');
      $mail->addAddress($_POST['email']);     //Add a recipient

      //Content
      $mail->isHTML(true);                                  //Set email format to HTML
      $mail->Subject = 'Your OTP is '.$_POST['otp'];
      $mail->Body    = '<h1 align="center">'.$_POST['otp'].' is your OTP</h1><div align="center"><img src="https://'.$_ENV['MAILPACE_DOMAIN'].'/favicon.png" width="200" /></div>';

      $mail->send();

      echo json_encode(array("success"=>true));

  } catch (Exception $e) {

    echo json_encode(array("error"=>"Message could not be sent. Mailer Error: {$mail->ErrorInfo}"));

  }
} else {

  echo json_encode(array("error"=>"SMTP not configured or OTP not passed."));

}
?>