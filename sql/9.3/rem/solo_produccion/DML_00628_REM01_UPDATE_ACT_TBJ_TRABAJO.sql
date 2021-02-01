--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210121
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8698
--## PRODUCTO=NO
--##
--## Finalidad: 
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
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';  -- Tabla a modificar
    V_TABLA_GPV VARCHAR2(100 CHAR):='GPV_GASTOS_PROVEEDOR';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8698'; -- USUARIOCREAR/USUARIOMODIFICAR

    V_COD_CIERRE NUMBER(16);
    V_COD_PENDIENTE NUMBER(16);
    V_COD_PENDIENTE_PAGO NUMBER(16);
    V_COD_VALIDADO NUMBER(16);
    V_COD_PAGADO NUMBER(16);
    V_COD_PAGADO2 NUMBER(16);
    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''CIE''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_CIERRE;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''PCI''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_PENDIENTE;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''05''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_PENDIENTE_PAGO;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''13''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_VALIDADO;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO=''05''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_PAGADO;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO=''13''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COD_PAGADO2;

        IF V_COD_CIERRE = 1 AND V_COD_PENDIENTE = 1 AND V_COD_PENDIENTE_PAGO = 1 AND V_COD_VALIDADO=1 AND V_COD_PAGADO = 1 AND V_COD_PAGADO2 = 1 THEN

            --SI EL ESTADO DEL GASTO ESTA PAGADO, PONEMOS EL ESTADO DEL TRABAJO EN CIERRE
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (
                        SELECT TBJ.TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
                        JOIN '||V_ESQUEMA||'.GLD_TBJ GLDTB ON GLDTB.TBJ_ID=TBJ.TBJ_ID
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID=GLDTB.GLD_ID
                        JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID=GLD.GPV_ID
                        WHERE TBJ.DD_EST_ID!=(SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''CIE'') 
                        AND TBJ.BORRADO=0 AND GPV.BORRADO=0 AND GLD.BORRADO=0 AND GLDTB.BORRADO=0 
                        AND GPV.DD_EGA_ID IN ((SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA
                        WHERE EGA.DD_EGA_CODIGO=''05''),(SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA
                        WHERE EGA.DD_EGA_CODIGO=''13''))
                        
                        ) T2
                    ON (T1.TBJ_ID = T2.TBJ_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''CIE''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJOS CON ESTADO DE GASTO EN (PAGADO) ACTUALIZADOS: '||sql%rowcount ||'');

            --SI EL ESTADO DEL GASTO ESTA NO PAGADO, PONEMOS EL ESTADO DEL TRABAJO EN PENDIENTE DE CIERRE
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (
                        SELECT TBJ.TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
                        JOIN '||V_ESQUEMA||'.GLD_TBJ GLDTB ON GLDTB.TBJ_ID=TBJ.TBJ_ID
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID=GLDTB.GLD_ID
                        JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID=GLD.GPV_ID
                        WHERE TBJ.DD_EST_ID!=(SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''PCI'') 
                        AND TBJ.BORRADO=0 AND GPV.BORRADO=0 AND GLD.BORRADO=0 AND GLDTB.BORRADO=0 
                        AND GPV.DD_EGA_ID NOT IN ((SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA
                        WHERE EGA.DD_EGA_CODIGO=''05''),(SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA
                        WHERE EGA.DD_EGA_CODIGO=''13''))
                        
                        ) T2
                    ON (T1.TBJ_ID = T2.TBJ_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''PCI''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJOS CON ESTADO DE GASTO EN (NO PAGADO) ACTUALIZADOS: '||sql%rowcount ||'');
           

            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (
                        SELECT TBJ.TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
                        WHERE TBJ.BORRADO=0 AND 
                        TBJ.DD_EST_ID=(SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''05'')
                        
                        ) T2
                    ON (T1.TBJ_ID = T2.TBJ_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO=''13''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJOS CON ESTADO (PENDIENTE DE PAGO) ACTUALIZADOS A (VALIDADO): '||sql%rowcount ||'');

        ELSE
            DBMS_OUTPUT.PUT_LINE('[FIN] NO EXISTE ALGUN CODIGO DE LOS INDICADOS EN LOS DICCIONARIOS');
        END IF;


        DBMS_OUTPUT.PUT_LINE('[FIN] ESTADOS DE TRABAJOS MODIFICADOS CORRECTAMENTE');
        
        COMMIT;
  
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