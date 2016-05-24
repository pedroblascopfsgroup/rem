--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20150301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-2328
--## PRODUCTO=SI
--##
--## Finalidad: Actualiza el valor del campo PCO_PRC_NOM_EXP_JUD
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_PRC_PROCEDIMIENTOS'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_PRC_NOM_EXP_JUD');
    	
		V_SQL := 'UPDATE (SELECT pco.PCO_PRC_NOM_EXP_JUD nomexp, pco.FECHAMODIFICAR fechamodificar, pco.USUARIOMODIFICAR usuariomodificar, asu.ASU_NOMBRE asunom, tpo.DD_TPO_DESCRIPCION tipodesc'||
  				' FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc ON pco.PRC_ID = prc.PRC_ID INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo ON prc.DD_TPO_ID = tpo.DD_TPO_ID INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS asu ON prc.ASU_ID = asu.ASU_ID) '||
				' SET nomexp = CONCAT(CONCAT(asunom, ''-''),tipodesc), usuariomodificar = ''DML'', fechamodificar = SYSDATE';
    	EXECUTE IMMEDIATE V_SQL;
    	
    END IF;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_PRC_NOM_EXP_JUD' );
    
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