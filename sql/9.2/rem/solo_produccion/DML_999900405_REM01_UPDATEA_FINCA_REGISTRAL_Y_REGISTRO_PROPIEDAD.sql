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
    ------ 	 ACTIVO , FINCA REGISTRAL,REGISTRO DE LA PROPIEDAD
    T_TIPO_DATA('99506','14798','9')
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
