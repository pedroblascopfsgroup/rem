--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4449
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_3 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS_3 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4449'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_ACT_ETP_ENTIDAD_PROVEEDOR';  -- Tabla a modificar 
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCION ACT_ETP_ENTIDAD_PROVEEDOR');
	
	V_SQL := 'SELECT COUNT(1)
			   FROM ACT_ETP_ENTIDAD_PROVEEDOR
			   WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15'')
			   AND PVE_ID = (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = ''B02386431'')';
			   
	V_SQL_2 := 'SELECT COUNT(1) FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15''';
	
	V_SQL_3 := 'SELECT COUNT(1) FROM ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = ''B02386431''';
			   
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	EXECUTE IMMEDIATE V_SQL_2 INTO V_NUM_TABLAS_2;
	
	IF V_NUM_TABLAS = 0 AND V_NUM_TABLAS_2 = 1 AND V_NUM_TABLAS_3 = 1 THEN

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR 
			  (ETP_ID, 
			  DD_CRA_ID, 
			  PVE_ID, 
			  DD_TCL_ID, 
			  VERSION, 
			  USUARIOCREAR, 
			  FECHACREAR,
			  BORRADO)
			  SELECT 
					'||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL,
					(SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15''),
					(SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = ''B02386431''),
					2,
					0,
					'''||V_USR||''' ,
					SYSDATE,
					0
			  FROM DUAL';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] INSERTADA ACT_ETP_ENTIDAD_PROVEEDOR');
	
	ELSE
	
	DBMS_OUTPUT.PUT_LINE('[FIN] El registro ya existe o no existe la cartera o no existe el proveedor');
	
	END IF;
	
	COMMIT;
 
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
