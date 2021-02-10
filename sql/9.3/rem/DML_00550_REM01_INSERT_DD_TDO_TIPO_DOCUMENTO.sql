--/*
--##########################################
--## AUTOR=Carlos Augusto
--## FECHA_CREACION=20210209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13072
--## PRODUCTO=NO
--## Finalidad: Inserción nuevos registros en la tabla DD_TDO_TIPO_DOC_ENTIDAD.Este dml no actualiza y obtiene los datos tal cual.
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
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
 
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  
        
    DBMS_OUTPUT.PUT_LINE('[INFO]: Se comprueba si ya existen los valores');
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT count(1) 
                    from '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD
                    where  DD_TDO_CODIGO in
                    (SELECT DD_TPD_CODIGO from '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO where dd_tpd_visible=1) ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         DBMS_OUTPUT.PUT_LINE('[INFO]: Se realiza la comprobacion' );
        --Si existe no hacemos nada
        IF V_NUM_TABLAS > 0 THEN				
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADO ANTERIORMENTE NO SE REALIZA NADA');
        
          
       --Si no existe, lo insertamos   
       ELSE
         DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
       	  V_MSQL := '  INSERT INTO  '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD (DD_TDO_ID, DD_TED_ID, DD_TDO_CODIGO, DD_TDO_DESCRIPCION, DD_TDO_DESCRIPCION_LARGA, DD_TDO_MATRICULA, USUARIOCREAR, FECHACREAR, BORRADO)
                            SELECT S_DD_TDO_TIPO_DOC_ENTIDAD.NEXTVAL,
                            (select dd_Ted_id from '||V_ESQUEMA||'.DD_TED_TIP_ENTIDAD_DOC where dd_ted_codigo = ''ACT''),
                                dd_TPD_CODIGO,dd_tpd_descripcion,dd_tpd_descripcion_larga,dd_tpd_matricula_gd, ''HREOS-13072'', SYSDATE, 0 
                                    FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE dd_tpd_visible=1';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS Añadidos CORRECTAMENTE');
        
        
       END IF;
    COMMIT;

   

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

EXIT;
