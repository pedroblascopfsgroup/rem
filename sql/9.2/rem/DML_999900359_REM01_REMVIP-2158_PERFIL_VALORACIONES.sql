--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20181004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2158
--## PRODUCTO=NO
--##
--## Finalidad: Añadir perfil Valoraciones
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'PEF_PERFILES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COUNT NUMBER;
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2158';


    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	-- Verificar si el perfil ya existe
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PEF_CODIGO = ''VALORACIONES''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	
	
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El perfil ya existe.');
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Creando perfil VALORACIONES.');
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			PEF_ID
			, PEF_DESCRIPCION_LARGA
			, PEF_DESCRIPCION
			, USUARIOCREAR
			, FECHACREAR
			, PEF_CODIGO
		)	VALUES(
			'||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL
			, ''Usuario valoraciones''
			, ''Usuario valoraciones''
			, '''||V_USUARIO||'''
			, SYSDATE
			, ''VALORACIONES''
		)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creados '||sql%rowcount||' registros en '||V_TABLA);

	END IF;


	DBMS_OUTPUT.PUT_LINE('FIN');
	COMMIT;
	
	EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          ROLLBACK;
          RAISE; 
         
END;

/

EXIT
