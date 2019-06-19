--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190611
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4497
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4497';
    V_SQL VARCHAR2(4000 CHAR);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA( --    #ACTIVO           IDUFIR    DD_PRV_ID DD_LOC_ID
					T_TIPO_DATA( '7224031', '04010001041823',    4,      340      ),
					T_TIPO_DATA( '7224045', '04019001334188',    4,      292      ),
					T_TIPO_DATA( '7224056', '04016000020401',    4,      292      ),
					T_TIPO_DATA( '7224096', '03006000317626',    3,      195      ),
					T_TIPO_DATA( '7223951', '08071000006806',    8,      881      ),
					T_TIPO_DATA( '7102085', '04016000412497',    4,      292      ),
					T_TIPO_DATA( '7102081', ''		,    3,      220      ),
					T_TIPO_DATA( '7102080', '04012000124743',    4,      292      ),
					T_TIPO_DATA( '7100633', '02008000634056',   52,      138      ),
					T_TIPO_DATA( '7076175', '02008000634025',   52,      138      ),
					T_TIPO_DATA( '7100631', '02008000634032',   52,      138      ),
					T_TIPO_DATA( '7075121', '02008000773526',   52,      138      ),
					T_TIPO_DATA( '7075117', '02008000773533',   52,      138      ),
					T_TIPO_DATA( '7075119', '02008000773502',   52,      138      ),
					T_TIPO_DATA( '7101248', '04004000317058',    4,      315      ),
					T_TIPO_DATA( '7102037', '' 	        ,    4,      292      ),
					T_TIPO_DATA( '7076179', '02008000634018',   52,      138      ),
					T_TIPO_DATA( '7102045', '04014000272875',    4,      356      )
    					); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza datos registrales ');
						
    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP
             	
	 V_TMP_TIPO_DATA := V_TIPO_DATA(I);
				
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES T1
        USING (

		SELECT 
		BIE_ID
		FROM 	'||V_ESQUEMA||'.ACT_ACTIVO 
		WHERE 1 = 1
		AND ACT_NUM_ACTIVO = ' || TRIM(V_TMP_TIPO_DATA(1)) || '
		AND BORRADO = 0

        ) T2 
        ON (T1.BIE_ID = T2.BIE_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.DD_LOC_ID = ' || TRIM(V_TMP_TIPO_DATA(4)) ||  ' ,
	    T1.DD_PRV_ID = ' || TRIM(V_TMP_TIPO_DATA(3)) ||  ' ,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en BIE_DATOS_REGISTRALES del activo ' || TRIM(V_TMP_TIPO_DATA(1))   );  


	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL T1
        USING (

		SELECT 
		ACT_ID
		FROM 	'||V_ESQUEMA||'.ACT_ACTIVO 
		WHERE 1 = 1
		AND ACT_NUM_ACTIVO = ' || TRIM(V_TMP_TIPO_DATA(1)) || '
		AND BORRADO = 0

        ) T2 
        ON (T1.ACT_ID = T2.ACT_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.REG_IDUFIR = ' || CASE WHEN TRIM(V_TMP_TIPO_DATA(2)) = '' THEN 'NULL' ELSE '''' || TRIM(V_TMP_TIPO_DATA(2)) || '''' END  ||  ' ,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_REG_INFO_REGISTRAL del activo ' || TRIM(V_TMP_TIPO_DATA(1)) );  

      	END LOOP;


-----------------------------------------------------------------------------------------------------------------


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso realizado');
	

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
