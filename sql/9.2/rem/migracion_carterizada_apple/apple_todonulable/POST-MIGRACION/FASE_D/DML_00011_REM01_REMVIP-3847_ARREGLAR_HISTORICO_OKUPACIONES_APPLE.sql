--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190403
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
    
      V_SQL := 'DELETE 
				FROM '||V_ESQUEMA||'.OKU_DEMANDA_OCUPACION_ILEGAL T1 
				WHERE EXISTS (
					SELECT 1
					FROM '||V_ESQUEMA||'.OKU_DEMANDA_OCUPACION_ILEGAL 	OKU
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO                   	ACT ON ACT.ACT_ID = OKU.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
					  AND T1.OKU_ID = OKU.OKU_ID
				)
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se borran '||V_NUM_TABLAS||' registros del historico de okupaciones de activos de APPLE.');  
           
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.OKU_DEMANDA_OCUPACION_ILEGAL T1
				USING (
					SELECT DISTINCT
					       ACT.ACT_NUM_ACTIVO, 
						   ACT.ACT_ID,
						   OKU.OKU_ID,
						   AUX.*
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3847_1                AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO                           ACT ON AUX.ID_ACTIVO_HAYA = ACT.ACT_NUM_ACTIVO
					LEFT JOIN '||V_ESQUEMA||'.OKU_DEMANDA_OCUPACION_ILEGAL    OKU ON OKU.ACT_ID = ACT.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.OKU_ID = T2.OKU_ID AND T1.OKU_NUM_ASUNTO = T2.ASUNTO AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
						T1.OKU_FECHA_INICIO_ASUNTO = TO_DATE(T2.FECHA_INICIO_ASUNTO,''YYYY-MM-DD''),
						T1.OKU_FECHA_FIN_ASUNTO = TO_DATE(T2.FECHA_FIN_ASUNTO,''YYYY-MM-DD''),
						T1.OKU_FECHA_LANZAMIENTO = TO_DATE(T2.FECHA_LANZAMIENTO,''YYYY-MM-DD''),
						T1.DD_TAO_ID = CASE WHEN TIPO_ASUNTO = ''Terminado'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''10'')
											WHEN TIPO_ASUNTO = ''Preparando demanda'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''2'')
											ELSE NULL
									   END,
						T1.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_OKU_TIPO_ACTUACION WHERE DD_TCO_CODIGO = ''04''),
						T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
						T1.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT (T1.OKU_ID, T1.ACT_ID, T1.OKU_NUM_ASUNTO, T1.OKU_FECHA_INICIO_ASUNTO, T1.OKU_FECHA_FIN_ASUNTO, T1.OKU_FECHA_LANZAMIENTO, T1.DD_TAO_ID, T1.DD_TCO_ID, T1.USUARIOCREAR, T1.FECHACREAR, T1.BORRADO)
				VALUES (
						'||V_ESQUEMA||'.S_OKU_DEMANDA_OCUPACION_ILEGAL.NEXTVAL,
						T2.ACT_ID,
						T2.ASUNTO,
						TO_DATE(T2.FECHA_INICIO_ASUNTO,''YYYY-MM-DD''),
						TO_DATE(T2.FECHA_FIN_ASUNTO,''YYYY-MM-DD''),
						TO_DATE(T2.FECHA_LANZAMIENTO,''YYYY-MM-DD''),
						CASE WHEN TIPO_ASUNTO = ''Terminado'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''10'')
							 WHEN TIPO_ASUNTO = ''Preparando demanda'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''2'')
							 ELSE NULL
						END,
						(SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_OKU_TIPO_ACTUACION WHERE DD_TCO_CODIGO = ''04''),
						''MIG_APPLE_POST'',
						SYSDATE,
						0
				)
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se insertan '||V_NUM_TABLAS||' registros en el historico de okupaciones para activos de APPLE.');
    
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
