--/*
--###########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1352
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_TABLA VARCHAR2(50 CHAR) := 'DD_TGE_TIPO_GESTOR';

  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_COUNT NUMBER(16);
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
 
 
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

	IF V_COUNT > 0 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] El tipo de gestor ya se encontraba insertado, no realizamos acción');
		
	ELSE
		V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' (
				DD_TGE_ID
				,DD_TGE_CODIGO
				,DD_TGE_DESCRIPCION
				,DD_TGE_DESCRIPCION_LARGA
				,USUARIOCREAR
				,FECHACREAR
				)
				SELECT '||V_ESQUEMA_M||'.S_DD_TGE_TIPO_GESTOR.NEXTVAL,
				''SBACKOFFICEINMLIBER'',
				''Supervisor Comercial BackOffice Liberbank'',
				''Supervisor Comercial BackOffice Liberbank'',
				''REMVIP-1352'',
				SYSDATE
				FROM DUAL			
				';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Usuario insertado correctamente');
		
	END IF;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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
