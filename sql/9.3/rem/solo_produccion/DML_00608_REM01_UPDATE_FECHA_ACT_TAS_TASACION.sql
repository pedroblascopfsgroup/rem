--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210104
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8547
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar ACT_NUM_ACTIVO
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8547'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_TAS_TASACION'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_ACTIVO VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla de los activos a buscar
    V_ID VARCHAR2(100 CHAR); --Vble para almacenar el id de la tasacion
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --ACT_NUM_ACTIVO
    		T_TIPO_DATA('7282909'),
            T_TIPO_DATA('7268445'),
            T_TIPO_DATA('7282903'),
            T_TIPO_DATA('7282912'),
            T_TIPO_DATA('7282892'),
            T_TIPO_DATA('7245923'),
            T_TIPO_DATA('7282901'),
            T_TIPO_DATA('7282898'),
            T_TIPO_DATA('7235679'),
            T_TIPO_DATA('7282895'),
            T_TIPO_DATA('7268446'),
            T_TIPO_DATA('7282913'),
            T_TIPO_DATA('7282910'),
            T_TIPO_DATA('7291503'),
            T_TIPO_DATA('7282904'),
            T_TIPO_DATA('7282907'),
            T_TIPO_DATA('7282890'),
            T_TIPO_DATA('7282905'),
            T_TIPO_DATA('7282906'),
            T_TIPO_DATA('7268444'),
            T_TIPO_DATA('7282908'),
            T_TIPO_DATA('7282891'),
            T_TIPO_DATA('7282893'),
            T_TIPO_DATA('7282896'),
            T_TIPO_DATA('7282902'),
            T_TIPO_DATA('7282900'),
            T_TIPO_DATA('7242001'),
            T_TIPO_DATA('7282914'),
            T_TIPO_DATA('7282911'),
            T_TIPO_DATA('7282894'),
            T_TIPO_DATA('7282897'),
            T_TIPO_DATA('7282899'),
            T_TIPO_DATA('7251060')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

         V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||'
                    WHERE ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||'';

        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        --Si existe el activo
        IF V_NUM_TABLAS = 1 THEN
        
            --Comprobamos si existen tasaciones para el activo indicado

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT
                        JOIN '||V_ESQUEMA||'.'||V_TABLA||' TAS ON TAS.ACT_ID=ACT.ACT_ID
                        WHERE ACT.ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||'';

            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
            -- Si existen tasaciones
            IF V_NUM_TABLAS > 0 THEN
                --Si hay mas de 1 tasacion
                IF V_NUM_TABLAS <= 1 THEN        
            
                --Obtenemos el id de la tasacion a modificar
                V_MSQL := 'SELECT TAS.TAS_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT
                        JOIN '||V_ESQUEMA||'.'||V_TABLA||' TAS ON TAS.ACT_ID=ACT.ACT_ID
                        WHERE ACT.ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                --Actualizamos FECHA TASACION A NULL
                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                            TAS_FECHA_INI_TASACION=NULL,
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE                            
                            WHERE TAS_ID='||V_ID||'';
                EXECUTE IMMEDIATE V_MSQL;
                V_COUNT:=V_COUNT+1;    

                DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado la tasacion del activo: '''||V_TMP_TIPO_DATA(1)||''' ');

                ELSE
                    --Si hay mas de 1 tasacion
                    DBMS_OUTPUT.PUT_LINE('[INFO]: HAY MAS DE 1 TASACION PARA EL ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' NO SE REALIZAN CAMBIOS ');
                END IF;

            ELSE
                --Si no existen tasaciones
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN TASACIONES PARA EL ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' ');
            END IF;

         ELSE
            --Si no existe activo
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL ACTIVO:'''||V_TMP_TIPO_DATA(1)||''' ');
        END IF;
    END LOOP;

    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]: '''||V_COUNT||''' TASACIONES MODIFICADAS CORRECTAMENTE DE:'''||V_COUNT_TOTAL||''' ');
    
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
EXIT