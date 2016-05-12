--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCT0-1206
--## PRODUCTO=NO
--## Finalidad: DML para insertar funcion a perfil procurador
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un registro  
    V_NUM_SEQUENCE NUMBER(16);     
    V_NUM_MAXID NUMBER(16);
   
BEGIN
	
	 DBMS_OUTPUT.PUT_LINE('******** FUN_PEF: igualando secuencia ********');
	
	 V_SQL := 'SELECT '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
        DBMS_OUTPUT.PUT_LINE(V_NUM_SEQUENCE);
        
        V_SQL := 'SELECT NVL(MAX(FP_ID), 0) FROM '||V_ESQUEMA||'.FUN_PEF';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
        DBMS_OUTPUT.PUT_LINE(V_NUM_MAXID);
        
        WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
            V_SQL := 'SELECT '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
        
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********');
-- TAB CONTABILIDAD COBROS.
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobacion previa TAB_PRC_ADJUNTOS'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROC'') AND FUN_ID IN( SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''TAB_PRC_ADJUNTO'')';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.FUN_PEF.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR, BORRADO) SELECT '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, FUN_ID, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROC''),''PRODUCTO-1206'', SYSDATE, 0 FROM (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''TAB_PRC_ADJUNTO'')';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.PEF_PERFILES');
	END IF;

DBMS_OUTPUT.PUT_LINE('[INFO] Ya está insertado');

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

