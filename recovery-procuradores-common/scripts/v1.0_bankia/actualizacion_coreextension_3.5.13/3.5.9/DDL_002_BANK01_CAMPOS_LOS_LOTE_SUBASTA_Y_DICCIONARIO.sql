--/*
--##########################################
--## Author: #AUTOR#
--## Subject: Campos adicionales para guardar estado en lote de subasta. También inicializa los valores actuales.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    DD_TABLE_NAME VARCHAR2(18 CHAR) := 'DD_EPI_EST_INSTRU'; 
    ESTADO_PROPUESTA NUMBER(16,0);  -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** [INICIO] Creando ' || DD_TABLE_NAME || ' ********'); 
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||DD_TABLE_NAME||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN	-- Si existe la PK
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||DD_TABLE_NAME||'
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||DD_TABLE_NAME||'... Claves primarias eliminadas');	
    END IF;
    V_SQL := 'select count(1) from all_tables where table_name='''||DD_TABLE_NAME||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE  V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||DD_TABLE_NAME||'... borrando');  
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||DD_TABLE_NAME||' CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||DD_TABLE_NAME||'... Tabla borrada');  
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || '
      (
        "DD_EPI_ID" NUMBER(16,0) NOT NULL ENABLE,
        "DD_EPI_CODIGO" VARCHAR2(10 CHAR) NOT NULL ENABLE,
        "DD_EPI_DESCRIPCION" VARCHAR2(50 CHAR) NOT NULL ENABLE,
        "DD_EPI_DESCRIPCION_LARGA" VARCHAR2(200 CHAR) NOT NULL ENABLE,
        "VERSION" NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE,
        "USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE,
        "FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE,
        "USUARIOMODIFICAR" VARCHAR2(10 CHAR),
        "FECHAMODIFICAR" TIMESTAMP (6),
        "USUARIOBORRAR" VARCHAR2(10 CHAR),
        "FECHABORRAR" TIMESTAMP (6),
        "BORRADO" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
      )';
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || '... Tabla creada OK');	
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_EPI_EST_CODIGO ON ' || V_ESQUEMA || '.'|| DD_TABLE_NAME || ' (DD_EPI_CODIGO)';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||DD_TABLE_NAME||' ADD (
                  CONSTRAINT PK_DD_EPI_EST_INST PRIMARY KEY (DD_EPI_ID),
                  CONSTRAINT UK_DD_EPI_EST_CODIGO UNIQUE (DD_EPI_CODIGO)
                  )';						
    EXECUTE IMMEDIATE V_MSQL;

    V_SQL := 'select count(1) from all_sequences where sequence_name = ''S_DD_EPI_EST_PROP_INST'' and sequence_owner = ''' || V_ESQUEMA || '''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
		EXECUTE IMMEDIATE ' DROP SEQUENCE '|| V_ESQUEMA ||'.S_DD_EPI_EST_PROP_INST ';
		DBMS_OUTPUT.PUT_LINE('DROP SEQUENCE '|| V_ESQUEMA ||'.S_DD_EPI_EST_PROP_INST... Secuencia borrada...');
	END IF;
	EXECUTE IMMEDIATE '
	CREATE SEQUENCE '|| V_ESQUEMA ||'.S_DD_EPI_EST_PROP_INST
	  START WITH 1
	  MAXVALUE 9999999999999999
	  MINVALUE 1
	  NOCYCLE
	  CACHE 100
	  NOORDER';
	  DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE '|| V_ESQUEMA ||'.S_DD_EPI_EST_PROP_INST... Secuencia creada OK');
    DBMS_OUTPUT.PUT_LINE('******** [Fin] ' || DD_TABLE_NAME || ' creado ********'); 


    DBMS_OUTPUT.PUT_LINE('******** [INICIO] Creando registros para DD '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || '********'); 
    V_SQL := 'select ' || V_ESQUEMA || '.S_DD_EPI_EST_PROP_INST.nextVal FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO ESTADO_PROPUESTA;
	V_SQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || ' (DD_EPI_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, DD_EPI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
      ('||ESTADO_PROPUESTA||', ''CONFORMADA'', ''En preparación'', ''En preparación'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'select ' || V_ESQUEMA || '.S_DD_EPI_EST_PROP_INST.nextVal FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO ESTADO_PROPUESTA;
    V_SQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || ' (DD_EPI_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, DD_EPI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
      ('||ESTADO_PROPUESTA||', ''PROPUESTA'', ''Propuesta pendiente comité'', ''Propuesta pendiente comité'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'select ' || V_ESQUEMA || '.S_DD_EPI_EST_PROP_INST.nextVal FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO ESTADO_PROPUESTA;
    V_SQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || ' (DD_EPI_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, DD_EPI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
      ('||ESTADO_PROPUESTA||', ''APROBADA'', ''Aprobada'', ''Aprobada'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'select ' || V_ESQUEMA || '.S_DD_EPI_EST_PROP_INST.nextVal FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO ESTADO_PROPUESTA;
    V_SQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || ' (DD_EPI_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, DD_EPI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
      ('||ESTADO_PROPUESTA||',  ''DEVUELTA'', ''Devuelta'', ''Devuelta'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'select ' || V_ESQUEMA || '.S_DD_EPI_EST_PROP_INST.nextVal FROM DUAL';
	EXECUTE IMMEDIATE V_SQL INTO ESTADO_PROPUESTA;
    V_SQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || ' (DD_EPI_ID, DD_EPI_CODIGO, DD_EPI_DESCRIPCION, DD_EPI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES
      ('||ESTADO_PROPUESTA||',  ''SUSPENDIDA'', ''Suspendida'', ''Suspendida'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('******** [FIN] Registros DD '|| V_ESQUEMA ||'.'|| DD_TABLE_NAME || ' creados ********'); 
    

    DBMS_OUTPUT.PUT_LINE('******** [INICIO] LOS_LOTE_SUBASTA ********'); 
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_RIESGO_CONSIG ... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''LOS_RIESGO_CONSIG'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS >0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_RIESGO_CONSIG ... Borrando'); 
    	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA DROP (LOS_RIESGO_CONSIG)';
      V_NUM_TABLAS:=0;
    END IF;
    IF V_NUM_TABLAS = 0 THEN	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (LOS_RIESGO_CONSIG NUMBER(1) NULL)';		
		EXECUTE IMMEDIATE V_MSQL;  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA... Campo LOS_RIESGO_CONSIG creado');	
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_DEUDA_JUDICIAL ... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''LOS_DEUDA_JUDICIAL'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS >0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_DEUDA_JUDICIAL ... Borrando'); 
    	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA DROP (LOS_DEUDA_JUDICIAL)';
      V_NUM_TABLAS:=0;
    END IF;
    IF V_NUM_TABLAS = 0 THEN	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (LOS_DEUDA_JUDICIAL NUMBER(16,2) NULL)';		
		EXECUTE IMMEDIATE V_MSQL;  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA... Campo LOS_DEUDA_JUDICIAL creado');	
    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_OBSERVACION_COMITE ... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''LOS_OBSERVACION_COMITE'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS >0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_OBSERVACION_COMITE ... Borrando'); 
    	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA DROP (LOS_OBSERVACION_COMITE)';
      V_NUM_TABLAS:=0;
    END IF;
    IF V_NUM_TABLAS = 0 THEN	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (LOS_OBSERVACION_COMITE VARCHAR2(2000 CHAR) NULL)';		
		EXECUTE IMMEDIATE V_MSQL;  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA... Campo LOS_OBSERVACION_COMITE creado');	
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.DD_EPI_ID ... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''DD_EPI_ID'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS >0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.DD_EPI_ID ... Borrando'); 
    	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA DROP (DD_EPI_ID)';
      V_NUM_TABLAS:=0;
    END IF;
    IF V_NUM_TABLAS = 0 THEN	
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.DD_EPI_ID ... Creando'); 
      --V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (DD_EPI_ID NUMBER(16) DEFAULT '||ESTADO_PROPUESTA||' NOT NULL)';		
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (DD_EPI_ID NUMBER(16) NULL)';		
      EXECUTE IMMEDIATE V_MSQL;  
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA... Campo DD_EPI_ID creado');	
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_INDEXES WHERE INDEX_NAME=''IDX01_DD_EPI_ID'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS>0 THEN	
      EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.IDX01_DD_EPI_ID';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA ... Indice borrado');
    END IF;
    V_MSQL := 'CREATE INDEX ' || V_ESQUEMA || '.IDX01_DD_EPI_ID ON ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA (DD_EPI_ID)';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA ... Indice creado');

    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_CONSTRAINTS WHERE CONSTRAINT_TYPE=''R'' AND CONSTRAINT_NAME=''FK_LOS_LOTE_DD_EPI_ID'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS>0 THEN	
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA ... Constraint borrando');
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA 
                      DROP CONSTRAINT FK_LOS_LOTE_DD_EPI_ID';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA ... Constraint borrado');
    END IF;
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA ADD (
        CONSTRAINT FK_LOS_LOTE_DD_EPI_ID FOREIGN KEY(DD_EPI_ID) REFERENCES ' || V_ESQUEMA || '.DD_EPI_EST_INSTRU (DD_EPI_ID)
        )';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA ... FK Creada');         
      
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_FECHA_ESTADO ... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''LOS_FECHA_ESTADO'' AND TABLE_NAME=''LOS_LOTE_SUBASTA'' AND OWNER=''' || V_ESQUEMA || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS >0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA.LOS_FECHA_ESTADO ... Borrando'); 
    	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA DROP (LOS_FECHA_ESTADO)';
      V_NUM_TABLAS:=0;
    END IF;
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (LOS_FECHA_ESTADO TIMESTAMP(6) NULL)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.LOS_LOTE_SUBASTA... Campo LOS_FECHA_ESTADO creado');	
    END IF;

    DBMS_OUTPUT.PUT_LINE('******** [FIN] LOS_LOTE_SUBASTA ********'); 

    
    DBMS_OUTPUT.PUT_LINE('******** [INICIO] MIGRACION DATOS LOS_LOTE_SUBASTA ********'); 
    DBMS_OUTPUT.PUT_LINE('******** Estados PReparar y Validar'); 
    EXECUTE IMMEDIATE 'merge into '||V_ESQUEMA||'.los_lote_subasta LOS1 ' ||
        'using (select ' ||
        '      los.los_id, ' ||
        '      CASE WHEN tap.tap_codigo IN (''P401_PrepararPropuestaSubasta'',''P409_PrepararPropuestaSubasta'') THEN  ' ||
        '      (select DD_EPI_ID from '||V_ESQUEMA||'.DD_EPI_EST_INSTRU where DD_EPI_CODIGO=''CONFORMADA'') ' ||
        '      WHEN tap.tap_codigo IN (''P401_ValidarPropuesta'', ''P409_ValidarPropuesta'') THEN ' ||
        '      (select DD_EPI_ID from '||V_ESQUEMA||'.DD_EPI_EST_INSTRU where DD_EPI_CODIGO=''PROPUESTA'') ' ||
        '      ELSE  ' ||
        '      NULL ' ||
        '      END AS DD_EPI_ID, tar.FECHACREAR AS LOS_FECHA_ESTADO ' ||
        'from '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar ' ||
        '  inner join '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex on tex.tar_id=tar.tar_id  ' ||
        '                      and tar.BORRADO=0 ' ||
        '                      and tex.BORRADO=0 ' ||
        '                      and tar.TAR_FECHA_FIN is null  ' ||
        '                      and nvl(tar.TAR_TAREA_FINALIZADA,0)=0 ' ||
        '  inner join '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap on tap.tap_id=tex.tap_id ' ||
        '                      and tap.BORRADO=0 ' ||
        '                      and tap.tap_codigo in (''P409_PrepararPropuestaSubasta'',''P409_ValidarPropuesta'', ' ||
        '                                          ''P401_PrepararPropuestaSubasta'',''P401_ValidarPropuesta'') ' ||
        '  inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc on prc.prc_id=tar.prc_id and prc.BORRADO=0 ' ||
        '  inner join '||V_ESQUEMA||'.SUB_SUBASTA sub on sub.prc_id=prc.prc_id ' ||
        '  inner join '||V_ESQUEMA||'.LOS_LOTE_SUBASTA los on los.sub_id=sub.sub_id  ' ||
        '      and los.borrado=0  ' ||
        '      and los.DD_EPI_ID is null ' ||
        '      ) tmp ' ||
        ' on  (LOS1.los_id=tmp.los_id) ' ||
        ' when matched then ' ||
        '  update set ' ||
        '    DD_EPI_ID=tmp.DD_EPI_ID, ' ||
        '    LOS_FECHA_ESTADO=tmp.LOS_FECHA_ESTADO';
 
    DBMS_OUTPUT.PUT_LINE('******** Suspendidas, Pendientes celebración, pdte. aceptación y celebradas'); 
        EXECUTE IMMEDIATE 'merge into '||V_ESQUEMA||'.los_lote_subasta LOS1  ' ||
          'using (select los.los_id, ' ||
          '        (select DD_EPI_ID from '||V_ESQUEMA||'.DD_EPI_EST_INSTRU where DD_EPI_CODIGO=''SUSPENDIDA'') AS DD_EPI_ID, ' ||
          '        sub.FECHACREAR AS LOS_FECHA_ESTADO ' ||
          '        from '||V_ESQUEMA||'.SUB_SUBASTA sub ' ||
          '        inner join '||V_ESQUEMA||'.LOS_LOTE_SUBASTA los on los.sub_id=sub.sub_id  ' ||
          '            and los.borrado=0  ' ||
          '            and sub.borrado=0  ' ||
          '            and los.DD_EPI_ID is null ' ||
          '        inner join '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA esu on esu.DD_ESU_ID=sub.DD_ESU_ID  ' ||
          '              and  esu.DD_ESU_CODIGO IN (''SUS'', ''CEL'' ,''PAC'' ,''PCE'') ' ||
          ') tmp ' ||
          'on (tmp.los_id=LOS1.los_id) ' ||
          'when matched then ' ||
          '  update set ' ||
          '    DD_EPI_ID=tmp.DD_EPI_ID, ' ||
          '    LOS_FECHA_ESTADO=tmp.LOS_FECHA_ESTADO ';
 
 
    DBMS_OUTPUT.PUT_LINE('******** Resto de lotes'); 
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.LOS_LOTE_SUBASTA set  ' ||
        'DD_EPI_ID=(select DD_EPI_ID from '||V_ESQUEMA||'.DD_EPI_EST_INSTRU where DD_EPI_CODIGO=''CONFORMADA''), ' ||
        'LOS_FECHA_ESTADO=sysdate ' ||
        'where DD_EPI_ID is  null';
      EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.LOS_LOTE_SUBASTA set LOS_RIESGO_CONSIG=0, LOS_DEUDA_JUDICIAL=0';
    COMMIT;    
    DBMS_OUTPUT.PUT_LINE('******** [FIN] MIGRACION DATOS LOS_LOTE_SUBASTA ********'); 
    
    --DBMS_OUTPUT.PUT_LINE('******** [INICIO] ALTER COLUMN a NOT NULL ********'); 
    --EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA MODIFY LOS_RIESGO_CONSIG NUMBER(1) NOT NULL';
    --EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA MODIFY LOS_DEUDA_JUDICIAL NUMBER(16,2) NOT NULL';
    --EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA MODIFY DD_EPI_ID NUMBER(16) NOT NULL';
    --EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA MODIFY LOS_FECHA_ESTADO TIMESTAMP(6) NOT NULL';
    --DBMS_OUTPUT.PUT_LINE('******** [FIN] ALTER COLUMN a NOT NULL ********'); 

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
