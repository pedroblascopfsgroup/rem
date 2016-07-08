--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1844
--## PRODUCTO=SI
--##
--## Finalidad: DML Validacion nuevo diccionario DD_DVI_DESTINO_VIVIENDA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
    
    
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION WHERE JOB_VAL_CODIGO = ''bie-20.insertBieDestinoViviendaValidator''';
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN      
        DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION.');
    ELSE
        V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.BATCH_JOB_VALIDATION ' || 
           ' (JOB_VAL_ID, JOB_VAL_CODIGO, JOB_VAL_ENTITY, JOB_VAL_ORDER, JOB_VAL_VALUE, JOB_VAL_INTERFAZ, JOB_VAL_SEVERITY ' ||
           ', VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
           ' VALUES ('||V_ESQUEMA_MASTER||'.s_batch_job_validation.nextval, ''bie-20.insertBieDestinoViviendaValidator'', 1, 217,'||
                 '''INSERT INTO DD_DVI_DESTINO_VIVIENDA (DD_DVI_ID, DD_DVI_CODIGO, DD_DVI_DESCRIPCION, DD_DVI_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) ' || 
                 ' SELECT S_DD_DVI_DESTINO_VIVIENDA.NEXTVAL, DVI.DD_DVI_CODIGO, DVI.DD_DVI_DESCRIPCION, DVI.DD_DVI_DESCRIPCION_LARGA ,#TOKEN_USR#,SYSTIMESTAMP,0 ' || 
                 ' FROM ( SELECT DISTINCT ERROR_FIELD as DD_DVI_CODIGO, ''''Destino Vivienda pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_DVI_DESCRIPCION, ''''Destino Vivienda pendiente de definir (''''||ERROR_FIELD||'''')'''' as DD_DVI_DESCRIPCION_LARGA ' ||   
                 ' from ( SELECT CHAR_EXTRA3 AS ERROR_FIELD, CHAR_EXTRA3 ||''''-''''|| to_char(CODIGO_BIEN) AS ENTITY_CODE from APR_AUX_ABI_BIENES_CONSOL ' ||  
                 ' where CHAR_EXTRA3 is not null ' || 
                 ' and not exists (select 1 from DD_DVI_DESTINO_VIVIENDA dd where dd.DD_DVI_CODIGO = CHAR_EXTRA3 )  )  ) DVI'', '||
           '(SELECT dd_jvi_id FROM '||V_ESQUEMA_MASTER||'.dd_jvi_job_val_interfaz WHERE dd_jvi_codigo = ''APR_AUX_ABI_BIENES_CONSOL''),' || 
		   '(SELECT dd_jvs_id FROM '||V_ESQUEMA_MASTER||'.dd_jvs_job_val_severity WHERE dd_jvs_codigo = ''LOW''),'||
           ' 0, ''PRODU-1844'', SYSDATE, 0)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA_MASTER||'.DD_TPI_TIPO_IMPOSICION');
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
