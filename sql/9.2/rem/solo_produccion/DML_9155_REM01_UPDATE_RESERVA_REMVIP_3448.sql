--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190610
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3448
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-3448';
    V_SQL VARCHAR2(4000 CHAR);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA( '13566', '0' ),
		T_TIPO_DATA( '13602', '0' ),
		T_TIPO_DATA( '13693', '0' ),
		T_TIPO_DATA( '13875', '0' ),
		T_TIPO_DATA( '14839', '0' ),
		T_TIPO_DATA( '13660', '3000' ),
		T_TIPO_DATA( '14968', '3000' )
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza COE_CONDICIONANTES_EXPEDIENTE - Actualiza importes ');
						
    	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	LOOP
             	
	 V_TMP_TIPO_DATA := V_TIPO_DATA(I);
				
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE T1
        USING (

		SELECT 
		COE.COE_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR, 
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO, 
			'||V_ESQUEMA||'.RES_RESERVAS RES, 		
			'||V_ESQUEMA||'.ERE_ENTREGAS_RESERVA ERE, 	
			'||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE COE
		WHERE 1 = 1
		AND OFR_NUM_OFERTA = ' || TRIM(V_TMP_TIPO_DATA(1)) || '
		AND ECO.OFR_ID = OFR.OFR_ID
		AND RES.ECO_ID = ECO.ECO_ID
		AND ERE.RES_ID = RES.RES_ID
		AND COE.ECO_ID = ECO.ECO_ID


        ) T2 
        ON (T1.COE_ID = T2.COE_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.COE_IMPORTE_RESERVA = ' || TRIM(V_TMP_TIPO_DATA(2)) ||  ' ,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en COE_CONDICIONANTES_EXPEDIENTE ');  

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
