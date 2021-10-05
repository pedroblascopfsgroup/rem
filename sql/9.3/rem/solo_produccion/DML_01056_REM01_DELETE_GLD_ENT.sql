--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10440
--## PRODUCTO=NO
--##
--## Finalidad: BORRADO GLD_ENT ENT_ID = 40791,35198
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10440'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_COUNT NUMBER(16);
    V_GASTOS NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_NUM_TABLAS NUMBER(16);


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --ACT_NUM_ACTIVO  --PARTICIPACIÓN % 
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('7034526','0.76'),
        T_TIPO_DATA('7235198','6.08'),
        T_TIPO_DATA('7240971','0.76'),
        T_TIPO_DATA('7236324','0.74')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    --Comprobamos el dato a insertar
    V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 14323721';
    EXECUTE IMMEDIATE V_MSQL INTO V_GASTOS;

    IF V_GASTOS = 1 THEN

        DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE BORRADO');

        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GLD_ENT T1 USING (
                        SELECT DISTINCT
                            GLD.GLD_ID  
                            ,GPV.GPV_NUM_GASTO_HAYA
                            ,GLDENT.ENT_ID
                        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
                            AND GLD.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.GLD_ENT GLDENT ON GLDENT.GLD_ID = GLD.GLD_ID
                            AND GLDENT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GLDENT.DD_ENT_ID 
                            AND ENT.DD_ENT_CODIGO = ''PRO''
                        WHERE GPV.BORRADO=0 
                        AND GPV.GPV_NUM_GASTO_HAYA = 14323721
                        AND GLDENT.ENT_ID IN (40791,35198)
                    ) T2 ON (T1.GLD_ID = T2.GLD_ID AND T1.ENT_ID=T2.ENT_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1,
                    T1.USUARIOBORRAR = '''||V_USU||''',
                    T1.FECHABORRAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE MODIFICACIÓN DE PORCENTAJES');
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos el dato a insertar
        V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

            IF V_COUNT = 1 THEN

                V_MSQL:= 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

                V_SQL := 'SELECT 
                            COUNT(1) 
                        FROM '||V_ESQUEMA||'.GLD_ENT 
                        WHERE ENT_ID = '||V_ACT_ID||' 
                        AND GLD_ID = ( SELECT DISTINCT
                                            GLD.GLD_ID                        
                                        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
                                            AND GLD.BORRADO = 0
                                        WHERE GPV.BORRADO=0 
                                        AND GPV.GPV_NUM_GASTO_HAYA = 14323721
                                        )';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                
                --Si existe lo modificamos
                IF V_NUM_TABLAS > 0 THEN				
                
                DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO ENT_ID: '||V_ACT_ID||', GLD_PARTICIPACION_GASTO: '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');

                V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GLD_ENT '||
                            'SET   GLD_PARTICIPACION_GASTO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                            ,USUARIOMODIFICAR = '''||V_USU||'''
                            ,FECHAMODIFICAR = SYSDATE
                            WHERE ENT_ID = '||V_ACT_ID||'
                            AND GLD_ID=( SELECT DISTINCT
                                            GLD.GLD_ID                        
                                        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
                                            AND GLD.BORRADO = 0
                                        WHERE GPV.BORRADO=0 
                                        AND GPV.GPV_NUM_GASTO_HAYA = 14323721
                                        )';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
                
                --Si no existe, lo insertamos   
                ELSE
            
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   

                V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.GLD_ENT 
                            (
                                GLD_ENT_ID
                                ,GLD_ID
                                ,DD_ENT_ID
                                ,ENT_ID
                                ,GLD_PARTICIPACION_GASTO
                                ,USUARIOCREAR
                                ,FECHACREAR) 
                            SELECT 
                                '||V_ESQUEMA||'.S_GLD_ENT.NEXTVAL
                                ,(SELECT DISTINCT
                                        GLD.GLD_ID                        
                                    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
                                        AND GLD.BORRADO = 0
                                    WHERE GPV.BORRADO=0 
                                    AND GPV.GPV_NUM_GASTO_HAYA = 14323721
                                )
                                ,(SELECT DD_ENT_ID FROM '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT WHERE ENT.DD_ENT_CODIGO = ''ACT'')
                                ,'''||V_ACT_ID||'''
                                ,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
                                ,'''||V_USU||'''
                                ,SYSDATE
                            FROM DUAL';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
                
                END IF;

            END IF;

            END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO 14323721 NO EXISTE');
    END IF;
        
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
