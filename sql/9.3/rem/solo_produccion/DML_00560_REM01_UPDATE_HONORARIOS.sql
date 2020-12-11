--/*
--#########################################
--## AUTOR= Carlos Santos Vílchez
--## FECHA_CREACION=20201130
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8439
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar honorarios
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
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
	V_TABLA_GASTOS VARCHAR2(100 CHAR):= 'GEX_GASTOS_EXPEDIENTE';
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-8439';
    V_SQL VARCHAR2(4000 CHAR);
	V_COUNT NUMBER(16);	
	V_ID NUMBER(16);	
	V_IMPORTE_FINAL VARCHAR2(25 CHAR);
	V_IMPORTE_CALCULO VARCHAR2(25 CHAR);

	----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

BEGIN						

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] CARGA MASIVA DE HONORARIOS ');

	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO LÓGICO DE HONORARIOS RECOGIDOS EN LA TABLA AUX_REMVIP_8439_1');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_GASTOS||' T1
		        USING (
					SELECT DISTINCT ECO.ECO_ID, AUX.GEX_OBSERVACIONES FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
					INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
                    INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8439_1 AUX ON OFR.OFR_NUM_OFERTA = AUX.OFR_NUM_OFERTA
					WHERE OFR.OFR_NUM_OFERTA IN (SELECT OFR_NUM_OFERTA FROM AUX_REMVIP_8439_1)
        		) T2 
        	  ON (T1.ECO_ID = T2.ECO_ID)
				WHEN MATCHED THEN UPDATE
					SET T1.USUARIOBORRAR = '''||V_USUARIO||''',
	    				T1.FECHABORRAR   = SYSDATE,
						T1.BORRADO = 1,
						T1.GEX_OBSERVACIONES = T2.GEX_OBSERVACIONES';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TABLA_GASTOS);  


-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR HONORARIOS RECOGIDOS EN LA TABLA AUX_REMVIP_8439_2');
										
	-- Selecciona todos los ACT_NUM_ACTIVO de la tabla auxiliar
	V_SQL := 'SELECT ID FROM '||V_ESQUEMA||'.AUX_REMVIP_8439_2' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP

        FETCH v_cursor INTO V_ID;
        EXIT WHEN v_cursor%NOTFOUND;
    
        V_SQL := ' INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_GASTOS||' 
        (GEX_ID, ECO_ID, DD_ACC_ID, DD_TCC_ID, GEX_IMPORTE_CALCULO, GEX_IMPORTE_FINAL, USUARIOCREAR, FECHACREAR, GEX_PROVEEDOR, GEX_OBSERVACIONES, DD_TPH_ID, ACT_ID)
        VALUES (
            '||V_ESQUEMA||'.S_'||V_TABLA_GASTOS||'.NEXTVAL,
            (SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID = (SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = (SELECT OFR_NUM_OFERTA FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||'))),
            (SELECT DD_ACC_ID FROM DD_ACC_ACCION_GASTOS WHERE DD_ACC_DESCRIPCION = (SELECT DD_ACC_DESCRIPCION FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||')),
            (SELECT DD_TCC_ID FROM DD_TCC_TIPO_CALCULO WHERE DD_TCC_CODIGO = ''01''),
			(SELECT GEX_IMPORTE_CALCULO FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||'),
			(SELECT GEX_IMPORTE_FINAL FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||'),
            '''||V_USUARIO||''',	
            SYSDATE,
            (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = (SELECT GEX_PROVEEDOR FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||')),
            (SELECT GEX_OBSERVACIONES FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||'),
			(SELECT DD_TPH_ID FROM DD_TPH_TIPO_PROV_HONORARIO WHERE DD_TPH_DESCRIPCION = (SELECT DD_TPH_DESCRIPCION FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||')),
			(SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = (SELECT ACT_NUM_ACTIVO FROM AUX_REMVIP_8439_2 WHERE ID = '||V_ID||'))
        ) ';

        EXECUTE IMMEDIATE V_SQL;
        
        V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] SE HAN INSERTADO '||V_COUNT||' REGISTROS EN '||V_TABLA_GASTOS);	


-----------------------------------------------------------------------------------------------------------------


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	

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
