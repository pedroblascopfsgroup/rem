--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.4
--## INCIDENCIA_LINK=HR-1040
--## PRODUCTO=SI
--## Finalidad: DML
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

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''ESADJ''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO ...no se modificará nada.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TAC_ID) values ('||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL, ''ESADJ'', ''Escrito solicitud adjudicación'', ''Escrito solicitud adjudicación'', 0, ''DML'', SYSDATE, null, null, null, null, 0, (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''AP''))';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO... Datos del diccionario insertado');
        
    END IF;	
    
    

    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''MCC''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO ...no se modificará nada.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TAC_ID) values ('||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL, ''MCC'', ''Mandamiento de cancelación de cargas'', ''Mandamiento de cancelación de cargas'', 0, ''DML'', SYSDATE, null, null, null, null, 0, (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''AP''))';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO... Datos del diccionario insertado');
        
    END IF;
    
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''DPRCD''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO ...no se modificará nada.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TAC_ID) values ('||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL, ''DPRCD'', ''Documento presentaci&oacute;n en Registro con el sello de presentaci&oacute;n'', ''Documento presentaci&oacute;n en Registro con el sello de presentaci&oacute;n'', 0, ''DML'', SYSDATE, null, null, null, null, 0, (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''AP''))';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO... Datos del diccionario insertado');
        
    END IF;
    
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO= ''TITINSC''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO ...no se modificará nada.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TAC_ID) values ('||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL, ''TITINSC'', ''Título inscrito'', ''Título inscrito'', 0, ''DML'', SYSDATE, null, null, null, null, 0, (SELECT DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''AP''))';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO... Datos del diccionario insertado');
        
    END IF;
    
    

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
