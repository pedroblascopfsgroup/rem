--/*
--##########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161014
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HRE0S-962
--## PRODUCTO=NO
--## Finalidad: ANADIR EL CAMPO PVE_COD_DIRECC_UVEM A LA TABLA ACT_PRD_PROVEEDOR_DIRECCION
--##           
--## INSTRUCCIONES: Usuario migración
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
      ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
      ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
      
      V_TABLA VARCHAR2(30 CHAR) := 'ACT_PRD_PROVEEDOR_DIRECCION'; -- Vble. con el nombre de la tabla afectada
      V_CAMPO VARCHAR2(30 CHAR) := 'PVE_COD_DIRECC_UVEM'; -- Vble. con el nombre del nuevo campo
	
BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO PARA CREAR EL CAMPO '||V_CAMPO||' EN LA TABLA '||V_TABLA);

      DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBACIONES PREVIAS...');
      
      V_SQL := ' SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_CAMPO||''' AND OWNER = '''||V_ESQUEMA||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
      
      IF V_NUM_TABLAS > 0 THEN            
            DBMS_OUTPUT.PUT_LINE('[INFO] EL CAMPO YA ESTÁ CREADO');
      ELSE        
            DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO EL CAMPO...');
            V_SQL := 'ALTER TABLE '||V_TABLA||' ADD '||V_CAMPO||' NUMBER(16)';      
            EXECUTE IMMEDIATE V_SQL ;      
            DBMS_OUTPUT.put_line('[INFO] CAMPO CREADO');
      END IF ;
      
      COMMIT;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] FIN');


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
