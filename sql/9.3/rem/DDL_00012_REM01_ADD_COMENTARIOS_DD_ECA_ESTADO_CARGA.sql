--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190928
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7795
--## PRODUCTO=NO
--## Finalidad: DDL creación de comentarios para la tabla y columnas.
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
    
    err_num NUMBER; -- Número de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'DD_ECA_ESTADO_CARGA_ACTIVOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='TABLE';  
  IF CUENTA>0 THEN 
  
  DBMS_OUTPUT.PUT_LINE('Creando comentarios para '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS...');  
  
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.DD_ECA_ID IS ''ID único del registro del diccionario''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.DD_ECA_CODIGO IS ''Código único del registro del diccionario''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.DD_ECA_DESCRIPCION IS ''Descripción del registro del diccionario''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.DD_ECA_DESCRIPCION_LARGA IS ''Descripción larga del registro del diccionario''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.VERSION IS ''Indica la versión del registro''';  
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_ECA_ESTADO_CARGA_ACTIVOS.BORRADO IS ''Indicador de borrado''';

  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS...Creada OK');

  COMMIT;

  END IF;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
