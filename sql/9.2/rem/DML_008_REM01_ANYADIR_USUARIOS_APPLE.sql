--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6843
--## PRODUCTO=SI
--##
--## Finalidad: Insertar nuevos usuarios para buzones Apple
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
   V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'HREOS-6843';
    
    
    
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar datos en '||V_TEXT_TABLA);
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = ''buzonofrapple'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS = 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
          VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonofrapple'', ''zIeTYpoIdAPH'', ''Buzon Ofertas Apple'', ''appleofertas@haya.es'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';
      DBMS_OUTPUT.PUT_LINE('[INFO] Insertando usuario ficticio buzonofrapple.......');

        EXECUTE IMMEDIATE V_MSQL;
      
    END IF;
    
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = ''buzonforapple'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    IF V_NUM_TABLAS = 0 THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
          VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonforapple'', ''SewTHIgORodC'', ''Buzon Formalizacion Apple'', ''appleformalizacion@haya.es'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';
      DBMS_OUTPUT.PUT_LINE('[INFO] Insertando usuario ficticio buzonforapple.......');

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