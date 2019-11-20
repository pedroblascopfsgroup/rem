--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5285
--## PRODUCTO=NO
--## Finalidad: Creación índices en GPL_GASTOS_PRINEX_LBK
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
    
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_INDEX NUMBER(3); -- Vble. auxiliar para la numeración de índices
    V_TABLA VARCHAR2(50 CHAR); -- Vble. auxiliar para almacenar el nombres de tablas
    V_INDICE VARCHAR2(50 CHAR); -- Vble. auxiliar para almacenar el nombre del índice
    V_NUM_COLS_INDEX NUMBER(2);--  Vble. auxiliar que indica el numero de columnas a los que apunta el ínidce

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 

    BEGIN
    
	
				-- GAC_GESTOR_ACT_HISTORICO_IDX
				V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPL_GASTOS_PRINEX_LBK_IDX_01'' ';
        
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
				IF V_NUM_TABLAS = 0 THEN
						V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK_IDX_01 ON '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK ( GPV_ID, ACT_ID ) TABLESPACE '||V_TABLESPACE_IDX;		
						EXECUTE IMMEDIATE V_MSQL;
						DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPL_GASTOS_PRINEX_LBK_IDX_01 - creado.');
				ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el índice GPL_GASTOS_PRINEX_LBK_IDX_01 ');
				END IF;

	
	COMMIT;



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

EXIT
