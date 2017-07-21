--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=p2.0.6-170728
--## INCIDENCIA_LINK=HREOS-2112
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

    ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
    V_TABLA   VARCHAR(30) :='TPD_TTR';
    V_INDICE    VARCHAR(30 CHAR) :='IDX_TPD_TTR'; --Nombre del índice
    V_COLUMNAS VARCHAR(30) :='DD_TPD_ID, DD_TTR_ID'; --Columnas del índice
    V_COLUMNA VARCHAR(30) :='DD_TPD_ID, DD_TTR_ID';
    V_SIGLAS VARCHAR2(3);--Prefijo para las FKs

    err_num NUMBER;
    err_msg VARCHAR2(2048);
    V_EXISTE NUMBER (1):=null;
    V_MSQL VARCHAR2(4000 CHAR);

    --Array para crear las claves foraneas
    TYPE T_FK IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
        ----  ESQUEMA_ORIGEN ------ TABLA_ORIGEN ----------- COLUMNA/AS INDICE ----------- ESQUEMA_DESTINO ----- TABLA_DESTINO ------------------             CAMPO_DESTINO -------     NOMBRE_F ----------------
        T_FK(''||V_ESQUEMA||''     ,''||V_TABLA||''         ,'DD_TPD_ID'                      ,''||V_ESQUEMA||''    ,'DD_TPD_TIPO_DOCUMENTO'                   ,'DD_TPD_ID'           ,'FK_TPD_TTR_DD_TPD_ID'),
        T_FK(''||V_ESQUEMA||''     ,''||V_TABLA||''         ,'DD_TTR_ID'                      ,''||V_ESQUEMA||''    ,'DD_TTR_TIPO_TRABAJO'                     ,'DD_TTR_ID'           ,'FK_TPD_TTR_DD_TTR_ID')
    );
    V_TMP_FK T_FK;

  --BLOQUES NECESARIOS
  FUNCTION EXISTE_TABLA(P_ESQUEMA IN VARCHAR2, P_TABLA IN VARCHAR2) RETURN NUMBER
  AS
    V_EXISTE NUMBER (1);

  BEGIN
    -- Comprobamos si existe la tabla
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||P_TABLA||''' and OWNER = '''||P_ESQUEMA||'''';

    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

    IF V_EXISTE = 0 THEN
        DBMS_OUTPUT.PUT_LINE ('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... Tabla no existe');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... Tabla ya existe');
    END IF;

    RETURN V_EXISTE;

  END EXISTE_TABLA;

  FUNCTION EXISTE_PK(P_ESQUEMA IN VARCHAR2, P_TABLA IN VARCHAR2) RETURN NUMBER
  AS
    V_EXISTE NUMBER (1);

  BEGIN
    --Comprobamos si existen PK de esa tabla
    V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||P_TABLA||''' and owner = '''||P_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';

    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

    IF V_EXISTE = 0 THEN
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... PK no existe');
    ELSE
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... PK ya existe');
    END IF;

    RETURN V_EXISTE;

  END EXISTE_PK;

  FUNCTION EXISTE_FK(P_ESQUEMA IN VARCHAR2, P_TABLA IN VARCHAR2, P_COLUMNA IN VARCHAR2) RETURN NUMBER
  AS
    V_EXISTE NUMBER (1);

  BEGIN
    --Comprobamos si existen FK de esa tabla
    V_MSQL := 'SELECT COUNT(1) FROM all_cons_columns WHERE TABLE_NAME = '''||P_TABLA||''' AND column_name= '''||P_COLUMNA||'''  and owner = '''||P_ESQUEMA||''' and CONSTRAINT_NAME like ''FK_%'' ';

    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

    IF V_EXISTE = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... FK no existe');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... FK ya existe');
    END IF;

    RETURN V_EXISTE;
  END EXISTE_FK;

  FUNCTION EXISTE_INDICE(P_ESQUEMA IN VARCHAR2, P_TABLA IN VARCHAR2, P_COLUMNAS IN VARCHAR2) RETURN NUMBER
  AS
    V_EXISTE NUMBER (1);

  BEGIN
    --Comprobamos si existe el índice en esa tabla
    V_MSQL := '
            SELECT COUNT(1)
              FROM( SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
                      FROM ALL_IND_COLUMNS
                     WHERE table_name = ''''||'''||P_TABLA||'''
                       AND index_owner='''' ||'''||P_ESQUEMA||'''
                     GROUP BY index_name
                  ) sqli
	           WHERE sqli.columnas = '''||P_COLUMNAS||'''
             ';

    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

    IF V_EXISTE = 0 THEN
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... Índice no existe');
    ELSE
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA || '.'||P_TABLA||'... Índice ya existe');
    END IF;

    RETURN V_EXISTE;

  END EXISTE_INDICE;

  PROCEDURE CREAR_COMENTARIO(P_ESQUEMA IN VARCHAR2, P_TABLA IN VARCHAR2, P_COLUMNA IN VARCHAR2, P_COMENTARIO IN VARCHAR2)
  AS

  BEGIN
    -- Creamos comentarios
    V_MSQL := 'COMMENT ON COLUMN '||P_ESQUEMA||'.'||P_TABLA||'.'||P_COLUMNA||' IS '''||P_COMENTARIO||''' ';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || P_ESQUEMA||'.'||P_TABLA||'.'||P_COLUMNA||'... Comentario creado');

  END CREAR_COMENTARIO;
  --FIN DE BLOQUES

BEGIN
/**************************************************************************/
/*********************** BLOQUE PRINCIPAL *********************************/
/**************************************************************************/
    IF EXISTE_TABLA(V_ESQUEMA, V_TABLA) = 0 THEN
        V_MSQL :=
                'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                    (
                      DD_TPD_ID NUMBER (16,0) NOT NULL ENABLE,
                      DD_TTR_ID NUMBER (16,0) NOT NULL ENABLE,
                      VERSION    NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE
                    )
                ';

      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... tabla creada');
    END IF;

    --CREAR_COMENTARIO(V_ESQUEMA, V_TABLA, V_COLUMNA, 'Clave principal con su correspondiente secuencia'/*V_COMENTARIO*/);

    IF EXISTE_PK(V_ESQUEMA, V_TABLA) = 0 THEN
      V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD (CONSTRAINT PK_'||V_TABLA||' PRIMARY KEY ('||V_COLUMNA||')  )';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_'||V_TABLA||'... PK creada');
    END IF;

    --------------------------------
    ---     CLAVES FORANEAS      ---
    --------------------------------
    FOR J IN V_FK.FIRST .. V_FK.LAST
    LOOP
        V_TMP_FK := V_FK(J);

        IF EXISTE_FK(V_TMP_FK(1), V_TMP_FK(2), V_TMP_FK(3)) = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Creando '||V_TMP_FK(7)||'...');

            EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_FK(1)||'.'||V_TMP_FK(2)||'
                ADD (CONSTRAINT '||V_TMP_FK(7)||' FOREIGN KEY ('||V_TMP_FK(3)||')
                REFERENCES '||V_TMP_FK(4)||'.'||V_TMP_FK(5)||' ('||V_TMP_FK(6)||') ON DELETE SET NULL)
            ';
        END IF;
    END LOOP;
    --------------------------------
    ---    FIN CLAVES FORANEAS   ---
    --------------------------------

--    IF EXISTE_INDICE(V_ESQUEMA, V_TABLA, V_COLUMNAS) = 0 THEN
--      V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||V_INDICE||' ON '||V_ESQUEMA||'.'||V_TABLA||'
--          ('||V_COLUMNAS||') TABLESPACE '||ITABLE_SPACE||'';
--
--        EXECUTE IMMEDIATE V_MSQL;
--        DBMS_OUTPUT.PUT_LINE(V_TABLA||'.'||V_INDICE||' CREADO');
--
--    END IF;

    COMMIT;

EXCEPTION
WHEN OTHERS THEN
  err_num := SQLCODE;
  err_msg := SQLERRM;
  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  ROLLBACK;
  RAISE;
END;
/
EXIT
