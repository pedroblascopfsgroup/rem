--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190402
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad:  .
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIO_MIGRACION VARCHAR2(50 CHAR):= 'MIG_APPLE';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

      -------------------------------------------------
      --MERGE EN ACT_ADN_ADJNOJUDICIAL--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] MERGE EN ACT_ADN_ADJNOJUDICIAL');

      
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO, 
						   ACT.ACT_ID,
						   BIE.BIE_ID,
						   ADN.ADN_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO                       ACT
					JOIN '||V_ESQUEMA||'.BIE_BIEN                         BIE ON BIE.BIE_ID = ACT.BIE_ID
					JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION             ADJ ON ADJ.BIE_ID = BIE.BIE_ID
					JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA            SPS ON SPS.ACT_ID = ACT.ACT_ID
					LEFT JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL       ADN on ADN.ACT_ID = ACT.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.ADN_ID = T2.ADN_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.ADN_FECHA_TITULO = TO_DATE(''28/03/2019'',''DD/MM/YYYY''),
					T1.ADN_FECHA_FIRMA_TITULO = TO_DATE(''28/03/2019'',''DD/MM/YYYY''),
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN 
				INSERT (
						T1.ADN_ID,
						T1.ACT_ID,
						T1.DD_EEJ_ID,
						T1.ADN_FECHA_TITULO,
						T1.ADN_FECHA_FIRMA_TITULO,
						T1.USUARIOCREAR,
						T1.FECHACREAR,
						T1.BORRADO,
						T1.ADN_EXP_DEF_TESTI
						)
				VALUES (
						'||V_ESQUEMA||'.S_ACT_ADN_ADJNOJUDICIAL.NEXTVAL,
						T2.ACT_ID,
						(SELECT DD_EEJ_ID FROM '||V_ESQUEMA||'.DD_EEJ_ENTIDAD_EJECUTANTE WHERE DD_EEJ_CODIGO IN (''52'')),
						TO_DATE(''28/03/2019'',''DD/MM/YYYY''),
						TO_DATE(''28/03/2019'',''DD/MM/YYYY''),
						''MIG_APPLE'',
						SYSDATE,
						0,
						0
				)
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se modifica la ADN de '||V_NUM_TABLAS||' activos de APPLE.');  
    
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
