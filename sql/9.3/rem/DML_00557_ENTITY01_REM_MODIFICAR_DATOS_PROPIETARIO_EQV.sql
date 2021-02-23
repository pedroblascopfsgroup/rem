--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=ITREM-23546
--## PRODUCTO=NO
--## Finalidad: Modificar DATOS PROPIETARIO en EQV
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				-- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 	-- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); 								-- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); 								-- Vble. para validar la existencia de una tabla.   
    err_num NUMBER; 										-- Numero de errores
    err_msg VARCHAR2(2048); 								-- Mensaje de error
	V_USUARIO VARCHAR2(100 CHAR) := 'ITREM-23546';
    V_CODIGO VARCHAR2(100 CHAR) := 'DD_PROPIETARIO_ASPRO';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		DD_CODIGO_ASPRO, DD_CODIGO_REM 
    T_TIPO_DATA('0000196','B88385190'),
	T_TIPO_DATA('0000198','B88396676')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
    
   	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
        V_SQL:= q'[UPDATE 
                        #ESQUEMA#.DD_EQV_ASPRO_REM 
                    SET 
                        DD_CODIGO_REM = :1, 
                        USUARIOMODIFICAR = :2, 
                        FECHAMODIFICAR = SYSDATE 
                    WHERE 
                        DD_CODIGO_ASPRO = :3
                        AND DD_NOMBRE_ASPRO = :4]';
        
        EXECUTE IMMEDIATE V_SQL USING V_TMP_TIPO_DATA(2), V_USUARIO, V_TMP_TIPO_DATA(1), V_CODIGO;
        
        IF SQL%ROWCOUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA ACTUALIZADO AL PROPIETARIO EL CODIGO '||V_TMP_TIPO_DATA(1));
        ELSIF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO SE HA ACTUALIZADO AL PROPIETARIO EL CODIGO '||V_TMP_TIPO_DATA(1));
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: REVISAR ACTUALIZACION AL PROPIETARIO '||V_TMP_TIPO_DATA(1));
        END IF;
        
    END LOOP;
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PROPIETARIOS ACTUALIZADOS CORRECTAMENTE ');
	

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

  	
