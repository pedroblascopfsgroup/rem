--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCT0-1052
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las plantillas de los burofax
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

        DBMS_OUTPUT.PUT_LINE('[INICIO] Vamos a insertar nuevo tipo de documento');
  -- LOOP Insertando valores en la tabla del diccionario
  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO... Empezando a insertar datos en el diccionario');
    
    V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
        DBMS_OUTPUT.PUT_LINE(V_NUM_SEQUENCE);
        
        V_SQL := 'SELECT NVL(MAX(DD_TFA_ID), 0) FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
        DBMS_OUTPUT.PUT_LINE(V_NUM_MAXID);
        
        WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
            V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TFA_FICHERO_ADJUNTO.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
        
        END LOOP;
    
    V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''DA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Insertar nuevo tipo documento: DA=Decreto de adjudicación');
    EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO
       (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
     Values
       ('||V_ESQUEMA||'.s_dd_tfa_fichero_adjunto.nextval, ''DA'', ''Decreto adjudicación'', ''Decreto adjudicación'', 0, ''PRODUCTO-1052'', sysdate, 0, (select dd_tac_id from '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO = ''AP''))';
    
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

