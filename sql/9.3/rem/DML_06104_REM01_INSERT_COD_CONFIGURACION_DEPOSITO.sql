--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18065
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18065] - Juan José Sanjuan
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
  V_COD_ID NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(200 CHAR) := 'HREOS-18065';        
     
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('05'),
        T_TIPO_DATA('06'),
        T_TIPO_DATA('08'),
        T_TIPO_DATA('09'),
        T_TIPO_DATA('14'),
        T_TIPO_DATA('15'),
        T_TIPO_DATA('19'),
        T_TIPO_DATA('160'),
        T_TIPO_DATA('161')
    ); 

   V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   

    DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    --DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '|| V_TEXT_TABLA);
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN COD_CONFIGURACION_DEPOSITO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.COD_CONFIGURACION_DEPOSITO WHERE DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO ='''||TRIM(V_TMP_TIPO_DATA(1))||''')';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

      IF V_NUM_TABLAS > 0 THEN              

        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO YA EXISTE');

      ELSE   
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.COD_CONFIGURACION_DEPOSITO (COD_ID, DD_SCR_ID, COD_DEPOSITO_NECESARIO, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                  ' VALUES ('||V_ESQUEMA||'.S_COD_CONFIGURACION_DEPOSITO.NEXTVAL ,(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO ='''||		TRIM(V_TMP_TIPO_DATA(1))||'''), 1,'''||V_USUARIO||''',SYSDATE,0)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      END IF;  
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
