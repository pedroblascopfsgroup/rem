--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20210210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12983
--## PRODUCTO=NO
--## 
--## Finalidad: Añadimos motivos de rechazo a DD_MRT_MOTIVO_RECHAZO_TRABAJO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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

    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-12983'; 
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('F01' ,'No pueden darse de alta prefacturas con trabajos con activos de distintas zonas (Canarias, CC.AA y/o resto del territorio)', '1', 'WHERE EXISTS (
        SELECT 1
        FROM (
            SELECT TBJ_ID
                , ZONA
            FROM #ESQUEMA#.AUX_PROC_GEN_ALB_PFA
        ) PFA
        WHERE PFA.TBJ_ID = AUX.TBJ_ID
        GROUP BY PFA.TBJ_ID
        HAVING COUNT(1) > 1
    )'),
      T_TIPO_DATA('F02' ,'No pueden darse de alta prefacturas con distintos destinatarios', '1', 'WHERE EXISTS (
        SELECT 1
        FROM (
            SELECT GRUPO 
            FROM (
                SELECT DISTINCT GRUPO
                    , DD_DEG_ID
                FROM #ESQUEMA#.AUX_PROC_GEN_ALB_PFA
            )
            GROUP BY GRUPO
            HAVING COUNT(1) > 1
        ) PFA
        WHERE PFA.GRUPO = AUX.GRUPO
    )'),
      T_TIPO_DATA('F03' ,'No pueden darse de alta prefacturas con trabajos sin importes, importes a cero y/o sin suplidos', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        LEFT JOIN (
                SELECT PSU.TBJ_ID, PSU.IMPORTE_PROV_SUPL
                FROM (
                    SELECT PSU.TBJ_ID
                        , SUM(
                            CASE
                                WHEN TAD.DD_TAD_CODIGO = ''''01''''
                                THEN -NVL(PSU.PSU_IMPORTE, 0)
                                WHEN TAD.DD_TAD_CODIGO = ''''02''''
                                THEN NVL(PSU.PSU_IMPORTE, 0)
                            END
                        ) IMPORTE_PROV_SUPL
                    FROM #ESQUEMA#.ACT_PSU_PROVISION_SUPLIDO PSU
                    JOIN #ESQUEMA#.DD_TAD_TIPO_ADELANTO TAD ON TAD.DD_TAD_ID = PSU.DD_TAD_ID
                    AND TAD.BORRADO = 0
                    WHERE PSU.BORRADO = 0
                    GROUP BY PSU.TBJ_ID
                ) PSU
                WHERE PSU.IMPORTE_PROV_SUPL <> 0
            ) SUP ON SUP.TBJ_ID = TBJ.TBJ_ID
        WHERE TBJ.BORRADO = 0
            AND NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) = 0 
            AND NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) = 0 
            AND NVL(SUP.IMPORTE_PROV_SUPL, 0) = 0
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'),
      T_TIPO_DATA('F04' ,'No pueden darse de alta prefacturas con trabajos incluidos en gastos previamente', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.GPV_GASTOS_PROVEEDOR GPV
        JOIN #ESQUEMA#.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
            AND GLD.BORRADO = 0
        JOIN #ESQUEMA#.GLD_TBJ ON GLD_TBJ.GLD_ID = GLD.GLD_ID
        WHERE GPV.BORRADO = 0 
            AND GLD_TBJ.TBJ_ID = AUX.TBJ_ID
    )'),
      T_TIPO_DATA('F05' ,'No pueden darse de alta prefacturas con trabajos con tarifa plana', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        WHERE NVL(TBJ.STR_TARIFA_PLANA, 0) = 1
            AND TBJ.BORRADO = 0
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'),
      T_TIPO_DATA('F06' ,'No pueden darse de alta prefacturas con trabajos con más de un propietario', '1', 'WHERE EXISTS (
        SELECT 1
        FROM (
            SELECT DISTINCT TBJ_ID, PRO_ID
            FROM #ESQUEMA#.AUX_PROC_GEN_ALB_PFA
        ) PFA
        WHERE PFA.TBJ_ID = AUX.TBJ_ID
        GROUP BY PFA.TBJ_ID
        HAVING COUNT(1) > 1
    )'),
      T_TIPO_DATA('F07' ,'No pueden darse de alta prefacturas cuando el albarán del día ya está validado', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ALB_ALBARAN ALB
        JOIN #ESQUEMA#.DD_ESA_ESTADO_ALBARAN ESA ON ESA.DD_ESA_ID = ALB.DD_ESA_ID
            AND ESA.BORRADO = 0
        WHERE ALB.BORRADO = 0
            AND TRUNC(ALB.ALB_FECHA_ALBARAN) = TRUNC(SYSDATE)
            AND ESA.DD_ESA_CODIGO = ''''VAL''''
    )'),
      T_TIPO_DATA('F08' ,'No pueden darse de alta prefacturas con trabajos sin área peticionaria', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        WHERE TBJ.DD_IRE_ID IS NULL
            AND TBJ.BORRADO = 0
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'),
      T_TIPO_DATA('F09' ,'No pueden darse de alta prefacturas con trabajos sin fecha de validación', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        WHERE TBJ.TBJ_FECHA_VALIDACION IS NULL
            AND TBJ.BORRADO = 0
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'),
      T_TIPO_DATA('F10' ,'No pueden darse de alta prefacturas con trabajos en la lista de exclusión (PROC_AUX_TRABAJOS_EXCL)', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        JOIN #ESQUEMA#.PROC_AUX_TRABAJOS_EXCL EXCL ON EXCL.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
        WHERE TBJ.BORRADO = 0
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'),
      T_TIPO_DATA('F11' ,'No pueden darse de alta prefacturas con trabajos distintos a los de la lista de inclusión (PROC_AUX_TRABAJOS_INCL)', '1', 'WHERE NOT EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        JOIN #ESQUEMA#.PROC_AUX_TRABAJOS_INCL INCL ON INCL.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
        WHERE TBJ.BORRADO = 0
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )
    AND (
        SELECT COUNT(1)
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        JOIN #ESQUEMA#.PROC_AUX_TRABAJOS_INCL INCL ON INCL.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
        WHERE TBJ.BORRADO = 0
    ) > 0'
    ),
      T_TIPO_DATA('F12' ,'No pueden darse de alta prefacturas con trabajos de la cartera CAJAMAR', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        JOIN #ESQUEMA#.ACT_TBJ ATB ON ATB.TBJ_ID = TBJ.TBJ_ID
        JOIN #ESQUEMA#.ACT_ACTIVO ACT ON ACT.ACT_ID = ATB.ACT_ID
            AND ACT.BORRADO = 0
        JOIN #ESQUEMA#.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            AND CRA.BORRADO = 0
        WHERE TBJ.BORRADO = 0
            AND CRA.DD_CRA_CODIGO = ''''01''''
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'
    ),
      T_TIPO_DATA('F13' ,'No pueden darse de alta prefacturas con trabajos sin proveedor', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        WHERE TBJ.BORRADO = 0
            AND TBJ.PVC_ID IS NULL
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )'
    ),
      T_TIPO_DATA('F14' ,'No pueden darse de alta prefacturas con trabajos con área peticionaria de Edificación', '1', 'WHERE EXISTS (
        SELECT 1
        FROM #ESQUEMA#.ACT_TBJ_TRABAJO TBJ
        JOIN #ESQUEMA#.DD_IRE_IDENTIFICADOR_REAM IRE ON IRE.DD_IRE_ID = TBJ.DD_IRE_ID
            AND IRE.BORRADO = 0
        WHERE TBJ.BORRADO = 0
            AND IRE.DD_IRE_CODIGO = ''''04''''
            AND TBJ.TBJ_ID = AUX.TBJ_ID
    )')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_MRT_MOTIVO_RECHAZO_TRABAJO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MRT_MOTIVO_RECHAZO_TRABAJO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MRT_MOTIVO_RECHAZO_TRABAJO WHERE DD_MRT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MRT_MOTIVO_RECHAZO_TRABAJO '||
                    'SET DD_MRT_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_MRT_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', PROCESO_VALIDAR = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MRT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MRT_MOTIVO_RECHAZO_TRABAJO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MRT_MOTIVO_RECHAZO_TRABAJO (' ||
                      'DD_MRT_ID, DD_MRT_CODIGO, DD_MRT_DESCRIPCION, DD_MRT_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MRT_MOTIVO_RECHAZO_TRABAJO ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT