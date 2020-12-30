--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8260
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR PROPIETARIOS ACTIVOS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8260'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PRO_PROPIETARIO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_ACTIVO VARCHAR2(100 CHAR) :='ACT_ACTIVO';
    V_TABLA_PAC VARCHAR2(100 CHAR) :='ACT_PAC_PROPIETARIO_ACTIVO';
    V_TABLA_GASTOS VARCHAR2(100 CHAR) :='GPV_GASTOS_PROVEEDOR';
    V_TABLA_ACTIVO_GASTO VARCHAR2(100 CHAR) := 'GPV_ACT';
    
    V_DOCIDENTIF VARCHAR2(100 CHAR) :='B84921758';
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    V_ID_SUBCARTERA NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||' ');            


            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF='''||V_DOCIDENTIF||''' ';

            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

                V_SQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||'
                                WHERE PRO_DOCIDENTIF IN (''B39690516'',''A86486461'',''A78485752'')';

                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS >= 3 THEN

                V_SQL:='SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF='''||V_DOCIDENTIF||''' AND BORRADO=0';
                  EXECUTE IMMEDIATE V_SQL INTO V_ID;

                  V_SQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
                            WHERE SCR.DD_SCR_CODIGO=57';

                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS > 0 THEN

                    DBMS_OUTPUT.PUT_LINE('[INFO]: OBTENEMOS SUBCARTERA');

                    V_SQL:='SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
                                    WHERE SCR.DD_SCR_CODIGO=57 ';

                        EXECUTE IMMEDIATE V_SQL INTO V_ID_SUBCARTERA;

                        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS SUBCARTERA');
                    
                    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT
                        USING (SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' act
                                JOIN '||V_ESQUEMA||'.'||V_TABLA_PAC||' ACTPRO ON (act.act_id=ACTPRO.act_id)
                                JOIN '||V_ESQUEMA||'.'||V_TABLA||' PRO ON (ACTPRO.PRO_ID=pro.pro_id)
                                WHERE PRO.PRO_ID IN (SELECT PRO2.PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' PRO2
                                    WHERE PRO2.PRO_DOCIDENTIF IN (''B39690516'',''A86486461'',''A78485752''))
                                AND ACT.BORRADO=0
                        ) AUX ON (ACT.ACT_ID = AUX.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET 
                        ACT.DD_SCR_ID='||V_ID_SUBCARTERA||',
                        ACT.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        ACT.FECHAMODIFICAR = SYSDATE';

                        EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN ACT_ACTIVO: ' ||sql%rowcount);

                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA SUBCARTERA CON EL NOMBRE INDICADO ');
                END IF;

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PROPIETARIO');

                 V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_PAC||' PAC
                USING (SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' act
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_PAC||' ACTPRO ON (act.act_id=ACTPRO.act_id)
                        JOIN '||V_ESQUEMA||'.'||V_TABLA||' PRO ON (ACTPRO.PRO_ID=pro.pro_id)
                        WHERE PRO.PRO_ID IN (SELECT PRO2.PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' PRO2
                            WHERE PRO2.PRO_DOCIDENTIF IN (''B39690516'',''A86486461'',''A78485752''))
                        AND ACT.BORRADO=0
                ) AUX ON (PAC.ACT_ID = AUX.ACT_ID)
                WHEN MATCHED THEN UPDATE SET 
                PAC.PRO_ID='||V_ID||',
                PAC.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                PAC.FECHAMODIFICAR = SYSDATE';
                
                 EXECUTE IMMEDIATE V_MSQL;
                 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN ACT_PAC_PROPIETARIO_ACTIVO: ' ||sql%rowcount);


                 
                 DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PROPIETARIO DE LOS GASTOS DE LOS ACTIVOS ANTERIORES');

                 V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_GASTOS||' GPV
                USING (SELECT DISTINCT GPV2.GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_ACTIVO_GASTO||' GPVACT ON GPVACT.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_GASTOS||' GPV2 ON GPV2.GPV_ID=GPVACT.GPV_ID
                        WHERE ACT.USUARIOMODIFICAR='''||V_USUARIO||''' 
                        AND GPV2.DD_EGA_ID!=(SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA WHERE EGA.DD_EGA_CODIGO=''06'' ) 
                        AND GPV2.DD_EGA_ID!=(SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA WHERE EGA.DD_EGA_CODIGO=''05'' ) 
                        AND GPV2.DD_EGA_ID!=(SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA WHERE EGA.DD_EGA_CODIGO=''04'' )
                        AND GPV2.BORRADO=0
                ) AUX ON (GPV.GPV_ID = AUX.GPV_ID)
                WHEN MATCHED THEN UPDATE SET 
                GPV.PRO_ID='||V_ID||',
                GPV.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                GPV.FECHAMODIFICAR = SYSDATE';
                
                 EXECUTE IMMEDIATE V_MSQL;
                 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GPV_GASTOS_PROVEEDOR: ' ||sql%rowcount);

                 
                 ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN LOS PROPIETARIOS CON EL DOCIDENTIF INDICADOS: B39690516,A86486461,A78485752 ');
                 END IF;

            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE PROPIETARIO CON EL DOCIDENTIF INDICADO:  '''||V_DOCIDENTIF||''' ');
            END IF;

        

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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