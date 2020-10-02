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
              display: flex;
              height: 320px;
              margin: 0 auto;
              width: 640px;
            }
            .left {
              background: #f4f4f4;
              height: calc(100% - 40px);
              top: 20px;
              position: relative;
              width: 50%;
              user-select: none;
            }
            .logo-container {
              margin-top: 40px;
            }
            .logo {
			  display: block;
			  margin-left: auto;
			  margin-right: auto;
			  width: 50%;
			  height: 100px;
            }
            .title {
              color: #4f4f4f;
			  font-size: 21px;
			  line-height: 1.5;
			  text-align: center;
			  margin-top: 14px;
            }
            .text {
              color: #4f4f4f;
              font-size: 14px;
              line-height: 1.5;
              margin: 22px 40px 0 40px;
              text-align: justify;
            }
            .right {
              background: #FFF;
              box-shadow: 0px 0px 40px 16px rgba(0,0,0,0.22);
              color: #F1F1F2;
              position: relative;
              width: 50%;
            }
            .form {
              margin: 36px 40px;
              position: absolute;
            }
            @keyframes gradient {
              0%{background-position:0 0}
              100%{background-position:100% 0}
            }
            .input-box {
			  position: relative;
			  display: flex;
			  flex-direction: row;
			  border-radius: 2px;
			  padding: 0.5rem 1rem 0.5rem;
			  width: 212px;
              background: #f4f4f4;
              box-shadow: 0 2px 12px 0 #0000004a;
			}
			.username {
			  margin: 12px auto 0 auto;
			}
			.password {
			  margin: 26px auto 0 auto;
			}
			.input-box:after {
			  content: "";
			  position: absolute;
			  left: 0px;
			  right: 0px;
			  bottom: 0px;
			  z-index: 999;
			  height: 2px;
			  border-bottom-left-radius: 2px;
			  border-bottom-right-radius: 2px;
			  background-position: 0% 0%;
			  background: linear-gradient(to right, #B294FF, #0A94D6, #054664, #0eb1ff, #B294FF, #0A94D6);
			  background-size: 500% auto;
			  animation: gradient 10s linear infinite;
			}
			.input-box input {
			  width: 212px;
			  color: #262626;
			  font-size: 18px;
			  line-height: 2.4rem;
			  vertical-align: middle;
              border: 0;
              background: transparent;
              font-family: inherit;
              caret-color: #0a94d6;
              outline: 0;
			}
			.input-box input::-webkit-input-placeholder {
			  color: #7881A1;
			}
            .submit {
              color: #555;
              margin-top: 44px;
              transition: color 300ms;
              border: 0;
              width: 100%;
              height: 44px;
              background-color: #f4f4f4;
              border-radius: 3px;
              font-weight: 600;
              font-family: inherit;
              font-size: 18px;
              box-shadow: 0 2px 12px 0 #0000004a;
            }
            .submit:focus {
              color: #0a94d6;
            }
            .submit:active {
              color: #939393;
            }
            .submit:hover {
              cursor: pointer;
            }
		</style>
	</head>
	<body>
		<div class="page">
          <div class="container">
            <div class="left">
              <div class="logo-container">
				 <img src="../js/plugin/rem/resources/images/logo.svg" alt="logo" class="logo">
              </div>
              <div class="title">Attachment Resources</div>
              <div class="text">Inicie sesión primero para obtener acceso al recurso solicitado</div>
            </div>
            <div class="right">
              <form action="/pfs/email/attachment?file=<%= request.getParameter("file") %>" class="form" method="post">
                <div class="input-box username">
                    <input class="" type="text" placeholder="Username" name="username"></input>
                </div>
                <div class="input-box password">
					<input class="" type="password" placeholder="Contraseña" name="password"></input>
				</div>
                <input type="submit" class="submit" value="Validar">
              </form>
            </div>
          </div>
        </div>
	</body>
</html>