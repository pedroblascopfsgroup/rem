--/* 
--##########################################
--## AUTOR=Sergio Hernández Gasó
--## FECHA_CREACION=20160308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=Varios
--## PRODUCTO=NO
--##
--## Finalidad: Inserta el Subtipo de tarea "Notificación por cambio de estado"
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualizaciÃ³n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Empezando a insertar datos en DD_STA_SUBTIPO_TAREA_BASE');
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''CAMBIO_ESTADO'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE... Ya existe el DD_STA_SUBTIPO_TAREA_BASE PCO_TAR_APP_EXT');
        ELSE
          V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE(DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR,  USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TGE_ID, DTYPE) 
                        VALUES('||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL, ''1'', ''CAMBIO_ESTADO'', ''Notificación automática por cambio de estado en el asunto'', ''A través de la presenta notificación se le informa que el asunto referenciado ha cambiado de estado debido a un cambio de marca en el perímetro de gestión del contrato afecto.'', 1, ''0'', ''DD'', sysdate, null, null, null, null, ''0'', null, ''EXTSubtipoTarea'') ';
              EXECUTE IMMEDIATE V_MSQL;
        END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.STA_SUBTIPO... Datos del subtipo de tarea insertado.');
    
        
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;