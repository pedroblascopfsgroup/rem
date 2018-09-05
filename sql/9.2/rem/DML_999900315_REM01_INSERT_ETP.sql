--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180903
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4449'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_ACT_ETP_ENTIDAD_PROVEEDOR';  -- Tabla a modificar 
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERCION ACT_ETP_ENTIDAD_PROVEEDOR');

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
