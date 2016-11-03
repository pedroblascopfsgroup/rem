--/*
--##########################################
--## AUTOR=Ramon Llinares
--## FECHA_CREACION=20161103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=867
--## PRODUCTO=NO
--## Finalidad: UK idwebcom
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
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    v_fk_count number(16);

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
    
BEGIN

 -- Tabla ACT_ICO_INFO_COMERCIAL
    V_TEXT_TABLA := 'ACT_ICO_INFO_COMERCIAL';

 -- Comprobamos si ya existe la UK
    V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''UK_ID_WEBCOM'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la UK UK_ID_WEBCOM EN LA TABLA '||V_TEXT_TABLA||' LA CREAMOS');
      -- Creamos uk	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT UK_ID_WEBCOM UNIQUE (ICO_WEBCOM_ID)';		
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... YA EXISTE UK UK_ID_WEBCOM EN LA TABLA '||V_TEXT_TABLA||' ');
    END IF;

 -- Tabla OFR_OFERTAS
    V_TEXT_TABLA := 'OFR_OFERTAS';

 -- Comprobamos si ya existe la UK
    V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''UK_ID_WEBCOM_OFR'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la UK UK_ID_WEBCOM_OFR EN LA TABLA '||V_TEXT_TABLA||' LA CREAMOS');
      -- Creamos uk	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT UK_ID_WEBCOM_OFR UNIQUE (OFR_WEBCOM_ID)';		
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... YA EXISTE UK UK_ID_WEBCOM_OFR EN LA TABLA '||V_TEXT_TABLA||' ');
    END IF;

 -- Tabla ACT_TBJ_TRABAJO
    V_TEXT_TABLA := 'ACT_TBJ_TRABAJO';

 -- Comprobamos si ya existe la UK
    V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''UK_ID_WEBCOM_TBJ'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la UK UK_ID_WEBCOM_TBJ EN LA TABLA '||V_TEXT_TABLA||' LA CREAMOS');
      -- Creamos uk	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT UK_ID_WEBCOM_TBJ UNIQUE (TBJ_WEBCOM_ID)';		
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... YA EXISTE UK UK_ID_WEBCOM_TBJ EN LA TABLA '||V_TEXT_TABLA||' ');
    END IF;

 -- Tabla VIS_VISITAS
    V_TEXT_TABLA := 'VIS_VISITAS';

 -- Comprobamos si ya existe la UK
    V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''UK_ID_WEBCOM_VIS'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la UK UK_ID_WEBCOM_VIS EN LA TABLA '||V_TEXT_TABLA||' LA CREAMOS');
      -- Creamos uk	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT UK_ID_WEBCOM_VIS UNIQUE (VIS_WEBCOM_ID)';		
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... YA EXISTE UK UK_ID_WEBCOM_VIS EN LA TABLA '||V_TEXT_TABLA||' ');
    END IF;

 -- Tabla CLC_CLIENTE_COMERCIAL
    V_TEXT_TABLA := 'CLC_CLIENTE_COMERCIAL';

 -- Comprobamos si ya existe la UK
    V_MSQL := 'SELECT count(1) CONSTRAINT_NAME FROM all_constraints where CONSTRAINT_NAME = ''UK_ID_WEBCOM_CLC'' 
                        AND TABLE_NAME= '''||V_TEXT_TABLA||'''
                        and owner = '''||V_ESQUEMA||'''
                        ';
    EXECUTE IMMEDIATE V_MSQL INTO v_fk_count;

    IF v_fk_count = 0 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... No existe la UK UK_ID_WEBCOM_CLC EN LA TABLA '||V_TEXT_TABLA||' LA CREAMOS');
      -- Creamos uk	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT UK_ID_WEBCOM_CLC UNIQUE (CLC_WEBCOM_ID)';		
      EXECUTE IMMEDIATE V_MSQL;
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... YA EXISTE UK UK_ID_WEBCOM_CLC EN LA TABLA '||V_TEXT_TABLA||' ');
    END IF;
  
  
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
