<? include 'ntlm.php';
$remoteuser = apache_getenv("REMOTE_USER");
$remoteaddr = apache_getenv("REMOTE_ADDR");
$remotedomain = apache_getenv("REMOTE_DOMAIN");
$host = $_SERVER['HTTP_HOST'];
$uri = '/ibi_apps/WFServlet?IBIF_ex=logonap';
$claveap = $_GET["claveap"];
?>
<html>
<head>
</head>
<body>
<!--BODY onLoad="javascript:document.form1.submit();" oncontextmenu="return
false" onkeydown="return false"-->
<form action="/ibi_apps/WFServlet" method=post name=form1>
<!-- type="hidden" -->
<input name="usuario" value="<?echo $remoteuser;?>">
<input name="claveap" value="<?echo $claveap;?>">
<input name="IBIWF_action" value="WF_SIGNON">
<input name="WF_SIGNON_MESSAGE" value="<?echo $uri;?>">
</form>
</body>
</html>
