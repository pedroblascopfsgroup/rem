--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10952
--## PRODUCTO=NO
--## 
--## Finalidad: Cargar fecha titulo anterior a activos migrados
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

  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USER VARCHAR2(50 CHAR):= 'REMVIP-10952';

BEGIN

      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualización FECHA TITULO ANTERIOR');
		      
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
						USING(
							SELECT DISTINCT ACT2.ACt_ID,ACT.ACT_NUM_aCTIVO,
                                adn.adn_fecha_titulo,
                                BIE_ADJ.BIE_ADJ_F_DECRETO_FIRME,
                                COALESCE(bie_adj.bie_adj_f_decreto_firme,adn.adn_fecha_titulo) AS FECHA_PONER
                                FROM '||V_ESQUEMA||'.act_activo ACT
                                JOIN '||V_ESQUEMA||'.aux_act_traspaso_activo AUX ON aux.act_num_activo_nuv=ACT.ACT_NUM_ACTIVO
                                JOIN '||V_ESQUEMA||'.ACT_aCTIVO ACT2 ON ACT2.ACT_NUM_aCTIVO=aux.act_num_activo_ant AND ACT.BORRADO = 0
                                LEFT JOIN '||V_ESQUEMA||'.act_ajd_adjjudicial AJD ON AJD.ACT_ID=ACT2.ACT_ID AND AJD.BORRADO = 0
                                LEFT JOIN '||V_ESQUEMA||'.bie_adj_adjudicacion BIE_ADJ ON bie_adj.bie_adj_id=ajd.bie_adj_id AND BIE_ADJ.BORRADO = 0
                                LEFT JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID=ACT2.ACT_ID AND ADN.BORRADO = 0
                                order by act.act_num_activo
						) T2
						ON (T1.ACT_ID = T2.ACT_ID)
						WHEN MATCHED THEN
							UPDATE SET 
							    T1.USUARIOMODIFICAR = '''||V_USER||''',
							    T1.FECHAMODIFICAR = SYSDATE,
                                T1.ACT_FECHA_TITULO_ANTERIOR = T2.FECHA_PONER';
				    
		      EXECUTE IMMEDIATE V_SQL;
		      
		      DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS  '||SQL%ROWCOUNT||' ACTUALIZADOS');

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
EXIT;
