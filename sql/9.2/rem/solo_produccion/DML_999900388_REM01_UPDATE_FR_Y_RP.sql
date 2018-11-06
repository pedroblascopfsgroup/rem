--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2305
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE Nº FINCA REGISTRAL Y Nº REGISTRO DE LA PROPIEDAD
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2305';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    ------ 	 		NIF , PVE_ID
    T_TIPO_DATA('70959','6136','1'),
	T_TIPO_DATA('70960','6206','1'),
	T_TIPO_DATA('136911','6165','1'),
	T_TIPO_DATA('136978','6183','1'),
	T_TIPO_DATA('136980','6190','1'),
	T_TIPO_DATA('136982','6196','1'),
	T_TIPO_DATA('136983','6198','1'),
	T_TIPO_DATA('137022','6168','1'),
	T_TIPO_DATA('137032','6195','1'),
	T_TIPO_DATA('137037','6215','1'),
	T_TIPO_DATA('137133','6200','1'),
	T_TIPO_DATA('137420','6189','1'),
	T_TIPO_DATA('137425','6239','1'),
	T_TIPO_DATA('137541','6162','1'),
	T_TIPO_DATA('137552','6199','1'),
	T_TIPO_DATA('137556','6236','1'),
	T_TIPO_DATA('137557','6238','1'),
	T_TIPO_DATA('137559','6246','1'),
	T_TIPO_DATA('137560','6249','1'),
	T_TIPO_DATA('138016','6257','1'),
	T_TIPO_DATA('141517','6135','1'),
	T_TIPO_DATA('141740','6201','1'),
	T_TIPO_DATA('141750','6235','1'),
	T_TIPO_DATA('141915','6256','1'),
	T_TIPO_DATA('141970','6148','1'),
	T_TIPO_DATA('141983','6187','1'),
	T_TIPO_DATA('141984','6188','1'),
	T_TIPO_DATA('141986','6194','1'),
	T_TIPO_DATA('141993','6218','1'),
	T_TIPO_DATA('142332','6244','1'),
	T_TIPO_DATA('142333','6253','1'),
	T_TIPO_DATA('149389','6224','1'),
	T_TIPO_DATA('149394','6237','1'),
	T_TIPO_DATA('149458','6247','1'),
	T_TIPO_DATA('149528','6184','1'),
	T_TIPO_DATA('149536','6220','1'),
	T_TIPO_DATA('149538','6223','1'),
	T_TIPO_DATA('149539','6227','1'),
	T_TIPO_DATA('149542','6264','1'),
	T_TIPO_DATA('149611','6241','1'),
	T_TIPO_DATA('149614','6252','1'),
	T_TIPO_DATA('149800','6230','1'),
	T_TIPO_DATA('149801','6231','1'),
	T_TIPO_DATA('149803','6233','1'),
	T_TIPO_DATA('149805','6242','1'),
	T_TIPO_DATA('159397','6202','1'),
	T_TIPO_DATA('159401','6219','1'),
	T_TIPO_DATA('159405','6232','1'),
	T_TIPO_DATA('159406','6234','1'),
	T_TIPO_DATA('159410','6250','1'),
	T_TIPO_DATA('159430','6145','1'),
	T_TIPO_DATA('159554','6251','1'),
	T_TIPO_DATA('159780','6222','1'),
	T_TIPO_DATA('160044','6146','1'),
	T_TIPO_DATA('160048','6173','1'),
	T_TIPO_DATA('160053','6221','1'),
	T_TIPO_DATA('160054','6225','1'),
	T_TIPO_DATA('160057','6248','1'),
	T_TIPO_DATA('167821','6204','1')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ECO_CONDICIONANTES_EXPEDIENTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE Nº FINCA REGISTRAL Y Nº REGISTRO DE LA PROPIEDAD');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM REM01.ACT_ACTIVO ACT
					INNER JOIN REM01.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID
					INNER JOIN REM01.BIE_DATOS_REGISTRALES DAT ON BIE.BIE_ID=DAT.BIE_ID 
					WHERE ACT.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
		
       -- DBMS_OUTPUT.PUT_LINE(V_SQL);		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       -- DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
			--Si existe realizamos otra comprobacion
			IF V_NUM_TABLAS > 0 THEN	
			
					V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES
									SET
										BIE_DREG_NUM_FINCA = '||TRIM(V_TMP_TIPO_DATA(2))||',
										BIE_DREG_NUM_REGISTRO = '||TRIM(V_TMP_TIPO_DATA(3))||',
										USUARIOMODIFICAR = '''||V_USUARIO||''',
										FECHAMODIFICAR = SYSDATE
								WHERE
									BIE_ID = (
										SELECT
											BIE_ID
										FROM
											'||V_ESQUEMA||'.ACT_ACTIVO
										WHERE
											ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'
									)';
					
					EXECUTE IMMEDIATE V_MSQL;	
				
			--El activo no existe
			ELSE
				  DBMS_OUTPUT.PUT_LINE('[ERROR]:  NO EXISTE EL ACTIVO CON ID '||TRIM(V_TMP_TIPO_DATA(1))||' ');
			END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  LOS ACTIVOS HAN SIDO ACTUALIZADOS ');

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
