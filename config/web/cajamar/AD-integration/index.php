<?php
include('ntlm.php');
include('Crypt/RSA.php');

date_default_timezone_set('Europe/Madrid');
$remoteuser = apache_getenv("REMOTE_USER");
$timestamp = date('YmdHis');
$plaintext = $remoteuser.';'.$timestamp;
$rsa = new Crypt_RSA();
$rsa->loadKey(file_get_contents('/apache2/conf/keys/recovery.pk'));
$rsa->setEncryptionMode(CRYPT_RSA_ENCRYPTION_PKCS1);
$ciphertext = $rsa->encrypt($plaintext);
$url='/pfs/external/'.base64_encode($ciphertext).'/login';
?>

<html>
<body onLoad="javascript:document.form1.submit();" oncontextmenu="return false" onkeydown="return false">
<form action="<?php echo $url;?>" method="get" name="form1">
<input type="hidden" name="u" value="<?php echo $remoteuser; ?>">
<input type="hidden" name="t" value="<?php echo $timestamp; ?>">
</form>
</body>
</html>
