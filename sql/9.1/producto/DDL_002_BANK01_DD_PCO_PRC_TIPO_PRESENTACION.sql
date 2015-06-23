--/*
--##########################################
--## AUTOR=AGUSTIN MOMPO
--## FECHA_CREACION=20150623
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-75
--## PRODUCTO=SI
--## Finalidad: DDL DD Tipo preparacion procedimiento precontencioso
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
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

BEGIN

    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_PCO_PRC_TIPO_PREPARACION'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 
     
     then          
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PCO_PRC_TIPO_PREPARACION Ya Existe');
          V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_PCO_PRC_TIPO_PREPARACION CASCADE CONSTRAINTS';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PCO_PRC_TIPO_PREPARACION... Tabla borrada');
    END IF;
    
    EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.DD_PCO_PRC_TIPO_PREPARACION
                         ( 
						DD_PCO_PTP_ID NUMBER(16,0) NOT NULL ENABLE, 
						DD_PCO_PTP_CODIGO VARCHAR2(2 CHAR) NOT NULL ENABLE, 
						DD_PCO_PTP_DESCRIPCION VARCHAR2(50 CHAR), 
						DD_PCO_PTP_DESCRIPCION_LARGA VARCHAR2(250 CHAR), 
						VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
						USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
						FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
						USUARIOMODIFICAR VARCHAR2(10 CHAR), 
						FECHAMODIFICAR TIMESTAMP (6), 
						USUARIOBORRAR VARCHAR2(10 CHAR), 
						FECHABORRAR TIMESTAMP (6), 
						BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE	
                         )
                      ';                             
    DBMS_OUTPUT.PUT_LINE('[INFO] DD_PCO_PRC_TIPO_PREPARACION Creada');     

    EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.DD_PCO_PRC_TIPO_PREPARACION ADD CONSTRAINT PK_DD_PCO_PTP PRIMARY KEY (DD_PCO_PTP_ID)';
    DBMS_OUTPUT.PUT_LINE('[INFO] DD_PCO_PRC_TIPO_PREPARACION PK Creada');     

    -- Damos permisos de lectura
 --   EXECUTE IMMEDIATE 'GRANT SELECT ON '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION 
 --                         TO '||V_ESQUEMA_M||'
 --                          , '||V_ESQUEMA_MIN||'
 --                         , '||V_ESQUEMA_DWH||'
 --                          , '||V_ESQUEMA_STG||'
 --                     ';
 --   DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION... Asignados permisos de lectura la resto de esquemas');
    
    
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
