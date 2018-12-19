--/*
--##########################################
--## AUTOR=CARLOS SALMERON
--## FECHA_CREACION=20181213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5015
--## PRODUCTO=NO
--## Finalidad: DML Para eliminar estado alquiler con demandas 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):=	'#ESQUEMA#';			-- Configuracion Esquema
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA_M VARCHAR2(25 CHAR):=	'#ESQUEMA_MASTER#';		-- Configuracion Esquema Master
    V_TABLA VARCHAR2(27 CHAR):= 'DD_EAL_ESTADO_ALQUILER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    V_USU VARCHAR(30 CHAR):=	'HREOS-5015';		--Vble para almacenar el nombre de usuario a insertar.

BEGIN


  DBMS_OUTPUT.PUT_LINE('[INICIO] ELIMINAR VALOR'); 
  
  --Comprobamos que existe la tabla
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 1 THEN
	
  --Comprobamos que la modificacion no existe
  
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || V_TABLA || ' WHERE DD_EAL_DESCRIPCION = ''Con demandas'' and BORRADO = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.put_line('[INFO] La modificacion ya existe');
  		ELSE
			execute immediate 'UPDATE ' || V_ESQUEMA || '.' || V_TABLA || '  SET BORRADO = 1, FECHABORRAR = SYSDATE, USUARIOBORRAR = '''||V_USU|| ''' WHERE DD_EAL_DESCRIPCION = ''Con demandas'' ';
	 	 	DBMS_OUTPUT.PUT_LINE('ELIMINADO CORRECTAMENTE');
	 	END IF;
	  
	ELSE 
		DBMS_OUTPUT.put_line('[INFO] No existe la tabla');
		
	END IF;
    
COMMIT;


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
