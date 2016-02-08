--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20160118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-585
--## PRODUCTO=NO
--##
--## Finalidad: Realiza las inserciones de la resolución especial Subida de ficheros.
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    /* ##############################################################################
    ## INSTRUCCIONES - DATOS DE LA RESOLUCIÓN
    ## Modificar sólo los siguientes datos.
    ## En descripción larga introducirá los datos de la descripción (Tanto en la resolución como en el Input).
    ## En la ayuda introducirá la cadena 'Ayuda de ' seguida del valor definido en la variable: V_TR_DESCRIPCION.
    */
    V_TR_ID VARCHAR2(16 CHAR):= 			'1005';
    V_TR_CODIGO VARCHAR2(25 CHAR):= 		'RESOL_ESP_NOTI';
    V_TR_DESCRIPCION  VARCHAR2(100 CHAR):=	'Notificacion';
    V_TJ_CODIGO VARCHAR2(20 CHAR):=			'HIP';
    V_TAC_CODIGO VARCHAR2(20 CHAR):=		'NOTIFICACION'; -- ADVANCE, INFO, etc.
    
    
    -- ## FIN DATOS DE LA RESOLUCION
    -- ########################################################################################

BEGIN	

      -- LOOP Insertando valores en PRO_PROCURADORES ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... Empezando a insertar datos de la resolución '||V_TR_CODIGO||'.');
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION WHERE DD_TR_CODIGO = '''||V_TR_CODIGO||'''';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    
    IF table_count = 1 THEN
   		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TR_TIPOS_RESOLUCION... Ya existe el DD_TR_TIPOS_RESOLUCION '||V_TR_CODIGO||'.');
	ELSE
		-- Insertamos en la tabla dd_tr_tipos_resolucion el tipo de resolución
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION (' ||
				   'DD_TR_ID, DD_TR_CODIGO, DD_TR_DESCRIPCION, DD_TR_DESCRIPCION_LARGA, DD_TJ_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TR_AYUDA, BPM_DD_TAC_ID) ' ||
				   'SELECT '''||V_TR_ID||''','''||V_TR_CODIGO||''','''||V_TR_DESCRIPCION||''','''||V_TR_DESCRIPCION||''','||
				   		'(SELECT DD_TJ_ID FROM '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO WHERE DD_TJ_CODIGO = '''||V_TJ_CODIGO||'''),'||
				   		'0, ''MOD_PROC'', SYSDATE, 0, ''Ayuda de '||V_TR_DESCRIPCION||''', (SELECT BPM_DD_TAC_ID FROM '||V_ESQUEMA||'.BPM_DD_TAC_TIPO_ACCION WHERE BPM_DD_TAC_CODIGO ='''||V_TAC_CODIGO||''')'||
				   		' FROM DUAL';
				   		
		EXECUTE IMMEDIATE V_MSQL;
		
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION... ha terminado la insercción de datos de la resolución '||V_TR_CODIGO||'.');
    END IF;
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