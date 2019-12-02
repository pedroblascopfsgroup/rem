--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20191202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8639
--## PRODUCTO=NO
--##
--## Finalidad: Updatear DD_SFP_SUBFASE_PUBLICACION.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_TABLA VARCHAR2(30 CHAR); -- Vble para nombre de la tabla principal del DML.
    V_TABLA_2 VARCHAR(30 CHAR); --Vble. auxiliar para uso de otras tablas distintas de la principal.
    V_CAMPOS_V_TABLA VARCHAR(1024);
    V_USUARIO VARCHAR2(25 CHAR);
    V_COUNT NUMBER(16);
    V_COD_FASE VARCHAR(30 CHAR); --Vble. codigo fase a eliminar para las subfases.
    V_COD_SUBFASE VARCHAR(30 CHAR); -- vbl. codigo subfase a eliminar para las subfases.

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	     T_FUNCION('Pendiente análisis', 'Act. pdte. Edificación - En análisis'),
       T_FUNCION('Actuaciones pendiente edificación', 'Act- pdte. Edificación - En adecuación'),
       T_FUNCION('En análisis', 'Actuaciones HPM')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	V_COD_FASE := '03';
  V_COD_SUBFASE := '06';
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  V_TABLA := 'DD_SFP_SUBFASE_PUBLICACION';
  V_CAMPOS_V_TABLA:=' (DD_SFP_ID,'
    || 'DD_FSP_ID, DD_SFP_CODIGO, DD_SFP_DESCRIPCION, '
    || 'DD_SFP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, '
    || 'FECHACREAR, BORRADO ) ';

  V_TABLA_2 := 'DD_FSP_FASE_PUBLICACION';
	V_USUARIO := 'HREOS-8639'; 
  
    -- LOOP para updatear valores  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADANDO DESCRIPCIONES ');
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||
         '  SET DD_SFP_DESCRIPCION ='''||V_TMP_FUNCION(2)||''', DD_SFP_DESCRIPCION_LARGA ='''||V_TMP_FUNCION(2)|| ''''||
         ' WHERE DD_SFP_DESCRIPCION = '''||V_TMP_FUNCION(1)||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' actualizados correctamente.');
    END LOOP;
    ---- Eliminando registro con descripción concreta -----------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: Eliminando  subfase con código 06 de la Fase I');
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET BORRADO = 1,  USUARIOBORRAR= '''||V_USUARIO||''', FECHABORRAR = SYSDATE ' ||
     ' WHERE DD_FSP_ID = (SELECT DD_FSP_ID FROM DD_FSP_FASE_PUBLICACION WHERE DD_FSP_CODIGO = '''||V_COD_FASE||''' AND DD_SFP_CODIGO = '''||
     V_COD_SUBFASE||''')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' Eliminados correctamente.');
    ----- Insertando subfase "Pendiente de documentacion si no existe "
    DBMS_OUTPUT.PUT_LINE('[INFO]: Insertando subfase a la Fase VI');
    
    V_MSQL := 'SELECT COUNT(DD_SFP_CODIGO) FROM DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = ''27''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_SFP_DESCRIPCION = ''Pendiente otra documentación'','
      ||' DD_SFP_DESCRIPCION_LARGA = ''Pendiente otra documentación'', VERSION = VERSION + 1, USUARIOMODIFICAR = '''||V_USUARIO
      ||''', FECHAMODIFICAR = SYSDATE, BORRADO = 0 WHERE DD_SFP_CODIGO = ''27'''; 
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] Registros de la tabla '||V_ESQUEMA||'.'||V_TABLA||' actualizados correctamente.');
    ELSE
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||V_CAMPOS_V_TABLA||' VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,'
      ||' (SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE DD_FSP_CODIGO = ''10''), ''27'', ''Pendiente otra documentación'','
      ||'''Pendiente otra documentación'', 0,'''||V_USUARIO||''', SYSDATE, 0)';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] Registros de la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' OPERACIONES REALIZADAS CORRECTAMENTE ');
   
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
EXIT;
