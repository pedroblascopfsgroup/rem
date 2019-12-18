--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5930
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USR VARCHAR2(50 CHAR):= 'REMVIP-5930';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --			CODIGO PERFIL
		T_FUNCION('SUPEREXPORTACTAGR'),
		T_FUNCION('SUPEREXPORTPUBLI'),
		T_FUNCION('SUPEREXPORTTARAVAL'),
		T_FUNCION('SUPEREXPORTADMIN'),
		T_FUNCION('SUPEREXPORTOFR'),
		T_FUNCION('SUPEREXPORTTBJ')		
    );
    V_TMP_FUNCION T_FUNCION;
	CURSOR CURSOR_SUPER IS
  		SELECT USU_ID FROM #ESQUEMA#.ZON_PEF_USU WHERE BORRADO = 0 AND PEF_ID = (SELECT PEF_ID FROM #ESQUEMA#.PEF_PERFILES WHERE PEF_CODIGO = 'HAYASUPER');
	USUID NUMBER(16);
BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      	V_TMP_FUNCION := V_FUNCION(I);
      	
      	OPEN CURSOR_SUPER;
      	LOOP
      		FETCH CURSOR_SUPER INTO USUID;
      		EXIT WHEN CURSOR_SUPER%NOTFOUND;
      		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU(ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)
						SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,
						(SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),
						(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''),
						'||USUID||', '''||V_USR||''', SYSDATE, 0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
		END LOOP;
		CLOSE CURSOR_SUPER;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PERFILADO ACTUALIZADO ');


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