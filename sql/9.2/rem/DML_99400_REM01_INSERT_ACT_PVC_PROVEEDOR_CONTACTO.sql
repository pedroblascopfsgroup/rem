--/*
--##########################################
--## AUTOR=MARIAM LLISO M
--## FECHA_CREACION=20190311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5532
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_PVC_PROVEEDOR_CONTACTO los datos añadidos en T_ARRAY_DATA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_NUM_PROVEEDOR VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_NUM_USUARIO VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    ----------------CÓDIGO PROVEEDOR----NOMBRE USUARIO    
    	T_TIPO_DATA('10010157',         'tecnotra07'),
        T_TIPO_DATA('10010157',         'tecnotra06'),
        T_TIPO_DATA('36',               'qipert07'),
        T_TIPO_DATA('36',               'qipert06'),
        T_TIPO_DATA('10005592',         'pinos07'),
        T_TIPO_DATA('10005592',         'pinos06'),
        T_TIPO_DATA('59',               'ogf07'),
        T_TIPO_DATA('59',               'ogf06'),
        T_TIPO_DATA('10004652',         'montalvo07'),
        T_TIPO_DATA('10004652',         'montalvo06'),
        T_TIPO_DATA('10009469',         'grupobc07'),
        T_TIPO_DATA('10009469',         'grupobc06'),
        T_TIPO_DATA('10004484',         'gl06'),
        T_TIPO_DATA('3213',             'garsa07'),
        T_TIPO_DATA('3213',             'garsa06')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores en ACT_PVC_PROVEEDOR_CONTACTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_PVC_PROVEEDOR_CONTACTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos que el PVE_ID indicado existe en ACT_PVE_PROVEEDOR
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||TRIM(V_TMP_TIPO_DATA(1))||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_PROVEEDOR;

        IF V_NUM_PROVEEDOR > 0 THEN
            --Comprobamos que el USU_USERNAME indicado existe en USU_USUARIOS
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_USUARIO;

            IF V_NUM_USUARIO > 0 THEN 
                --- Insertamos la relacion proveedor-usuario en ACT_PVC_PROVEEDOR_CONTACTO
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS  '|| TRIM(V_TMP_TIPO_DATA(1))||' Y '||TRIM(V_TMP_TIPO_DATA(2))||'');
                
                V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_ACT_PVC_PROVEEDOR_CONTACTO.NEXTVAL FROM DUAL';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

                V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO (' ||
                'PVC_ID, PVE_ID, USU_ID, PVC_NOMBRE, PVC_APELLID01, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                'SELECT '|| V_ID || ', PVE.PVE_ID, USU.USU_ID, PVE.PVE_NOMBRE, USU.USU_APELLIDO1, 0, ''HREOS-5532'', SYSDATE, 0
                FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE, '||V_ESQUEMA_M||'.USU_USUARIOS USU
                WHERE PVE.PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||' AND USU.USU_USERNAME = '''||V_TMP_TIPO_DATA(2)||'''
                AND NOT EXISTS (SELECT 1 FROM ACT_PVC_PROVEEDOR_CONTACTO PVC WHERE PVC.USU_ID = USU.USU_ID)';
                EXECUTE IMMEDIATE V_MSQL;
            
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO EN USU_USERNAME]');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR EN ACT_PVE_PROVEEDOR]');

        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACT_PVC_PROVEEDOR_CONTACTO ACTUALIZADA CORRECTAMENTE ');

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



   
