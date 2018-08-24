--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180719
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMVIP-1066
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR) := 'ACT_GES_DIST_GESTORES';
    V_AUX NUMBER(16);
    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_SQL_INSERT VARCHAR2(32000 CHAR); 
    V_USUARIO VARCHAR(50 CHAR):= 'REMVIP-1066'; -- Vble. Nombre del usuario de las variables de auditoria.
   
   
	TIPO_GESTOR VARCHAR2(200 CHAR);
	CODIGO_GESTOR VARCHAR2(200 CHAR);
	CODIGO_PROVINCIA VARCHAR2(200 CHAR);
	CODIGO_MUNICIPIO VARCHAR2(200 CHAR);
	USERNAME_GESTOR VARCHAR2(200 CHAR);
	NOMBRE_GESTOR VARCHAR2(200 CHAR);

   
   
    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
    
		T_TIPO_DATA_2('GCOMSIN','01','4','','aalonso','Alberto Alonso Ortíz'),
		T_TIPO_DATA_2('GCOMSIN','01','11','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','14','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','18','','bgonzalezn','Benito Gonzalez Noguera'),
		T_TIPO_DATA_2('GCOMSIN','01','21','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','23','','bgonzalezn','Benito Gonzalez Noguera'),
		T_TIPO_DATA_2('GCOMSIN','01','29','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','41','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','22','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','44','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','50','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','7','','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMSIN','01','35','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','38','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','39','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','2','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','13','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','16','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','19','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','45','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','5','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','9','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','24','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','34','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','37','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','40','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','42','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','47','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','49','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','8','','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMSIN','01','17','','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMSIN','01','25','','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMSIN','01','43','','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMSIN','01','3','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','12','','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMSIN','01','46','','hgimenez','Hector Gimenez Bea'),
		T_TIPO_DATA_2('GCOMSIN','01','6','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','10','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','15','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','27','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','32','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','36','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','28','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','30','','bgonzalezn','Benito Gonzalez Noguera'),
		T_TIPO_DATA_2('GCOMSIN','01','31','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','1','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','20','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','48','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','33','','ccapdevila','Cristina Capdevila Colomer'),
		T_TIPO_DATA_2('GCOMSIN','01','26','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','51','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('GCOMSIN','01','52','','pblanco','Paola Blanco Gimeno'),
		T_TIPO_DATA_2('SCOMSIN','01','4','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','11','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','14','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','18','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','21','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','23','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','29','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','41','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','22','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','44','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','50','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','7','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','35','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','38','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','39','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','2','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','13','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','16','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','19','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','45','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','5','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','9','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','24','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','34','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','37','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','40','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','42','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','47','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','49','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','8','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','17','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','25','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','43','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','3','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','12','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','46','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','6','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','10','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','15','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','27','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','32','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','36','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','28','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','30','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','31','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','1','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','20','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','48','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','33','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','26','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','51','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('SCOMSIN','01','52','','omora','Oscar Mora Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','7','','tbuendia','Tomás Buendía Feixas'),
		T_TIPO_DATA_2('GCOMRET','01','8','','tbuendia','Tomás Buendía Feixas'),
		T_TIPO_DATA_2('GCOMRET','01','17','','tbuendia','Tomás Buendía Feixas'),
		T_TIPO_DATA_2('GCOMRET','01','25','','tbuendia','Tomás Buendía Feixas'),
		T_TIPO_DATA_2('GCOMRET','01','43','','tbuendia','Tomás Buendía Feixas'),
		T_TIPO_DATA_2('GCOMRET','01','35','','ecabrera','Emilio Cabrera Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','38','','ecabrera','Emilio Cabrera Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','4','04001','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04002','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04003','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04007','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04009','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04010','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04011','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04013','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04015','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04024','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04026','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04027','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04029','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04030','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04032','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04038','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04041','jhernandez','Juan Hernandez Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','4','04043','jhernandez','Juan Hernandez Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','4','04046','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04047','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04049','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04050','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04051','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04052','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04054','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04055','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04057','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04059','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04060','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04064','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04065','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04066','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04067','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04074','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04077','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04078','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04079','jhernandez','Juan Hernandez Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','4','04081','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04086','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04088','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04091','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04093','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04095','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04101','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04102','jhernandez','Juan Hernandez Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','4','04113','mcumbreras','Margarita Cumbreras Manga'),
		T_TIPO_DATA_2('GCOMRET','01','4','04901','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04902','bcanadas','Basilio Cañadas Rodriguez'),
		T_TIPO_DATA_2('GCOMRET','01','4','04903','jhernandez','Juan Hernandez Cabrera'),
		T_TIPO_DATA_2('GCOMRET','01','4','','spalma','Seila Palma Mendoza'),
		T_TIPO_DATA_2('GCOMRET','01','18','','alirola','Antonio Lirola Tesón'),
		T_TIPO_DATA_2('GCOMRET','01','23','','alirola','Antonio Lirola Tesón'),
		T_TIPO_DATA_2('GCOMRET','01','30','30001','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30002','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30003','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30004','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30006','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30007','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30009','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30010','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30011','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30012','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30013','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30014','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30015','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30017','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30018','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30019','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30020','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30022','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30024','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30025','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30026','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30027','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30028','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30029','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30031','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30032','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30033','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30034','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30038','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30039','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','30042','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30043','emoreno','Estefanía Moreno Martinez'),
		T_TIPO_DATA_2('GCOMRET','01','30','30901','aromera','Antonio Germán Romera Linares'),
		T_TIPO_DATA_2('GCOMRET','01','30','','mguitart','María Cristina Guitart Ramos'),
		T_TIPO_DATA_2('GCOMRET','01','11','11004','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','11','11022','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','11','11035','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','11','11038','eespinosa','Estela Espinosa Morales'),
		T_TIPO_DATA_2('GCOMRET','01','11','','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','14','','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','21','','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29001','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29010','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29023','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29025','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29032','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29041','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29051','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29054','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29055','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29059','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29067','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29068','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29069','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29070','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29072','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29076','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29082','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','29088','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29089','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','29','29901','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','29','','eespinosa','Estela Espinosa Morales'),
		T_TIPO_DATA_2('GCOMRET','01','41','','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','6','','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','10','','egalan','Elena Galán Díaz'),
		T_TIPO_DATA_2('GCOMRET','01','51','','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','52','','rdelaplaza','Ricardo de la Plaza Ramirez'),
		T_TIPO_DATA_2('GCOMRET','01','3','03005','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03012','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03013','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03015','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03019','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03023','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03024','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03025','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03034','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03043','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03044','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03049','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03053','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03055','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03058','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03059','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03061','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03062','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03064','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03065','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03066','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03070','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03076','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03077','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03078','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03088','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03089','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03093','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03096','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03099','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03104','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03105','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03109','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03111','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03113','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03114','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03116','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03118','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03120','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03121','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03123','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03129','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03133','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03140','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03902','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03903','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','03904','pmorera','Purificación Morera Garnateo'),
		T_TIPO_DATA_2('GCOMRET','01','3','','fcarrasco','Francisco José Carrasco Acedo'),
		T_TIPO_DATA_2('GCOMRET','01','12','','ncolom','Nuria Colom Jaime'),
		T_TIPO_DATA_2('GCOMRET','01','46','46002','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46004','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46005','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46006','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46007','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46008','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46009','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46010','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46013','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46014','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46015','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46019','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46020','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46021','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46022','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46024','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46025','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46026','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46029','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46031','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46032','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46034','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46035','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46039','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46042','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46046','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46047','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46048','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46054','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46055','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46057','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46059','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46060','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46061','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46062','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46063','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46065','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46066','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46068','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46069','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46072','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46073','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46074','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46075','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46081','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46085','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46090','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46093','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46094','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46096','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46098','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46102','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46104','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46105','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46107','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46109','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46110','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46113','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46118','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46121','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46123','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46124','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46125','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46126','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46127','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46131','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46132','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46134','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46137','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46138','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46139','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46140','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46143','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46145','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46146','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46150','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46151','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46153','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46154','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46155','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46156','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46159','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46163','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46164','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46165','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46166','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46169','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46170','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46171','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46172','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46173','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46174','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46175','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46176','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46177','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46179','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46180','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46181','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46183','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46184','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46185','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46186','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46187','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46188','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46189','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46192','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46193','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46194','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46195','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46196','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46197','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46198','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46199','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46200','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46204','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46205','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46207','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46208','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46210','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46211','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46212','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46215','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46217','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46218','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46220','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46221','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46223','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46225','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46230','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46231','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46233','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46235','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46237','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46238','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46240','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46243','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46244','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46248','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46250','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46251','vgardel','Vanesa Gardel Domingo'),
		T_TIPO_DATA_2('GCOMRET','01','46','46255','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','46260','dmartin','Daniel Martín Gutierrez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46904','mfabra','María Rosario Fabra Heredia'),
		T_TIPO_DATA_2('GCOMRET','01','46','','azanon','Angel Zanón García'),
		T_TIPO_DATA_2('GCOMRET','01','22','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','44','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','50','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','39','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','2','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','13','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','16','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','19','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','45','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','5','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','9','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','24','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','34','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','37','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','40','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','42','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','47','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','49','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','15','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','27','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','32','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','36','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','28','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','31','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','1','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','20','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','48','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','33','','ofernandez','Oscar Fernandez Fraile'),
		T_TIPO_DATA_2('GCOMRET','01','26','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('GCOMRET','01','46','46028','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46030','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46058','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46082','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46101','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46103','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46120','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46122','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('GCOMRET','01','46','46245','pmanez','Paloma Mañez Alarcón'),
		T_TIPO_DATA_2('SCOMRET','01','7','','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('SCOMRET','01','8','','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('SCOMRET','01','17','','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('SCOMRET','01','25','','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('SCOMRET','01','43','','emaurizot','Elisabeth Maurizot Pont'),
		T_TIPO_DATA_2('SCOMRET','01','35','','ecabrera','Emilio Cabrera Cabrera'),
		T_TIPO_DATA_2('SCOMRET','01','38','','ecabrera','Emilio Cabrera Cabrera'),
		T_TIPO_DATA_2('SCOMRET','01','4','04001','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04002','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04003','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04007','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04009','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04010','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04011','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04013','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04015','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04024','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04026','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04027','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04029','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04030','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04032','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04038','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04041','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04043','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04046','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04047','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04049','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04050','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04051','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04052','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04054','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04055','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04057','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04059','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04060','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04064','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04065','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04066','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04067','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04074','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04077','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04078','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04079','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04081','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04086','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04088','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04091','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04093','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04095','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04101','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04102','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04113','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04901','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04902','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','04903','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','4','','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','18','','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','23','','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30001','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30002','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30003','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30004','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30006','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30007','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30009','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30010','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30011','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30012','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30013','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30014','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30015','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30017','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30018','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30019','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30020','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30022','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30024','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30025','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30026','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30027','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30028','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30029','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30031','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30032','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30033','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30034','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30038','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30039','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30042','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30043','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','30901','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','30','','falonsor','Francisco Alonso Rodriguez'),
		T_TIPO_DATA_2('SCOMRET','01','11','11004','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','11','11022','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','11','11035','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','11','11038','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','11','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','14','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','21','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29001','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29010','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29023','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29025','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29032','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29041','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29051','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29054','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29055','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29059','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29067','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29068','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29069','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29070','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29072','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29076','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29082','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29088','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29089','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','29901','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','29','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','41','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','6','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','10','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','51','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','52','','fmalvarez','Francisco Manuel Malvarez Mañas'),
		T_TIPO_DATA_2('SCOMRET','01','3','03005','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03012','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03013','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03015','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03019','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03023','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03024','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03025','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03034','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03043','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03044','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03049','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03053','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03055','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03058','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03059','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03061','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03062','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03064','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03065','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03066','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03070','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03076','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03077','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03078','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03088','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03089','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03093','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03096','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03099','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03104','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03105','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03109','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03111','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03113','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03114','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03116','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03118','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03120','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03121','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03123','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03129','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03133','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03140','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03902','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03903','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','03904','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','3','','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','12','','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46002','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46004','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46005','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46006','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46007','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46008','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46009','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46010','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46013','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46014','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46015','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46019','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46020','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46021','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46022','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46024','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46025','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46026','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46029','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46031','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46032','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46034','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46035','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46039','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46042','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46046','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46047','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46048','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46054','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46055','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46057','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46059','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46060','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46061','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46062','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46063','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46065','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46066','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46068','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46069','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46072','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46073','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46074','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46075','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46081','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46085','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46090','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46093','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46094','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46096','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46098','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46102','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46104','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46105','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46107','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46109','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46110','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46113','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46118','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46121','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46123','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46124','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46125','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46126','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46127','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46131','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46132','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46134','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46137','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46138','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46139','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46140','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46143','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46145','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46146','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46150','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46151','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46153','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46154','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46155','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46156','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46159','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46163','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46164','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46165','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46166','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46169','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46170','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46171','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46172','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46173','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46174','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46175','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46176','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46177','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46179','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46180','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46181','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46183','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46184','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46185','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46186','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46187','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46188','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46189','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46192','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46193','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46194','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46195','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46196','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46197','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46198','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46199','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46200','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46204','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46205','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46207','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46208','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46210','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46211','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46212','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46215','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46217','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46218','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46220','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46221','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46223','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46225','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46230','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46231','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46233','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46235','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46237','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46238','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46240','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46243','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46244','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46248','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46250','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46251','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46255','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46260','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','46904','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','46','','jvila','Jose Manuel Vila Oltra'),
		T_TIPO_DATA_2('SCOMRET','01','22','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','44','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','50','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','39','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','2','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','13','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','16','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','19','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','45','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','5','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','9','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','24','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','34','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','37','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','40','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','42','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','47','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','49','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','15','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','27','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','32','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','36','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','28','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','31','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','1','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','20','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','48','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','33','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','26','','msanchezf','Mercedes Sanchez Fernandez'),
		T_TIPO_DATA_2('SCOMRET','01','46','46028','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46030','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46058','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46082','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46101','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46103','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46120','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46122','',''),
		T_TIPO_DATA_2('SCOMRET','01','46','46245','','')
); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;


BEGIN 
	
	V_MSQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';	
    
	EXECUTE IMMEDIATE V_MSQL INTO V_AUX;

	IF V_AUX = 1 THEN 
	
		DBMS_OUTPUT.PUT_LINE('[INICIO]');
        
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR in (''GCOMRET'',''SCOMRET'',''GCOMSIN'',''SCOMSIN'') AND BORRADO = 0 AND COD_CARTERA = 1';
        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        
		EXECUTE IMMEDIATE V_MSQL INTO V_AUX;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a eliminar '||V_AUX||' de la tabla '||V_TABLA||' ');
			
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET BORRADO = 1 WHERE TIPO_GESTOR in (''GCOMRET'',''SCOMRET'',''GCOMSIN'',''SCOMSIN'') AND BORRADO = 0 AND COD_CARTERA = 1';
        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se borran los gestores anteriores en la tabla auxiliar '||V_TABLA||'');
			
		 -- LOOP-----------------------------------------------------------------
			DBMS_OUTPUT.PUT_LINE('[INFO] Empieza la inserción en la tabla '||V_TABLA||'');
    
    		FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
            
			  LOOP
			              
				V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
		               
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA_2(5))||'''';
                                                
                EXECUTE IMMEDIATE V_MSQL INTO V_AUX;
				
            IF V_AUX = 1 THEN
                
                TIPO_GESTOR := TRIM(V_TMP_TIPO_DATA_2(1));
                
				IF TIPO_GESTOR = '' THEN
					
					TIPO_GESTOR := NULL;
				
				ELSE 
				
					TIPO_GESTOR := ''''||TRIM(V_TMP_TIPO_DATA_2(1))||'''';
				
				END IF; 
                                
				CODIGO_GESTOR := TRIM(V_TMP_TIPO_DATA_2(2));
				
				IF CODIGO_GESTOR = '' THEN
					
					CODIGO_GESTOR := NULL;
				
				ELSE 
				
					CODIGO_GESTOR := ''''||TRIM(V_TMP_TIPO_DATA_2(2))||'''';
				
				END IF; 
			
				CODIGO_PROVINCIA := TRIM(V_TMP_TIPO_DATA_2(3));
				
				IF CODIGO_PROVINCIA = '' THEN
					
					CODIGO_PROVINCIA := NULL;
				
				ELSE 
				
					CODIGO_PROVINCIA := ''''||TRIM(V_TMP_TIPO_DATA_2(3))||'''';
					
				END IF; 
				
				CODIGO_MUNICIPIO := TRIM(V_TMP_TIPO_DATA_2(4));
				
				IF CODIGO_MUNICIPIO = '' THEN
					
					CODIGO_MUNICIPIO := NULL;
				
				ELSE 
				
					CODIGO_MUNICIPIO := ''''||TRIM(V_TMP_TIPO_DATA_2(4))||'''';
				
				END IF; 
				
				USERNAME_GESTOR := TRIM(V_TMP_TIPO_DATA_2(5));
				
				IF USERNAME_GESTOR = '' THEN
					
					USERNAME_GESTOR := NULL;
				
				ELSE 
				
					USERNAME_GESTOR := ''''||TRIM(V_TMP_TIPO_DATA_2(5))||'''';	
				
				END IF;  
				
				NOMBRE_GESTOR := V_TMP_TIPO_DATA_2(6);
				
				IF NOMBRE_GESTOR = '' THEN
					
					NOMBRE_GESTOR := NULL;
				ELSE 
				
					NOMBRE_GESTOR := ''''||V_TMP_TIPO_DATA_2(6)||'''';
				
				END IF;  
              
                      V_SQL_INSERT := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                                        ID                          
                                        ,TIPO_GESTOR                     
                                        ,COD_CARTERA                             
                                        ,COD_PROVINCIA                          
                                        ,COD_MUNICIPIO                                                  
                                        ,USERNAME                  
                                        ,NOMBRE_USUARIO   
                                        ,VERSION                 
                                        ,USUARIOCREAR             
                                        ,FECHACREAR 
                                        ) VALUES (
                                          S_'||V_TABLA||'.NEXTVAL
                                        , '||TIPO_GESTOR||'
                                        , '||CODIGO_GESTOR||'
                                        , '||CODIGO_PROVINCIA||'
                                        , '||CODIGO_MUNICIPIO||'
                                        , '||USERNAME_GESTOR||'
                                        , '||NOMBRE_GESTOR||'
                                        ,1
                                        , '''||V_USUARIO||'''
                                        , SYSDATE
                                        )';
                                                                                                        
                    EXECUTE IMMEDIATE V_SQL_INSERT;
                             
                    DBMS_OUTPUT.PUT_LINE('[INFO] Registro '||I||' insertado.');
                   
                ELSE 
                
                    DBMS_OUTPUT.PUT_LINE('[ERROR] El usuario '||V_TMP_TIPO_DATA_2(5)||' no existe en la fila '||I||' ');
                    
                END IF;
                          
			END LOOP;

	ELSE 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] No se ha iniciado la inserción');		
	
    END IF;
	
    COMMIT;
   
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        
        ROLLBACK;
        RAISE;          
END;
/
EXIT

