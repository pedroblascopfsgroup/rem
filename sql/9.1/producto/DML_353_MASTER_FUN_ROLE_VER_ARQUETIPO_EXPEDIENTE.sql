--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-567
--## PRODUCTO=SI
--## Finalidad: DML Agregar la función ROLE_VER_ARQUETIPO_EXPEDIENTE que muestra el arquetipo y el expediente en los Datos Gestión de la cabecera del expediente
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

--------------------------------------- ROLE_VER_ARQUETIPO_EXPEDIENTE ---------------------------------------------------------------------
	
DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobando permiso ROLE_VER_ARQUETIPO_EXPEDIENTE');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_VER_ARQUETIPO_EXPEDIENTE''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos el permiso ROLE_VER_ARQUETIPO_EXPEDIENTE');
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR,  BORRADO )  VALUES '||
				'( '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL, '' Permite ver el campo arquetipo e itinerario en los expedientes de recuperaciones o de seguimiento'', ''ROLE_VER_ARQUETIPO_EXPEDIENTE'', 0, ''DML'', SYSDATE, 0)';
	EXECUTE IMMEDIATE V_MSQL;
END IF;


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

