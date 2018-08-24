--/*
--##########################################
--## AUTOR=Juanjo Arbona
--## FECHA_CREACION=20180622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1024
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica los emails de los usuarios
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USU_USUARIOS';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID_USUARIO NUMBER(16);
	V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-1024';
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('29472','bankiacee@tinsacertify.es'),
		T_TIPO_DATA('30172','sin_mail@haya.es'),
		T_TIPO_DATA('30173','sin_mail@haya.es'),
		T_TIPO_DATA('30174','sin_mail@haya.es'),
		T_TIPO_DATA('30175','sin_mail@haya.es'),
		T_TIPO_DATA('30176','sin_mail@haya.es'),
		T_TIPO_DATA('30177','sin_mail@haya.es'),
		T_TIPO_DATA('30178','sin_mail@haya.es'),
		T_TIPO_DATA('30179','sin_mail@haya.es'),
		T_TIPO_DATA('30180','sin_mail@haya.es'),
		T_TIPO_DATA('30181','sin_mail@haya.es'),
		T_TIPO_DATA('30182','sin_mail@haya.es'),
		T_TIPO_DATA('30183','sin_mail@haya.es'),
		T_TIPO_DATA('30184','sin_mail@haya.es'),
		T_TIPO_DATA('30185','sin_mail@haya.es'),
		T_TIPO_DATA('40124','sin_mail@haya.es'),
		T_TIPO_DATA('40125','sin_mail@haya.es'),
		T_TIPO_DATA('40126','sin_mail@haya.es'),
		T_TIPO_DATA('40127','sin_mail@haya.es'),
		T_TIPO_DATA('40128','sin_mail@haya.es'),
		T_TIPO_DATA('40129','sin_mail@haya.es'),
		T_TIPO_DATA('40130','sin_mail@haya.es'),
		T_TIPO_DATA('40131','sin_mail@haya.es'),
		T_TIPO_DATA('40132','sin_mail@haya.es'),
		T_TIPO_DATA('40133','sin_mail@haya.es'),
		T_TIPO_DATA('40134','sin_mail@haya.es'),
		T_TIPO_DATA('40135','sin_mail@haya.es'),
		T_TIPO_DATA('39159','sin_mail@haya.es'),
		T_TIPO_DATA('39160','sin_mail@haya.es'),
		T_TIPO_DATA('39161','sin_mail@haya.es'),
		T_TIPO_DATA('39162','GLABRADOR@GL.E.TELEFONICA.NET'),
		T_TIPO_DATA('39165','informatica@uniges.com'),
		T_TIPO_DATA('39166','sin_mail@haya.es'),
		T_TIPO_DATA('39167','sin_mail@haya.es'),
		T_TIPO_DATA('39168','sin_mail@haya.es'),
		T_TIPO_DATA('39169','sin_mail@haya.es'),
		T_TIPO_DATA('39170','danielmg@pinosxxi.es'),
		T_TIPO_DATA('39171','cmillan@gestinova99.es'),
		T_TIPO_DATA('39172','sin_mail@haya.es'),
		T_TIPO_DATA('39173','sin_mail@haya.es'),
		T_TIPO_DATA('39175','sin_mail@haya.es'),
		T_TIPO_DATA('39176','sin_mail@haya.es'),
		T_TIPO_DATA('39177','sin_mail@haya.es'),
		T_TIPO_DATA('39178','sin_mail@haya.es'),
		T_TIPO_DATA('39179','bankiahabitat@diagonalgest.com'),
		T_TIPO_DATA('39180','fernando.medina@acuerdosj.com'),
		T_TIPO_DATA('39181','sin_mail@haya.es'),
		T_TIPO_DATA('39182','sin_mail@haya.es'),
		T_TIPO_DATA('39184','sin_mail@haya.es'),
		T_TIPO_DATA('39185','sin_mail@haya.es'),
		T_TIPO_DATA('39187','vcobos@pons.es'),
		T_TIPO_DATA('39188','sin_mail@haya.es'),
		T_TIPO_DATA('39189','sin_mail@haya.es'),
		T_TIPO_DATA('39190','sin_mail@haya.es'),
		T_TIPO_DATA('39191','sin_mail@haya.es'),
		T_TIPO_DATA('39192','firmas.valencia@grupobc.com'),
		T_TIPO_DATA('39193','bankiacee@tinsacertify.es'),
		T_TIPO_DATA('39194','sin_mail@haya.es'),
		T_TIPO_DATA('39196','sin_mail@haya.es'),
		T_TIPO_DATA('39197','bankia.activos@ogf.es'),
		T_TIPO_DATA('39198','sin_mail@haya.es'),
		T_TIPO_DATA('39199','sin_mail@haya.es'),
		T_TIPO_DATA('39200','sin_mail@haya.es'),
		T_TIPO_DATA('39201','GLABRADOR@GL.E.TELEFONICA.NET'),
		T_TIPO_DATA('39204','informatica@uniges.com'),
		T_TIPO_DATA('39205','sin_mail@haya.es'),
		T_TIPO_DATA('39206','sin_mail@haya.es'),
		T_TIPO_DATA('39207','sin_mail@haya.es'),
		T_TIPO_DATA('39208','sin_mail@haya.es'),
		T_TIPO_DATA('39209','danielmg@pinosxxi.es'),
		T_TIPO_DATA('39210','cmillan@gestinova99.es'),
		T_TIPO_DATA('39211','sin_mail@haya.es'),
		T_TIPO_DATA('39212','sin_mail@haya.es'),
		T_TIPO_DATA('39214','sin_mail@haya.es'),
		T_TIPO_DATA('39215','sin_mail@haya.es'),
		T_TIPO_DATA('39216','sin_mail@haya.es'),
		T_TIPO_DATA('39217','sin_mail@haya.es'),
		T_TIPO_DATA('39218','bankiahabitat@diagonalgest.com'),
		T_TIPO_DATA('39219','sin_mail@haya.es'),
		T_TIPO_DATA('39220','sin_mail@haya.es'),
		T_TIPO_DATA('39221','sin_mail@haya.es'),
		T_TIPO_DATA('39223','sin_mail@haya.es'),
		T_TIPO_DATA('39224','sin_mail@haya.es'),
		T_TIPO_DATA('39226','vcobos@pons.es'),
		T_TIPO_DATA('39227','sin_mail@haya.es'),
		T_TIPO_DATA('39228','sin_mail@haya.es'),
		T_TIPO_DATA('39229','sin_mail@haya.es'),
		T_TIPO_DATA('39230','sin_mail@haya.es'),
		T_TIPO_DATA('39231','firmas.valencia@grupobc.com'),
		T_TIPO_DATA('39232','bankiacee@tinsacertify.es'),
		T_TIPO_DATA('39233','sin_mail@haya.es'),
		T_TIPO_DATA('39235','sin_mail@haya.es'),
		T_TIPO_DATA('39236','bankia.activos@ogf.es'),
		T_TIPO_DATA('39237','sin_mail@haya.es'),
		T_TIPO_DATA('39238','sin_mail@haya.es'),
		T_TIPO_DATA('39239','GLABRADOR@GL.E.TELEFONICA.NET'),
		T_TIPO_DATA('39242','informatica@uniges.com'),
		T_TIPO_DATA('39243','sin_mail@haya.es'),
		T_TIPO_DATA('39244','sin_mail@haya.es'),
		T_TIPO_DATA('39245','sin_mail@haya.es'),
		T_TIPO_DATA('39246','sin_mail@haya.es'),
		T_TIPO_DATA('39247','danielmg@pinosxxi.es'),
		T_TIPO_DATA('39248','cmillan@gestinova99.es'),
		T_TIPO_DATA('39249','sin_mail@haya.es'),
		T_TIPO_DATA('39250','sin_mail@haya.es'),
		T_TIPO_DATA('39252','sin_mail@haya.es'),
		T_TIPO_DATA('39253','sin_mail@haya.es'),
		T_TIPO_DATA('39254','sin_mail@haya.es'),
		T_TIPO_DATA('39255','sin_mail@haya.es'),
		T_TIPO_DATA('39256','bankiahabitat@diagonalgest.com'),
		T_TIPO_DATA('39257','sin_mail@haya.es'),
		T_TIPO_DATA('39258','sin_mail@haya.es'),
		T_TIPO_DATA('39259','sin_mail@haya.es'),
		T_TIPO_DATA('39261','sin_mail@haya.es'),
		T_TIPO_DATA('39262','sin_mail@haya.es'),
		T_TIPO_DATA('39264','vcobos@pons.es'),
		T_TIPO_DATA('39265','sin_mail@haya.es'),
		T_TIPO_DATA('39266','sin_mail@haya.es'),
		T_TIPO_DATA('39267','sin_mail@haya.es'),
		T_TIPO_DATA('39268','sin_mail@haya.es'),
		T_TIPO_DATA('39269','firmas.valencia@grupobc.com'),
		T_TIPO_DATA('39270','bankiacee@tinsacertify.es'),
		T_TIPO_DATA('39271','sin_mail@haya.es'),
		T_TIPO_DATA('39273','sin_mail@haya.es'),
		T_TIPO_DATA('40311','sin_mail@haya.es'),
		T_TIPO_DATA('75394','pbcreosbankia@haya.es'),
		T_TIPO_DATA('75395','pbcreossareb@haya.es'),
		T_TIPO_DATA('75396','pbcreosliberbank@haya.es')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_ID  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' INTO V_ID_USUARIO;
        
        IF V_ID_USUARIO < 1 THEN
        
        	DBMS_OUTPUT.PUT_LINE('[WARNING] NO EXISTE EL USUARIO '''||TRIM(V_TMP_TIPO_DATA(1))||''' NO SE HACE NADA!');
        	
        ELSE				
	          
	          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO ');
	       	  V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.'||V_TEXT_TABLA||' '||
	                    'SET USU_MAIL = '''||TRIM(V_TMP_TIPO_DATA(2))||''' , USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE WHERE USU_ID = '||TRIM(V_TMP_TIPO_DATA(1))||'';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
