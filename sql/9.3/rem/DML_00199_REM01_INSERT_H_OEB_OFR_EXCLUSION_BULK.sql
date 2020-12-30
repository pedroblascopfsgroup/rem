--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9964
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea regostro en la nueva tabla de histórico de Exclusión de los Bulk
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9964';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
 	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''H_OEB_OFR_EXCLUSION_BULK'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS = 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA TABLA H_OEB_OFR_EXCLUSION_BULK');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS');  

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.H_OEB_OFR_EXCLUSION_BULK OEB
                    (
                      OEB.OEB_ID
                      , OEB.OFR_ID
                      , OEB.OEB_EXCLUSION_BULK
                      , OEB.OEB_FECHA_INI
                      , OEB.USUARIOCREAR
                      , OEB.FECHACREAR
                    )
                    SELECT 
                    '||V_ESQUEMA||'.S_H_OEB_OFR_EXCLUSION_BULK.NEXTVAL OEB_ID
                    , OFR.OFR_ID
                    , OFR.OFR_EXCLUSION_BULK OEB_EXCLUSION_BULK
                    , OFR.FECHAMODIFICAR OEB_FECHA_INI
                    , ''HREOS-9964'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                    WHERE OFR.BORRADO = 0
                    AND OFR.FECHAMODIFICAR IS NOT NULL';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS CREADOS CORRECTAMENTE EN H_OEB_OFR_EXCLUSION_BULK: ' ||sql%rowcount);

      -- Verificar si la tabla ya existe
      V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_OFR_EXCLUSION_BULK''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
      IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS DROP CONSTRAINT FK_OFR_EXCLUSION_BULK';     
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADA FK_OFR_EXCLUSION_BULK');
      ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE FK_OFR_EXCLUSION_BULK');
      END IF;

      V_MSQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''OFR_OFERTAS'' AND COLUMN_NAME = ''OFR_EXCLUSION_BULK''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
      IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.OFR_OFERTAS DROP COLUMN OFR_EXCLUSION_BULK';     
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADA COLUMNA OFR_EXCLUSION_BULK');
      ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA COLUMNA OFR_EXCLUSION_BULK');
      END IF;

    END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: MODIFICADO CORRECTAMENTE ');
   

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
