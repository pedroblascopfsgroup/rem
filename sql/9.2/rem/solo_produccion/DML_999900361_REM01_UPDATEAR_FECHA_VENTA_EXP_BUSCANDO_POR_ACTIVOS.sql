--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra	
--## FECHA_CREACION=20181018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2273
--## PRODUCTO=NO
--##
--## Finalidad: CAMBIAR FECHA VENTA DE EXPEDIENTES BUSCANDO POR ACTIVOS
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-2273';    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
-------------- NUM ACTIVO , FECHA VENTA
        T_TIPO_DATA('6032908','28/12/2017'),
		T_TIPO_DATA('6030411','28/12/2017'),
		T_TIPO_DATA('6033802','28/12/2017'),
		T_TIPO_DATA('6525365','29/12/2017'),
		T_TIPO_DATA('6806583','29/12/2017'),
		T_TIPO_DATA('6028501','31/01/2018'),
		T_TIPO_DATA('6030125','19/01/2018'),
		T_TIPO_DATA('6032191','30/01/2018'),
		T_TIPO_DATA('6035865','15/01/2018'),
		T_TIPO_DATA('6037349','22/01/2018'),
		T_TIPO_DATA('6037529','15/01/2018'),
		T_TIPO_DATA('6038806','19/01/2018'),
		T_TIPO_DATA('6076017','12/01/2018'),
		T_TIPO_DATA('6077838','12/01/2018'),
		T_TIPO_DATA('6077418','16/01/2018'),
		T_TIPO_DATA('6083439','12/01/2018'),
		T_TIPO_DATA('6135206','19/01/2018'),
		T_TIPO_DATA('6520248','31/01/2018'),
		T_TIPO_DATA('6747194','31/01/2018'),
		T_TIPO_DATA('6786807','31/01/2018'),
		T_TIPO_DATA('6811776','09/01/2018'),
		T_TIPO_DATA('6844257','26/01/2018'),
		T_TIPO_DATA('6886828','25/01/2018'),
		T_TIPO_DATA('6891278','10/01/2018')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
 				    FECHAMODIFICAR	 = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
	 			  , ECO_FECHA_VENTA = TO_DATE('''||TRIM(V_TMP_TIPO_DATA(2))||''',''DD/MM/YYYY'') 
				    WHERE ECO_NUM_EXPEDIENTE = (
								SELECT ECO.ECO_NUM_EXPEDIENTE 
									FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
									INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.DD_EEC_CODIGO = ''08''
									INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
									INNER JOIN '||V_ESQUEMA||'.ACT_OFR AFR ON AFR.OFR_ID = OFR.OFR_ID
									INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AFR.ACT_ID = ACT.ACT_ID 
									WHERE  ACT.ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') 
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
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

