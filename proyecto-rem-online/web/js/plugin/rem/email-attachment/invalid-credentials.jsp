<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta charset='UTF-8'>
		<meta name="viewport" content="width=device-width, user-scalable=no" />
		<title>REM Attachment Resources</title>
		<link rel="shortcut icon" href="../js/plugin/rem/resources/images/favicon.png" type="image/png">
		<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
		<style>
			body {
			  background: white;
			  margin: 0;
			  font-family: 'Montserrat', sans-serif;
			}
			.page {
			  padding: 20px;
			  background-image: url(../js/plugin/rem/resources/images/fondologin-min.jpg);
			  background-repeat: no-repeat;
			  background-size: cover;
			  display: flex;
			  flex-direction: column;
			  height: calc(100% - 40px);
			  position: absolute;
			  place-content: center;
			  width: calc(100% - 40px);
			}
			.container {
			  display: block;
			  height: 320px;
			  margin: 0 auto;
			  width: 640px;
			  background: #FFF;
			  box-shadow: 0px 0px 40px 16px rgba(0,0,0,0.22);
			}
			h1 {
			  font-weight: 600;
              text-align: center;
              margin: 50px 40px 0 40px;
              color: #3e3e3e;
            }
            p {
              text-align: left;
              margin: 60px 50px 0 50px;
              color: #464646;
            }
            ul {
              color: #464646;
              padding: 0 100px;
            }
		</style>
	</head>
	<body>
		<div class="page">
			<div class="container">
				<h1>🚷 Acceso no autorizado</h1>
				<p>Las credenciales introducidas no son válidas por alguno de los siguientes motivos:</p>
				<ul>
					<li>No se ha encontrado un usuario con ese username</li>
					<li>La contraseña no coincide</li>
					<li>El usuario se encuentra dado de baja del sistema</li>
					<li>El usuario no se encuentra habilitado en el sistema</li>
					<li>Sus credenciales han expirado y deben renovarse</li>
				</ul>
			</div>
		</div>
	</body>
</html>