--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200615
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6460
--## PRODUCTO=NO
--##
--## Finalidad: borrado DUPLICADOS BIE_ADJ
--## INSTRUCCIONES:
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'GPV_TBJ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-6460';
    V_EXISTE_GASTO NUMBER(25);  
    V_COUNT_1 NUMBER(16); -- Vble. para kontar.
    V_COUNT_2 NUMBER(16); -- Vble. para kontar.

 BEGIN

	V_SQL := 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET BORRADO = 1, 
		USUARIOBORRAR = ''REMVIP-6440'',
		FECHABORRAR = SYSDATE 
		WHERE BIE_ADJ_ID IN (
		SELECT BIE_ADJ_ID FROM
		(SELECT ROW_NUMBER() OVER(PARTITION BY BIE_ID ORDER BY BIE_ID ) AS ROWNUMBER, BIE_ADJ_ID FROM BIE_ADJ_ADJUDICACION) T
		WHERE T.ROWNUMBER > 1)';

	EXECUTE IMMEDIATE V_SQL ;
		
	DBMS_OUTPUT.put_line('[INFO] Se ha BORRADO LOGICAMENTE '||SQL%ROWCOUNT||' registro en la tabla ');

 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

