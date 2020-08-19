--/*
--###########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200814
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7964
--## PRODUCTO=NO
--## 
--## Finalidad: Modificar DATOS PROVEEDOR
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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7964';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		NUMERO_PROVEEDOR, COD_UVEM
    T_TIPO_DATA('110065069','182652776')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
		
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
    V_SQL:= q'[UPDATE 
					REM01.ACT_PVE_PROVEEDOR 
				SET 
					PVE_COD_UVEM = :1, 
					USUARIOMODIFICAR = :2, 
					FECHAMODIFICAR = SYSDATE 
				WHERE 
					PVE_COD_REM = :3]';
					
	EXECUTE IMMEDIATE V_SQL USING V_TMP_TIPO_DATA(2), V_USUARIO, V_TMP_TIPO_DATA(1);
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA MODIFICADO EL PROVEEDOR '||V_TMP_TIPO_DATA(1));
	
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PROVEEDORES ACTUALIZADOS CORRECTAMENTE ');

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
