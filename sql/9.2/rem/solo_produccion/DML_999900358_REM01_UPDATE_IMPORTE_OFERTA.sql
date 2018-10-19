--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181017
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1256
--## PRODUCTO=NO
--##
--## Finalidad: CAMBIAR EL IMPORTE DE VENTA 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'OFR_OFERTAS';
    V_TABLA_2 VARCHAR2(25 CHAR):= 'ACT_OFR';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1256';   

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

         T_TIPO_DATA('90043966', 452157.30), 
         T_TIPO_DATA('90022319', 405267.90)

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA; 
    
BEGIN	

FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
 				    FECHAMODIFICAR	 = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
	 			  , OFR_IMPORTE =  '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
				    WHERE OFR_NUM_OFERTA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_2||' SET 
	 			   ACT_OFR_IMPORTE =  '''||TRIM(V_TMP_TIPO_DATA(2))||''' 
				    WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_2);

	END LOOP;
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
