--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12965
--## PRODUCTO=NO
--##
--## Finalidad: Insertar DD_ETG_EQV_TIPO_GASTO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'DD_ETG_EQV_TIPO_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_AUX VARCHAR2(50 CHAR) := 'AUX_REMVIP_12965'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-12965'; -- Usuario modificar
    V_NUM_TABLAS NUMBER(25);

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Se realiza la inserccion de las peps para el año 2023');

          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      DD_ETG_ID, DD_TGA_ID, DD_STG_ID, DD_ETG_CODIGO, DD_ETG_DESCRIPCION_POS,DD_ETG_DESCRIPCION_LARGA_POS,ELEMENTO_PEP,
                      COGRUG_POS,COTACA_POS,COSBAC_POS,COGRUG_NEG,COTACA_NEG,COSBAC_NEG,EJE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DD_CBC_ID) 

                      select '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL as DD_ETG_ID,AUX.DD_TGA_ID,AUX.DD_STG_ID,aux.codigo+rownum AS DD_ETG_CODIGO,
                      DD_ETG_DESCRIPCION_POS,DD_ETG_DESCRIPCION_POS AS DD_ETG_DESCRIPCION_LARGA_POS,
                        ELEMENTO_PEP,COGRUG_POS,COTACA_POS,COSBAC_POS,COGRUG_NEG,COTACA_NEG,COSBAC_NEG,AUX.EJE_ID,0 AS VERSION,USUARIOCREAR,FECHACREAR,BORRADO,
                        AUX.DD_CBC_ID
                        from (
                        select DISTINCT 
                        
                        TGA.DD_TGA_ID,
                        STG.DD_STG_ID,
                        rownum,
                        (SELECT DD_ETG_CODIGO AS DD_ETG_CODIGO FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ORDER BY TO_NUMBER(DD_ETG_CODIGO) DESC FETCH FIRST ROW ONLY) AS codigo,
                        AUX.ELEMENTO_PEP AS DD_ETG_DESCRIPCION_POS,
                        AUX.ELEMENTO_PEP AS DD_ETG_DESCRIPCION_LARGA_POS,
                        AUX.ELEMENTO_PEP AS ELEMENTO_PEP,
                        aux.grupo AS COGRUG_POS,
                        aux.tipo AS COTACA_POS,
                        aux.subtipo AS COSBAC_POS,

                        aux.grupo AS COGRUG_NEG,
                        aux.tipo AS COTACA_NEG,
                        aux.subtipo AS COSBAC_NEG,
                        '''||V_USUARIO||''' AS USUARIOCREAR,
                        SYSDATE AS FECHACREAR,
                        0 AS BORRADO,
                        EJE.EJE_ID,
                        CBC.DD_CBC_ID
                        from '||V_ESQUEMA||'.'||V_TABLA_AUX||' aux
                        LEFT join '||V_ESQUEMA||'.dd_stg_subtipos_gasto stg on 
                        REGEXP_REPLACE(CONVERT(REPLACE(REPLACE(UPPER(stg.dd_stg_descripcion),''ñ'',''ny''),''Ñ'',''ny''), ''US7ASCII''), ''[^a-zA-Z0-9 ]'') 
                        = REGEXP_REPLACE(CONVERT(REPLACE(REPLACE(UPPER(
                        DECODE(aux.subtipo_gasto,''Burofax 1ª Posesión'',''Burofax - 1ª Posesión'',
                                                ''Certificado Deuda'',''Certificado deuda comunidad'',
                                                ''Seguridad y Salud'',''Seguridad y Salud (SS)'',
                                                ''Seguridad y salud'',''Seguridad y Salud (SS)'',
                                                AUX.SUBTIPO_GASTO)
                        ),''ñ'',''ny''),''Ñ'',''ny''), ''US7ASCII''), ''[^a-zA-Z0-9 ]'')
                        AND STG.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.dd_tga_tipos_gasto TGA ON REGEXP_REPLACE(CONVERT(REPLACE(REPLACE(UPPER(TGA.dd_TGA_descripcion),''ñ'',''ny''),''Ñ'',''ny''), ''US7ASCII''), ''[^a-zA-Z0-9 ]'') 
                        = REGEXP_REPLACE(CONVERT(REPLACE(REPLACE(UPPER(aux.TIPO_GASTO),''ñ'',''ny''),''Ñ'',''ny''), ''US7ASCII''), ''[^a-zA-Z0-9 ]'')
                        AND TGA.BORRADO = 0 AND STG.DD_TGA_ID=TGA.DD_TGA_ID
                        JOIN '||V_ESQUEMA||'.act_eje_ejercicio EJE ON eje.eje_anyo=''2023'' AND EJE.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.dd_cbc_cartera_bc CBC ON cbc.dd_cbc_codigo=aux.dd_cbc_codigo AND CBC.BORRADO = 0
                        WHERE aux.tipo_gasto!=''IT HRE''
                        ORDER BY rownum ASC
                        ) aux';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS '||SQL%ROWCOUNT||' INSERTADOS CORRECTAMENTE en '||V_TEXT_TABLA||'');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   			
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