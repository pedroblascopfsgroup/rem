--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10635
--## PRODUCTO=NO
--##
--## Finalidad: Insertar el diccionario de equivalencias entre carteras REM-ASPRO
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
    V_COUNT NUMBER(16) := 1; -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NOMBRE_REM VARCHAR2(32 CHAR) := 'DD_CRA_CARTERA'; -- Constante para correspondencia de tablas
    V_NOMBRE_ASPRO VARCHAR2(32 CHAR) := 'DD_CARTERA_ASPRO'; -- Constante para correspondencia de tablas
    
    V_TABLA VARCHAR(27 CHAR) := 'DD_EQV_ASPRO_REM';  --Vble que contiene el nombre de la tabla en donde insertar
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-10635'; -- USUARIO CREAR

    V_CODIGO_ASPRO VARCHAR2(32 CHAR);
    V_CODIGO_REM VARCHAR2(32 CHAR);
    V_DESCRIPCION_ASPRO VARCHAR2(128 CHAR);
    V_DESCRIPCION_REM VARCHAR2(128 CHAR);
    V_COUNT2 NUMBER(16) := 1; -- Vble. para contar.
    V_NOMBRE_ASPRO2 VARCHAR2(100 CHAR);
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('2038' , '18' , 'BANKIA'  , 'Titulizada'  ),
        T_TIPO_DATA('2038' , '17' , 'BANKIA'  , 'BFA'  )
             
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_CODIGO_ASPRO := V_TMP_TIPO_DATA(1); 
        V_CODIGO_REM := V_TMP_TIPO_DATA(2);
        V_DESCRIPCION_ASPRO := V_TMP_TIPO_DATA(3);
        V_DESCRIPCION_REM := V_TMP_TIPO_DATA(4);
                    
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_NOMBRE_ASPRO = '''||V_NOMBRE_ASPRO||''' 
                    AND DD_CODIGO_ASPRO = '''||V_CODIGO_ASPRO||'''
                    AND DD_CODIGO_REM = '''||V_CODIGO_REM||''' '; 
        
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

        IF V_COUNT = 0 THEN
           
                V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(
                  DD_NOMBRE_ASPRO
                , DD_CODIGO_ASPRO
                , DD_DESCRIPCION_ASPRO
                , DD_DESCRIPCION_LARGA_ASPRO
                , DD_NOMBRE_REM
                , DD_CODIGO_REM
                , DD_DESCRIPCION_REM
                , DD_DESCRIPCION_LARGA_REM
                , USUARIOCREAR
                , FECHACREAR
                ) VALUES (
                  '''||V_NOMBRE_ASPRO||''' || '''||V_COUNT2||'''
                , '''||V_CODIGO_ASPRO||'''
                , '''||V_DESCRIPCION_ASPRO||'''
                , '''||V_DESCRIPCION_ASPRO||'''
                , '''||V_NOMBRE_REM||'''
                , '''||V_CODIGO_REM||'''
                , '''||V_DESCRIPCION_REM||'''
                , '''||V_DESCRIPCION_REM||'''
                , '''||V_USUARIO||'''
                , SYSDATE
                )
                ';
                
                EXECUTE IMMEDIATE V_SQL;
                DBMS_OUTPUT.put_line('[INFO] Insertado el registro '||V_NOMBRE_ASPRO||' '||V_CODIGO_ASPRO||' '||V_NOMBRE_REM||' '||V_CODIGO_REM||'');
        ELSE
                DBMS_OUTPUT.put_line('[INFO] Ya existe el valor '||V_NOMBRE_ASPRO||' '||V_CODIGO_ASPRO||' '||V_NOMBRE_REM||' '||V_CODIGO_REM||'');
        END IF;
         V_COUNT2 := V_COUNT2+1;
      END LOOP;

COMMIT;

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
