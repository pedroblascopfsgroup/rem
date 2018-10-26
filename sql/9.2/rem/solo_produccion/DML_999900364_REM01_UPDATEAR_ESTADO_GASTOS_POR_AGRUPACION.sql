--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2002
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR ESTADOS GASTOS POR AGRUPACION DE GASTOS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2002';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 AGRUPACION DE GASTOS, ESTADO GASTOS 
    T_TIPO_DATA('170821669','05'),
    T_TIPO_DATA('180721963','05'),
    T_TIPO_DATA('180821437','05')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ECO_EXPEDIENTE_COMERCIAL -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE ESTADOS GASTOS POR AGRUPACION DE GASTOS');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS WHERE PRG_NUM_PROVISION = '||TRIM(V_TMP_TIPO_DATA(1))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN		

			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL ESTADO DE LOS GASTOS POR AGRUPACION DE GASTOS '||TRIM(V_TMP_TIPO_DATA(1))||'');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
							SET
								DD_EGA_ID = (
									SELECT
										DD_EGA_ID
									FROM
										'||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO
									WHERE
										DD_EGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
								),
								USUARIOMODIFICAR = '''||V_USUARIO||''',
								FECHAMODIFICAR = SYSDATE
						WHERE
							GPV_ID IN (
								SELECT
									GPV.GPV_ID
								FROM
									'||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG
									INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.PRG_ID = PRG.PRG_ID
								WHERE
									PRG.PRG_NUM_PROVISION = '||TRIM(V_TMP_TIPO_DATA(1))||')';
						
			EXECUTE IMMEDIATE V_MSQL;
			

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE EL ESTADO DE LOS GASTOS POR AGRUPACION DE GASTOS '||TRIM(V_TMP_TIPO_DATA(1))||'');
			
		--El activo no existe
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[INFO]: EL ESTADO DE LOS GASTOS POR AGRUPACION DE GASTOS '''||TRIM(V_TMP_TIPO_DATA(1))||' NO HAN SIDO ACTUALIZADOS');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ESTADOS ACTUALIZADOS CORRECTAMENTE ');

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
