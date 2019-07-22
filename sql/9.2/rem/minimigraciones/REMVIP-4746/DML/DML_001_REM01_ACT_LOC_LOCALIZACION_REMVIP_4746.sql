--/*
--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4746
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR LATITUD Y LONGITUD
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
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-4746';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_LOC_LOCALIZACION. LATITUD ' );


            
                V_MSQL := ' 
										
			MERGE INTO REM01.ACT_LOC_LOCALIZACION T1
		        USING (

				SELECT ACT.ACT_ID, TO_NUMBER( REPLACE( AUX.LOC_LATITUD, ''.'', '','' )  ) AS LOC_LATITUD
				FROM '||V_ESQUEMA||'.AUX_REMVIP_4746 AUX, '||V_ESQUEMA||'.ACT_ACTIVO ACT
				WHERE 1 = 1
				AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
				AND AUX.LOC_LATITUD IS NOT NULL

       				) T2 
		        ON (T1.ACT_ID = T2.ACT_ID )
			WHEN MATCHED THEN UPDATE
			SET T1.LOC_LATITUD = T2.LOC_LATITUD ,
		    	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	    T1.FECHAMODIFICAR   = SYSDATE
		';

                EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_LOC_LOCALIZACION');  

-----------------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_LOC_LOCALIZACION. LONGITUD ' );


            
                V_MSQL := ' 
										
			MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION T1
		        USING (

				SELECT ACT.ACT_ID, TO_NUMBER( REPLACE( AUX.LOC_LONGITUD, ''.'', '','' )  ) AS LOC_LONGITUD
				FROM '||V_ESQUEMA||'.AUX_REMVIP_4746 AUX, '||V_ESQUEMA||'.ACT_ACTIVO ACT
				WHERE 1 = 1
				AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
				AND AUX.LOC_LONGITUD IS NOT NULL

       				) T2 
		        ON (T1.ACT_ID = T2.ACT_ID )
			WHEN MATCHED THEN UPDATE
			SET T1.LOC_LONGITUD = T2.LOC_LONGITUD ,
		    	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
		    	    T1.FECHAMODIFICAR   = SYSDATE
		';

                EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_LOC_LOCALIZACION');  

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
