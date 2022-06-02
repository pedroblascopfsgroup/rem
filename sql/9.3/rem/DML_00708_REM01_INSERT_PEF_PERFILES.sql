--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16822
--## PRODUCTO=NO
--## Finalidad: DML para insertar un nuevo perfil
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_ID NUMBER(16);

BEGIN
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''KAMBBVA'''
    INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL FROM DUAL'
		INTO V_ID;
		DBMS_OUTPUT.PUT_LINE('[INSERTAR EL NUEVO PERFIL DIRTERRITORIAL]');
		V_SQL:= 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (
								PEF_ID,
								PEF_DESCRIPCION_LARGA,
								PEF_DESCRIPCION,
								VERSION,
								USUARIOCREAR,
								FECHACREAR,
								BORRADO,
								PEF_CODIGO
								) VALUES (
								'||V_ID||',
								''Oficina KAM BBVA'',
								''Oficina KAM BBVA'',
								0,
								''HREOS-16822'',
								SYSDATE,
								0,
								''KAMBBVA''
								)';

		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[PERFIL DIRTERRITORIAL INSERTADO CORRECTAMENTE]');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[PERFIL DIRTERRITORIAL YA EXISTE]');
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

EXIT;
