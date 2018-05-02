--/*
--##########################################
--## AUTOR=VICENTE MARTINEZ
--## FECHA_CREACION=20180423
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-574
--## PRODUCTO=NO
--## Finalidad: Reposicionar tramite expediente 99720.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	PL_OUTPUT VARCHAR2(20000 CHAR);

BEGIN

#ESQUEMA#.REPOSICIONAMIENTO_TRAMITE('REMVIP-574','99720','T013_DefinicionOferta',null,null,PL_OUTPUT);
DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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
