--/*
--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160517
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3358
--## PRODUCTO=NO
--## Finalidad: DDL Creación de las tablas 
--##            MIG1_PROCEDIMIENTOS_ACTORES  MIG1_PROCEDIMIENTOS_CABECERA  MIG1_PROCEDIMIENTOS_DEMANDADOS  MIG1_PROCEDIMIENTOS_OPERACIONE   MIG1_PROCEDIMIENTOS_BIENES 
--##            MIG1_PROCEDIMIENTOS_DEMANDADOS  MIG1_PROCEDIMIENTOS_EMBARGOS  MIG1_PROCEDIMIENTOS_SUBASTAS  MIG1_PROCS_SUBASTAS_LOTES  MIG1_PROCS_SUBASTAS_LOTES_BIEN 
--##            MIG_MAESTRA_HITOS MIG_MAESTRA_HITOS_VALORES MIG_PARAM_HITOS MIG_PARAM_HITOS_VALORES
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
  V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_MAESTRA_HITOS'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_MAESTRA_HITOS... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_MAESTRA_HITOS as select * from '||V_ESQUEMA||'.mig_maestra_hitos';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_MAESTRA_HITOS... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_MAESTRA_HITOS_VALORES'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_MAESTRA_HITOS_VALORES... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_MAESTRA_HITOS_VALORES as select * from '||V_ESQUEMA||'.mig_maestra_hitos_valores';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_MAESTRA_HITOS_VALORES... Tabla creada');
  END IF;
  
  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PARAM_HITOS'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PARAM_HITOS... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PARAM_HITOS as select * from '||V_ESQUEMA||'.mig_param_hitos';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PARAM_HITOS... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PARAM_HITOS_VALORES'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PARAM_HITOS_VALORES... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PARAM_HITOS_VALORES as select * from '||V_ESQUEMA||'.mig_param_hitos_valores';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PARAM_HITOS_VALORES... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_ACTORES'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_ACTORES... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_ACTORES as select * from '||V_ESQUEMA||'.mig_procedimientos_actores';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_ACTORES... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_CABECERA'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_CABECERA... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_CABECERA as select * from '||V_ESQUEMA||'.mig_procedimientos_cabecera';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_CABECERA... Tabla creada');
  END IF;
  
  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_DEMANDADOS'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_DEMANDADOS... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_DEMANDADOS as select * from '||V_ESQUEMA||'.mig_procedimientos_demandados';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_DEMANDADOS... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_OPERACIONE'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_OPERACIONE... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_OPERACIONE as select * from '||V_ESQUEMA||'.mig_procedimientos_operaciones';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_OPERACIONE... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_BIENES'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_BIENES... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_BIENES as select * from '||V_ESQUEMA||'.mig_procedimientos_bienes';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_BIENES... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_EMBARGOS'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_EMBARGOS... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_EMBARGOS as select * from '||V_ESQUEMA||'.mig_procedimientos_embargos';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_EMBARGOS... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCEDIMIENTOS_SUBASTAS'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_SUBASTAS... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCEDIMIENTOS_SUBASTAS as select * from '||V_ESQUEMA||'.mig_procedimientos_subastas';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCEDIMIENTOS_SUBASTAS... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCS_SUBASTAS_LOTES'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCS_SUBASTAS_LOTES... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCS_SUBASTAS_LOTES as select * from '||V_ESQUEMA||'.mig_procs_subastas_lotes';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCS_SUBASTAS_LOTES... Tabla creada');
  END IF;

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MIG1_PROCS_SUBASTAS_LOTES_BIEN'' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      -- Si existe la tabla no hacemos nada
  IF V_NUM_TABLAS = 1 THEN 
     DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG1_PROCS_SUBASTAS_LOTES_BIEN... Tabla YA EXISTE');
  ELSE
     --Creamos la tabla
     V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.MIG1_PROCS_SUBASTAS_LOTES_BIEN as select * from '||V_ESQUEMA||'.mig_procs_subastas_lotes_bien';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MIG1_PROCS_SUBASTAS_LOTES_BIEN... Tabla creada');
  END IF;
  
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
