--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20180214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO= v2.0.15
--## INCIDENCIA_LINK=HREOS-3819
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SEG_SUBTIPO_ERROR_GASTO los tipos de error definidos en gestorias 
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia del registro.  
    V_NUM_TIPO   NUMBER(16); -- Vble. para validar la existencia de la tabla de tipos.    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(200 CHAR) := 'DD_SEG_SUBTIPO_ERROR_GASTO';
    V_DD_TEG_ID NUMBER(1) := 4;
    V_DD_SEG_CODIGO_1 VARCHAR2(5 CHAR) := '406';
    V_DD_SEG_CODIGO_2 VARCHAR2(5 CHAR) := '413';
    V_USUARIO_CREAR VARCHAR2(50 CHAR) := 'HREOS-3819';
    
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        WHERE DD_TEG_ID = '||V_DD_TEG_ID||' AND DD_SEG_CODIGO = '''||V_DD_SEG_CODIGO_1||'''';

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_REG;
    
    IF V_NUM_REG < 1 THEN
    
        EXECUTE IMMEDIATE 'INSERT INTO DD_SEG_SUBTIPO_ERROR_GASTO 
            (DD_SEG_ID, DD_TEG_ID, DD_SEG_CODIGO, DD_SEG_DESCRIPCION, DD_SEG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
        VALUES 
            (S_DD_SEG_SUBTIPO_ERROR_GASTO.NEXTVAL, '||V_DD_TEG_ID||', '''||V_DD_SEG_CODIGO_1||''', 
            ''406 - SOCIEDAD PAGAD'', ''406 - SOCIEDAD PAGADORA NO VÁLIDA'', '''||V_USUARIO_CREAR||''', SYSDATE)';
    
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO '||V_DD_SEG_CODIGO_1||' ACTUALIZADO CORRECTAMENTE ');
    
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        WHERE DD_TEG_ID = '||V_DD_TEG_ID||' AND DD_SEG_CODIGO = '''||V_DD_SEG_CODIGO_2||'''';

    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_REG;
    
    IF V_NUM_REG < 1 THEN
    
        EXECUTE IMMEDIATE 'INSERT INTO DD_SEG_SUBTIPO_ERROR_GASTO 
            (DD_SEG_ID, DD_TEG_ID, DD_SEG_CODIGO, DD_SEG_DESCRIPCION, DD_SEG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
        VALUES 
            (S_DD_SEG_SUBTIPO_ERROR_GASTO.NEXTVAL, '||V_DD_TEG_ID||', '''||V_DD_SEG_CODIGO_2||''', 
            ''413 - CODIGO TIPO OP'', ''413 - CODIGO TIPO OPERACIÓN INVALIDO'', '''||V_USUARIO_CREAR||''', SYSDATE)';
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO '||V_DD_SEG_CODIGO_2||' ACTUALIZADO CORRECTAMENTE');
    
    END IF;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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