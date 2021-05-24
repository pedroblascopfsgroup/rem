--/*
--##########################################
--## AUTOR=Josep Ros
--## FECHA_CREACION=20200924
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3.06
--## INCIDENCIA_LINK=HREOS-10463
--## PRODUCTO=NO
--## Finalidad: DDL para anyadir una nueva columna
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

    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_TABLENAME VARCHAR2(32 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_EXISTE_CAMPO_TABLA_UNO NUMBER:= 0;
    V_EXISTE_CAMPO_TABLA_DOS NUMBER:= 0;
    V_ID_SINO NUMBER:= 0;


BEGIN    
  
    V_TABLENAME := 'ACT_REG_INFO_REGISTRAL';

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''ACT_REG_INFO_REGISTRAL'' AND COLUMN_NAME = ''TIENE_ANEJOS_REGISTRALES'' AND NULLABLE = ''N'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_CAMPO_TABLA_UNO;

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA_M||''' AND TABLE_NAME = ''DD_SIN_SINO'' AND COLUMN_NAME = ''DD_SIN_ID''';
	EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_CAMPO_TABLA_DOS;
    
    V_MSQL := 'SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02''';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_SINO;



			
		--COMPROBAMOS SI EXISTE EL CAMPO UNO
		IF (V_EXISTE_CAMPO_TABLA_UNO = 0 AND V_EXISTE_CAMPO_TABLA_DOS = 1) THEN
		EXECUTE IMMEDIATE ' ALTER TABLE ' || V_ESQUEMA || '.' || V_TABLENAME || ' ADD (
				   TIENE_ANEJOS_REGISTRALES NUMBER(16,0) DEFAULT '||V_ID_SINO||' NOT NULL, 
				  CONSTRAINT fk_GCO_ID FOREIGN KEY (TIENE_ANEJOS_REGISTRALES) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO(DD_SIN_ID))';

            V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLENAME||'.TIENE_ANEJOS_REGISTRALES IS ''Marca si el activo tiene anejos registrales''';
            EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ASA_NUMERO_DOMICILIO creado.');
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado el campo con la clave foranea');
		ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] El Campo ya ha sido creado');
		END IF;
          
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLENAME || '... FIN cambios en la tabla.');
 

     
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
