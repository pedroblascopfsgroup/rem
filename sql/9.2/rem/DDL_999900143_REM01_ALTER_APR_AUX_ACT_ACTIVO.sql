--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20171026
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3036
--## PRODUCTO=NO
--## Finalidad: Inserción de nuevos campos en APR_AUX_ACT_ACTIVO
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(50 CHAR):= 'APR_AUX_ACT_ACTIVO';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('******** '''||V_TABLA||''' - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' 
			  AND COLUMN_NAME IN 
			  (
			  ''DD_SUBCARTERA'',''SOCIEDAD_ACREEDORA'',''CODIGO_SOCIEDAD_ACREEDORA'',''IMPORTE_DEUDA'',''NUM_EXP_RIESGO'',''PRECIO_MIN_VENTA'',''TIPO_PRECIO_MIN'',''FECHA_ALTA_MIN'',
			  ''PRECIO_APROB_VENTA'',''TIPO_PRECIO_APROB'',''FECHA_ALTA_APROB'',''MEDIADOR'',''AGR_NOMBRE'',''AGR_DESCRIPCION'',''AGR_NUM_AGRUPACION_REM'',''AGR_FECHA_ALTA'',''AGR_INI_VIGENCIA'',''AGR_FIN_VIGENCIA'',
			  ''AGR_TEXTO_WEB'',''AJD_FECHA_SEN_POSESION'',''TIT_FECHA_INSC_REG'',''PROMOCION'',''SPS_ACC_TAPIADO''
			  )';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Los nuevos campos ya existen en la tabla. NO SE HACE NADA');
    ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
				  ADD (DD_SUBCARTERA VARCHAR2(20 CHAR),
			      SOCIEDAD_ACREEDORA VARCHAR2(100 CHAR),
			      CODIGO_SOCIEDAD_ACREEDORA NUMBER(16,0),
				  IMPORTE_DEUDA NUMBER(16,2),
				  NUM_EXP_RIESGO VARCHAR2(20 CHAR),
				  PRECIO_MIN_VENTA NUMBER(16,2),
				  TIPO_PRECIO_MIN VARCHAR2(20 CHAR),
				  FECHA_ALTA_MIN DATE,
				  PRECIO_APROB_VENTA NUMBER(16,2),
				  TIPO_PRECIO_APROB VARCHAR2(20 CHAR),
				  FECHA_ALTA_APROB DATE,
				  MEDIADOR VARCHAR2(50 CHAR),
				  AGR_NOMBRE VARCHAR2(250 CHAR),
				  AGR_DESCRIPCION VARCHAR2(250 CHAR),
				  AGR_NUM_AGRUPACION_REM NUMBER(16,0),
				  AGR_FECHA_ALTA DATE,
				  AGR_INI_VIGENCIA DATE,
				  AGR_FIN_VIGENCIA DATE,
				  AGR_TEXTO_WEB VARCHAR2(2500 CHAR), 
				  AJD_FECHA_SEN_POSESION DATE,
				  TIT_FECHA_INSC_REG DATE,
				  PROMOCION NUMBER(16,0),
				  SPS_ACC_TAPIADO NUMBER(1,0)
				  )';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se han añadido los nuevos campos con exito');
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
