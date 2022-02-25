--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11206
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  avance promocion BBVA, con inserts en DD_PBB_PROMOCION_BBVA
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_PBB_PROMOCION_BBVA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11206';
    V_ID_NEXTVAL NUMBER(25); --ID nextval
    V_ID_CONCAT VARCHAR2(2400 CHAR); --Vble. de concatenación para la descripción del diccionario

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('778313'),
        T_TIPO_DATA('778314'),
        T_TIPO_DATA('778315'),
        T_TIPO_DATA('778316'),
        T_TIPO_DATA('778317'),
        T_TIPO_DATA('778318'),
        T_TIPO_DATA('778319'),
        T_TIPO_DATA('778320'),
        T_TIPO_DATA('778321'),
        T_TIPO_DATA('778322'),
        T_TIPO_DATA('778323'),
        T_TIPO_DATA('778324'),
        T_TIPO_DATA('778325'),
        T_TIPO_DATA('778326'),
        T_TIPO_DATA('778327'),
        T_TIPO_DATA('778328'),
        T_TIPO_DATA('778329'),
        T_TIPO_DATA('778279'),
        T_TIPO_DATA('778330'),
        T_TIPO_DATA('778331'),
        T_TIPO_DATA('778332'),
        T_TIPO_DATA('778333'),
        T_TIPO_DATA('778334'),
        T_TIPO_DATA('778335'),
        T_TIPO_DATA('778336'),
        T_TIPO_DATA('518469'),
        T_TIPO_DATA('518470')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el nuevo id con nextval.
        V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_NEXTVAL;

        IF LENGTH(V_ID_NEXTVAL) = 4 THEN
            V_ID_CONCAT := CONCAT( CONCAT('R0', V_ID_NEXTVAL), '-01');
        ELSIF LENGTH(V_ID_NEXTVAL) = 5 THEN
            V_ID_CONCAT := CONCAT( CONCAT('R', V_ID_NEXTVAL), '-01');
        END IF;
					
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO EN '||V_TEXT_TABLA||':'|| V_ID_CONCAT ||'');
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            (DD_PBB_ID, DD_PBB_CODIGO, DD_PBB_DESCRIPCION, DD_PBB_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
            VALUES
            ( '||V_ID_NEXTVAL||', '''||V_ID_CONCAT||''','''||V_ID_CONCAT||''','''||V_ID_CONCAT||''', '''||V_USUARIO||''', SYSDATE)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       
     
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: INSERCIONES EN LA TABLA '||V_TEXT_TABLA||' FINALIZADAS CORRECTAMENTE ');

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
