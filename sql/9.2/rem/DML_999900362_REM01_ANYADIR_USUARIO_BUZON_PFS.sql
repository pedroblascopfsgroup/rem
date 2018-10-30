--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20181023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2350
--## PRODUCTO=SI
--##
--## Finalidad: Insertar nuevo usuario para buzon REM para soporte de PFS
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USU_USUARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
   V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-2179';
    
    
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar datos en '||V_TEXT_TABLA);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = ''buzonpfs'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS = 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
          VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonpfs'', ''bLjvu4vr1D'', ''BUZON SOPORTE PFS'', ''backup.rem@pfsgroup.es'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';
      DBMS_OUTPUT.PUT_LINE('[INFO] Insertando usuario ficticio buzonrem.......');

        EXECUTE IMMEDIATE V_MSQL;
      
    END IF;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Insertado correctamente');
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;