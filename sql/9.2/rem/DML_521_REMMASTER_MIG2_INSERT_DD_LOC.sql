--/*
--##########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161021
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
      
      V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = ''00000''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
      
      DBMS_OUTPUT.PUT_LINE('[INFO] Verificando existencia del registro....'); 
      
      IF V_NUM_TABLAS > 0 THEN            
            DBMS_OUTPUT.put_line('[INFO] Ya existe la localidad "No disponible" con codigo "00000"');
      ELSE        
            EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD (
                  DD_LOC_ID
                  ,DD_PRV_ID
                  ,DD_LOC_CODIGO
                  ,DD_LOC_DESCRIPCION
                  ,DD_LOC_DESCRIPCION_LARGA
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
            ) 
            SELECT
                  '||V_ESQUEMA_M||'.S_DD_LOC_LOCALIDAD.NEXTVAL
                  ,DD.DD_PRV_ID
                  ,''00000''
                  ,''No disponible''
                  ,''No disponible''
                  ,0
                  ,''MIG2''
                  ,SYSDATE
                  ,0
            FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DD WHERE DD.DD_PRV_CODIGO = ''0''
            '
            ;
            
            DBMS_OUTPUT.put_line('[INFO] Se ha insertado la localidad "No disponible" con codigo "00000"');
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
