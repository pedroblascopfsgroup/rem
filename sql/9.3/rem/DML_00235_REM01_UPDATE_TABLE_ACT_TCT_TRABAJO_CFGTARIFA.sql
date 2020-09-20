--/*
--##########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20200920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11267
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza ACT_TCT_TRABAJO_CFGTARIFA
--## INSTRUCCIONES:
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TCT_TRABAJO_CFGTARIFA';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_TRG_TIPO_RECARGO_GASTO';  -- Tabla a modificar   
    V_USR VARCHAR2(30 CHAR) := 'HREOS-11267'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_CDG VARCHAR2(30 CHAR) := 'TCT';
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
			

        V_SQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = ''TCT_PRECIO_UNITARIO_CLIENTE'' and owner = '''||V_ESQUEMA||'''' ;
        DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: LA COLUMNA EXISTE');
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LA TABLA');

       	  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' TCT
            USING (
            SELECT TCT.TCT_ID, TCT.TCT_PRECIO_UNITARIO
            FROM '||V_ESQUEMA||'.'||V_TABLA||' TCT
            WHERE TCT.BORRADO = 0 AND TCT_PRECIO_UNITARIO_CLIENTE IS NULL
            ) AUX
            ON(TCT.TCT_ID = AUX.TCT_ID)
            WHEN MATCHED THEN UPDATE SET
              TCT.TCT_PRECIO_UNITARIO_CLIENTE = AUX.TCT_PRECIO_UNITARIO
              , TCT.USUARIOMODIFICAR = '''||V_USR||'''
              , TCT.FECHAMODIFICAR = SYSDATE';
                   
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS MODIFICADOS CORRECTAMENTE');
          END IF;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
   

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



   
