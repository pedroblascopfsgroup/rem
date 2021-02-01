--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8510
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8510'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID_PROVEEDOR_REL VARCHAR2(100 CHAR); --Vble para almacenar el id del proveedor relacionado con el proveedor
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --PVE_COD_REM   PVE_COD_REM->"pve_id_mediador_rel"
    		T_TIPO_DATA('7407','13090'),
            T_TIPO_DATA('9601','2143'),
            T_TIPO_DATA('7277','3277'),
            T_TIPO_DATA('8627','2996'),
            T_TIPO_DATA('8106','4384'),
            T_TIPO_DATA('9602','2143'),
            T_TIPO_DATA('8376','662'),
            T_TIPO_DATA('9708','13090'),
            T_TIPO_DATA('110075199','2140'),
            T_TIPO_DATA('110155758','2164'),
            T_TIPO_DATA('9706','10033473'),
            T_TIPO_DATA('9720','2143'),
            T_TIPO_DATA('9721','2149'),
            T_TIPO_DATA('9597','2299'),
            T_TIPO_DATA('8242','2299'),
            T_TIPO_DATA('8195','2299'),
            T_TIPO_DATA('9718','3301'),
            T_TIPO_DATA('9698','3301'),
            T_TIPO_DATA('9279','2143'),
            T_TIPO_DATA('9604','954'),
            T_TIPO_DATA('7829','954'),
            T_TIPO_DATA('9723','954'),
            T_TIPO_DATA('9607','4436'),
            T_TIPO_DATA('9025','4436'),
            T_TIPO_DATA('8485','96'),
            T_TIPO_DATA('8439','96'),
            T_TIPO_DATA('8104','96'),
            T_TIPO_DATA('8863','672'),
            T_TIPO_DATA('9197','3301'),
            T_TIPO_DATA('9118','3301'),
            T_TIPO_DATA('9722','4436'),
            T_TIPO_DATA('9606','4436'),
            T_TIPO_DATA('9079','4436'),
            T_TIPO_DATA('8068','3301'),
            T_TIPO_DATA('9263','3301'),
            T_TIPO_DATA('9109','3301'),
            T_TIPO_DATA('9714','2143'),
            T_TIPO_DATA('9024','2143'),
            T_TIPO_DATA('9072','4436'),
            T_TIPO_DATA('9121','4436'),
            T_TIPO_DATA('9206','4436'),
            T_TIPO_DATA('9114','4436'),
            T_TIPO_DATA('110075176','5745'),
            T_TIPO_DATA('110116922','3232'),
            T_TIPO_DATA('110075646','3232'),
            T_TIPO_DATA('9713','110161264'),
            T_TIPO_DATA('9605','2091'),
            T_TIPO_DATA('8024','2091'),
            T_TIPO_DATA('110116923','110097633'),
            T_TIPO_DATA('110075393','110097633'),
            T_TIPO_DATA('8276','110097633'),
            T_TIPO_DATA('110116921','11860'),
            T_TIPO_DATA('7238','3393'),
            T_TIPO_DATA('9699','963'),
            T_TIPO_DATA('8105','963'),
            T_TIPO_DATA('8729','963'),
            T_TIPO_DATA('9709','662'),
            T_TIPO_DATA('9711','662'),
            T_TIPO_DATA('9707','1798'),
            T_TIPO_DATA('9596','1798'),
            T_TIPO_DATA('8479','662'),
            T_TIPO_DATA('9710','1798'),
            T_TIPO_DATA('9603','662'),
            T_TIPO_DATA('8419','662'),
            T_TIPO_DATA('8318','662'),
            T_TIPO_DATA('8454','662'),
            T_TIPO_DATA('8103','662'),
            T_TIPO_DATA('9702','1798'),
            T_TIPO_DATA('8252','662'),
            T_TIPO_DATA('9703','662'),
            T_TIPO_DATA('8620','662'),
            T_TIPO_DATA('8621','1798'),
            T_TIPO_DATA('8823','662'),
            T_TIPO_DATA('8708','1798'),
            T_TIPO_DATA('8824','1798'),
            T_TIPO_DATA('9760','4430'),
            T_TIPO_DATA('9443','110155537'),
            T_TIPO_DATA('9476','110155537'),
            T_TIPO_DATA('9686','4430'),
            T_TIPO_DATA('9700','10005070'),
            T_TIPO_DATA('9594','2143'),
            T_TIPO_DATA('9423','10005070'),
            T_TIPO_DATA('9547','10005070'),
            T_TIPO_DATA('9688','2143'),
            T_TIPO_DATA('9425','10005070'),
            T_TIPO_DATA('9719','10005070'),
            T_TIPO_DATA('9577','110155537'),
            T_TIPO_DATA('9592','110155537'),
            T_TIPO_DATA('9684','110155537'),
            T_TIPO_DATA('9542','2143'),
            T_TIPO_DATA('9685','110155537'),
            T_TIPO_DATA('9687','2143'),
            T_TIPO_DATA('9692','4430'),
            T_TIPO_DATA('9701','2143'),
            T_TIPO_DATA('9683','110155537'),
            T_TIPO_DATA('9695','10005070'),
            T_TIPO_DATA('9704','4430'),
            T_TIPO_DATA('9716','10005070'),
            T_TIPO_DATA('9693','4430'),
            T_TIPO_DATA('9555','4430'),
            T_TIPO_DATA('9598','2143'),
            T_TIPO_DATA('9705','2143'),
            T_TIPO_DATA('9892','110155537'),
            T_TIPO_DATA('9408','2143'),
            T_TIPO_DATA('9689','10005070'),
            T_TIPO_DATA('9850','4430'),
            T_TIPO_DATA('9742','2143'),
            T_TIPO_DATA('9502','10005070'),
            T_TIPO_DATA('9682','2143'),
            T_TIPO_DATA('9694','2143'),
            T_TIPO_DATA('9560','2143'),
            T_TIPO_DATA('9589','4430'),
            T_TIPO_DATA('9528','110155537'),
            T_TIPO_DATA('9786','4430'),
            T_TIPO_DATA('9679','2143'),
            T_TIPO_DATA('9545','110155537'),
            T_TIPO_DATA('9811','110155537'),
            T_TIPO_DATA('9454','4430'),
            T_TIPO_DATA('9593','2143'),
            T_TIPO_DATA('9536','2143'),
            T_TIPO_DATA('9753','110155537'),
            T_TIPO_DATA('9895','4430')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        
        --Comprobamos si existe el proveedor "OFICINA" con el cod rem indicado:
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_COD_REM='||V_TMP_TIPO_DATA(1)||' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si existe el proveedor
        IF V_NUM_TABLAS > 0 THEN
        
            --Comprobamos si existe el proveedor relacionado "API" con el cod rem indicado:
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_COD_REM='||V_TMP_TIPO_DATA(2)||' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;


            IF V_NUM_TABLAS > 0 THEN
            
                --Obtenemos el id del proveedor a relacionar "API"
                V_MSQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_COD_REM='||V_TMP_TIPO_DATA(2)||' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID_PROVEEDOR_REL;

                --Actualizamos proveedor "OFICINA"
                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                            PVE_ID_MEDIADOR_REL='||V_ID_PROVEEDOR_REL||',
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE                            
                            WHERE PVE_COD_REM='||V_TMP_TIPO_DATA(1)||'';
          	    EXECUTE IMMEDIATE V_MSQL;
                V_COUNT:=V_COUNT+1;    

                DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado el proveedor: '''||V_TMP_TIPO_DATA(1)||''' ');

            ELSE
                --Si no existe el proveedor "API"
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR A RELACIONAR CON PVE_COD_REM: '''||V_TMP_TIPO_DATA(2)||''' ');
            END IF;      	

		ELSE
            -- Si no existe el proveedor "OFICINA"
			DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR CON PVE_COD_REM: '''||V_TMP_TIPO_DATA(1)||''' ');

		END IF;
    END LOOP;

    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]: '''||V_COUNT||''' PROVEEDORES ASIGNADOS CORRECTAMENTE DE '''||V_COUNT_TOTAL||''' ');
    
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