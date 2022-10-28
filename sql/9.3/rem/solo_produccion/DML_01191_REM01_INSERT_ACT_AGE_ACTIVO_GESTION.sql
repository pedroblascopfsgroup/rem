--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12612
--## PRODUCTO=NO
--## Finalidad:
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-12612';

    V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
    V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_REMVIP_12612';
    V_TABLA_ACT_GCP VARCHAR2 (30 CHAR) := 'ACT_AGE_ACTIVO_GESTION';

 BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

--INSERT EN ACT_AGE_ACTIVO_GESTION
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_GCP||' (
	    AGE_ID,
            ACT_ID,
            DD_ELO_ID,
            DD_SEG_ID,
            USU_ID,
            AGE_FECHA_INICIO,
	    VERSION,
	    USUARIOCREAR,
	    FECHACREAR,
	    USUARIOMODIFICAR,
	    FECHAMODIFICAR,
	    USUARIOBORRAR,
	    FECHABORRAR,
	    BORRADO			
		)
		SELECT
			'||V_ESQUEMA||'.S_ACT_AGE_ACTIVO_GESTION.NEXTVAL             AGE_ID,
			ACT.ACT_ID						                             ACT_ID,
            ELO_CALC.DD_ELO_ID      				                     DD_ELO_ID,
			SEG_CALC.DD_SEG_ID       				                     DD_SEG_ID,
            1      						                                 USU_ID,
            SYSDATE     						                         AGE_FECHA_INICIO,
			''0''                                                        VERSION,
			'''||V_USUARIO||'''                                          USUARIOCREAR,
			SYSDATE                                                      FECHACREAR,
			NULL                                                         USUARIOMODIFICAR,
			NULL                                                         FECHAMODIFICAR,
			NULL                                                         USUARIOBORRAR,
			NULL                                                         FECHABORRAR,
			0                                                            BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_AAII	
			
		LEFT JOIN '||V_ESQUEMA||'.DD_ELO_ESTADO_LOCALIZACION ELO_calc ON 
		UPPER(ELO_calc.DD_ELO_DESCRIPCION) = 
		UPPER(DECODE(aux.estado_ccpp,''Pendiente gestionar'',''Pendiente de Gestionar'',aux.estado_ccpp)) 
		AND ELO_calc.BORRADO = 0

		LEFT JOIN '||V_ESQUEMA||'.DD_SEG_SUBESTADO_GESTION SEG_calc ON 
		UPPER(SEG_calc.DD_SEG_DESCRIPCION) = 
		UPPER(DECODE(aux.subestado_ccpp,''Edificio en construcción'',''Edificación construcción'',''Pendiente documentación'',''Pendiente de documentacion'',''En constitución'',''En constitucion'',aux.subestado_ccpp)) 
		AND SEG_calc.BORRADO = 0

		WHERE ACT.BORRADO = 0 AND ACT.ACT_ID NOT IN (SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACT_GCP||' WHERE BORRADO = 0 AND AGE_FECHA_FIN IS NULL)';
      EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('Insertados ' ||SQL%ROWCOUNT|| ' registros');
      
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_TABLA_ACT_GCP||' actualizada correctamente ');
      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;