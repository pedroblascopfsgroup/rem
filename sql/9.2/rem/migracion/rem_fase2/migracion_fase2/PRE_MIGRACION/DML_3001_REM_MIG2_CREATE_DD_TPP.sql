--/*
--##########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161017
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=migracion
--## INCIDENCIA_LINK=migracion
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Usuario migración
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

    V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO WHERE DD_TPP_CODIGO = ''04''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
    
    IF V_NUM_TABLAS > 0 THEN            
      DBMS_OUTPUT.put_line('[INFO] Ya existe el TIPO PROPUESTA PRECIO "Sin especificar"');
    ELSE        
      V_SQL := '
      Insert into '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO
            (DD_TPP_ID,
            DD_TPP_CODIGO,
            DD_TPP_DESCRIPCION,
            DD_TPP_DESCRIPCION_LARGA,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO) 
			values (
            '||V_ESQUEMA||'.s_DD_TPP_TIPO_PROP_PRECIO.NEXTVAL,
            ''04'',
            ''No especificado'',
            ''No especificado'',
            ''0'',
            ''MIG2'',
            SYSDATE,
            ''1'')';
      
      EXECUTE IMMEDIATE V_SQL ;
      DBMS_OUTPUT.put_line('[INFO] Se ha insertado el TIPO PROPUESTA PRECIO "Sin especificar"');
    END IF ;

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
