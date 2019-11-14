--/*
--##########################################
--## AUTOR=Dean Ibañez VIño
--## FECHA_CREACION=20191001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7875
--## PRODUCTO=NO
--##
--## Finalidad: Borrado de datos DD_FSP_FASE_PUBLICACION y inserccion de datos DD_SFP_SUBFASE_PUBLICACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_AUX NUMBER(16);
    V_TABLA_FSP VARCHAR2(27 CHAR) := 'DD_FSP_FASE_PUBLICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_SFP VARCHAR2(27 CHAR) := 'DD_SFP_SUBFASE_PUBLICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-7875';
    V_ID NUMBER(16);

 BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME ='''||V_TABLA_FSP||'''';
      
  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
   
  IF V_COUNT > 0 THEN
  
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_FSP||' WHERE dd_fsp_descripcion = ''Devuelto'' OR dd_fsp_descripcion = ''Clasificado''';
    EXECUTE IMMEDIATE V_SQL; 

      V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME ='''||V_TABLA_SFP||'''';
      
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
   
        IF V_COUNT > 0 THEN

        V_SQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA_SFP||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_SQL INTO V_ID;

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_SFP||' (DD_SFP_ID, DD_FSP_ID, DD_SFP_CODIGO, DD_SFP_DESCRIPCION, DD_SFP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                    VALUES ('||V_ID||', 5, '||V_ID||', ''Devuelto'', ''Devuelto'', 0, '''||V_USUARIO||''', SYSDATE, 0)';
        EXECUTE IMMEDIATE V_SQL;



        V_SQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA_SFP||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_SQL INTO V_ID;

        V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_SFP||' (DD_SFP_ID, DD_FSP_ID, DD_SFP_CODIGO, DD_SFP_DESCRIPCION, DD_SFP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                    VALUES ('||V_ID||', 5, '||V_ID||', ''Clasificado'', ''Clasificado'', 0, '''||V_USUARIO||''', SYSDATE, 0)';
        EXECUTE IMMEDIATE V_SQL;

        ELSE
  	  
  	    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA_SFP||' no existe');
  	  
        END IF;
	  
  ELSE
  	  
  	  DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA_FSP||' no existe');
  	  
  END IF;

 COMMIT;

 DBMS_OUTPUT.PUT_LINE('[FIN] ');
 
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
