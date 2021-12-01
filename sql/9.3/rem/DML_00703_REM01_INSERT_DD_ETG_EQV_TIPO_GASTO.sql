--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16568
--## PRODUCTO=NO
--##
--## Finalidad: Script que inserta en DD_ETG_EQV_TIPO_GASTO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-16568';
    V_EJE_ID NUMBER(16);
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --EJE_ANYO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('2021')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_ETG_EQV_TIPO_GASTO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Modificamos el campo EJE_ID
        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.DD_ETG_EQV_TIPO_GASTO T1
                  USING (
                    SELECT 
                            ETG.DD_ETG_ID
                    FROM DD_ETG_EQV_TIPO_GASTO ETG
                    WHERE NVL(ETG.EJE_ID,0) <> (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
                  ) T2 ON (T1.DD_ETG_ID = T2.DD_ETG_ID)
                  WHEN MATCHED THEN UPDATE SET
                      T1.EJE_ID = (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
                    , T1.USUARIOMODIFICAR = '''||TRIM(V_ITEM)||'''
                    , T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS MODIFICADOS : '||SQL%ROWCOUNT||' ');
    
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_ETG_EQV_TIPO_GASTO MODIFICADO CORRECTAMENTE ');
   

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
