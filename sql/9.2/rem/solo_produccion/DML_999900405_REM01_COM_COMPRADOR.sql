--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2459
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
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2459'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TABLA COM_COMPRADOR');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.COM_COMPRADOR T1
			   USING (SELECT *
					  FROM '||V_ESQUEMA||'.AUX_COMPRADOR_CARGAS
					  WHERE ID_COMPRADOR_URSUS NOT IN (19800002,
														252577275,
														320692411,
														325099687,
														329300040,
														350649109,
														351719083,
														353605843)) T2
			   ON (T1.COM_DOCUMENTO = T2.NIF)
			   WHEN MATCHED THEN
			   UPDATE SET T1.ID_COMPRADOR_URSUS = T2.ID_COMPRADOR_URSUS,
						   T1.USUARIOMODIFICAR = '''||V_USR||''',
						   T1.FECHAMODIFICAR = SYSDATE
			   WHEN NOT MATCHED THEN
			   INSERT (COM_ID, 
					   COM_NOMBRE,
					   COM_DOCUMENTO,
					   ID_COMPRADOR_URSUS, 
					   DD_TDI_ID, 
					   USUARIOCREAR, 
					   FECHACREAR, 
					   VERSION, 
					   BORRADO)
			   VALUES (S_COM_COMPRADOR.NEXTVAL,
					   T2.NOMBRE,
					   T2.NIF,
					   T2.ID_COMPRADOR_URSUS,
					   (CASE T2.DD_TDI_ID
							WHEN ''1'' THEN 1
							WHEN ''2'' THEN 2
							WHEN ''3'' THEN 3
							WHEN ''4'' THEN 4
							WHEN ''7'' THEN 6
						END),
						'''||V_USR||''',
						SYSDATE,
						0,
						0)
			   ';
	
	EXECUTE IMMEDIATE V_MSQL;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] REGISTROS ACTUALIZADOS');
		
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
