--/*
--#########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20191123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8428
--## PRODUCTO=NO
--## 
--## Finalidad: Inserta la relacion entre ACT_AHT_HIST_TRAM_TITULO y ACT_CAN_CALIFICACION_NEG en la ACT_ATC_TRAM_CALIFICACION
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-8428';

BEGIN

--BUSCA Y ACTUALIZA APR_AUX_MAPEO_DD_SAC

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');

		V_SQL := '  MERGE INTO '||V_ESQUEMA||'.ACT_ATC_TRAM_CALIFICACION T1 
			    USING (
					SELECT can.act_can_id, aht.aht_id
					FROM '||V_ESQUEMA||'.ACT_TIT_TITULO tit
					join '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO aht on aht.TIT_ID = tit.TIT_ID and aht.borrado = 0
					join '||V_ESQUEMA||'.ACT_CAN_CALIFICACION_NEG can on tit.act_id = can.ACT_ID
					left join '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION esp on aht.DD_ESP_ID = esp.DD_ESP_ID 
					where esp.DD_ESP_CODIGO = ''02'' and tit.TIT_FECHA_PRESENT2_REG is null
			    )
			    T2 
			    ON (T1.ACT_CAN_ID = T2.ACT_CAN_ID AND T1.AHT_ID = T2.AHT_ID)
				   WHEN NOT MATCHED THEN INSERT (ATC_ID, 
								 ACT_CAN_ID, 
								 AHT_ID, 
								 VERSION, 
								 USUARIOCREAR, 
								 FECHACREAR, 
								 USUARIOMODIFICAR, 
								 FECHAMODIFICAR, 
								 USUARIOBORRAR, 
								 FECHABORRAR, 
								 BORRADO)
				   VALUES ('||V_ESQUEMA||'.S_ACT_ATC_TRAM_CALIFICACION.NEXTVAL,
					   T2.ACT_CAN_ID, 
					   T2.AHT_ID, 
					   0, 
					   '''||V_USUARIO||''', 
					   SYSDATE, 
					   NULL, 
					   NULL, 
					   NULL, 
					   NULL, 
					   0)';
                    

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_ATC_TRAM_CALIFICACION.');
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');

		V_SQL := '  MERGE INTO '||V_ESQUEMA||'.ACT_ATC_TRAM_CALIFICACION T1 
			    USING (
					select * from (SELECT can.act_can_id, aht.AHT_ID, ROW_NUMBER() OVER (PARTITION BY can.act_id ORDER BY can.act_can_id desc) rn
					FROM '||V_ESQUEMA||'.ACT_TIT_TITULO tit
					join '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO aht on aht.TIT_ID = tit.TIT_ID and aht.borrado = 0
					join '||V_ESQUEMA||'.ACT_CAN_CALIFICACION_NEG can on tit.act_id = can.ACT_ID
					left join '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION esp on aht.DD_ESP_ID = esp.DD_ESP_ID 
					where esp.DD_ESP_CODIGO = ''02'' and can.ACT_FECHA_SUBSANACION is null AND tit.TIT_FECHA_PRESENT2_REG is not null) aux where aux.rn = 1
			    )
			    T2 
			    ON (T1.ACT_CAN_ID = T2.ACT_CAN_ID AND T1.AHT_ID = T2.AHT_ID)
				   WHEN NOT MATCHED THEN INSERT (ATC_ID, 
								 ACT_CAN_ID, 
								 AHT_ID, 
								 VERSION, 
								 USUARIOCREAR, 
								 FECHACREAR, 
								 USUARIOMODIFICAR, 
								 FECHAMODIFICAR, 
								 USUARIOBORRAR, 
								 FECHABORRAR, 
								 BORRADO)
				   VALUES ('||V_ESQUEMA||'.S_ACT_ATC_TRAM_CALIFICACION.NEXTVAL,
					   T2.ACT_CAN_ID, 
					   T2.AHT_ID, 
					   0, 
					   '''||V_USUARIO||''', 
					   SYSDATE, 
					   NULL, 
					   NULL, 
					   NULL, 
					   NULL, 
					   0)';
                    

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_ATC_TRAM_CALIFICACION.');
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');

		V_SQL := '  MERGE INTO '||V_ESQUEMA||'.ACT_ATC_TRAM_CALIFICACION T1 
			    USING (
					select * from (SELECT can.act_can_id, aht.AHT_ID, ROW_NUMBER() OVER (PARTITION BY can.act_id ORDER BY can.act_can_id desc) rn
					FROM '||V_ESQUEMA||'.ACT_TIT_TITULO tit
					join '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO aht on aht.TIT_ID = tit.TIT_ID and aht.borrado = 0
					join '||V_ESQUEMA||'.ACT_CAN_CALIFICACION_NEG can on tit.act_id = can.ACT_ID
					left join '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION esp on aht.DD_ESP_ID = esp.DD_ESP_ID 
					where esp.DD_ESP_CODIGO = ''02'' and can.ACT_FECHA_SUBSANACION < tit.TIT_FECHA_PRESENT2_REG) aux where aux.rn = 1
			    )
			    T2 
			    ON (T1.ACT_CAN_ID = T2.ACT_CAN_ID AND T1.AHT_ID = T2.AHT_ID)
				   WHEN NOT MATCHED THEN INSERT (ATC_ID, 
								 ACT_CAN_ID, 
								 AHT_ID, 
								 VERSION, 
								 USUARIOCREAR, 
								 FECHACREAR, 
								 USUARIOMODIFICAR, 
								 FECHAMODIFICAR, 
								 USUARIOBORRAR, 
								 FECHABORRAR, 
								 BORRADO)
				   VALUES ('||V_ESQUEMA||'.S_ACT_ATC_TRAM_CALIFICACION.NEXTVAL,
					   T2.ACT_CAN_ID, 
					   T2.AHT_ID, 
					   0, 
					   '''||V_USUARIO||''', 
					   SYSDATE, 
					   NULL, 
					   NULL, 
					   NULL, 
					   NULL, 
					   0)';
                    

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_ATC_TRAM_CALIFICACION.');
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');

		V_SQL := '  MERGE INTO '||V_ESQUEMA||'.ACT_ATC_TRAM_CALIFICACION T1 
			    USING (
					select * from (SELECT can.act_can_id, aht.AHT_ID, ROW_NUMBER() OVER (PARTITION BY can.act_id ORDER BY can.act_can_id desc) rn
					FROM '||V_ESQUEMA||'.ACT_TIT_TITULO tit
					join '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO aht on aht.TIT_ID = tit.TIT_ID and aht.borrado = 0
					join '||V_ESQUEMA||'.ACT_CAN_CALIFICACION_NEG can on tit.act_id = can.ACT_ID
					left join '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION esp on aht.DD_ESP_ID = esp.DD_ESP_ID 
					where esp.DD_ESP_CODIGO = ''02'' and can.ACT_FECHA_SUBSANACION >= tit.TIT_FECHA_PRESENT2_REG) aux where aux.rn = 1
			    )
			    T2 
			    ON (T1.ACT_CAN_ID = T2.ACT_CAN_ID AND T1.AHT_ID = T2.AHT_ID)
				   WHEN NOT MATCHED THEN INSERT (ATC_ID, 
								 ACT_CAN_ID, 
								 AHT_ID, 
								 VERSION, 
								 USUARIOCREAR, 
								 FECHACREAR, 
								 USUARIOMODIFICAR, 
								 FECHAMODIFICAR, 
								 USUARIOBORRAR, 
								 FECHABORRAR, 
								 BORRADO)
				   VALUES ('||V_ESQUEMA||'.S_ACT_ATC_TRAM_CALIFICACION.NEXTVAL,
					   T2.ACT_CAN_ID, 
					   T2.AHT_ID, 
					   0, 
					   '''||V_USUARIO||''', 
					   SYSDATE, 
					   NULL, 
					   NULL, 
					   NULL, 
					   NULL, 
					   0)';
                    

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_ATC_TRAM_CALIFICACION.');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
