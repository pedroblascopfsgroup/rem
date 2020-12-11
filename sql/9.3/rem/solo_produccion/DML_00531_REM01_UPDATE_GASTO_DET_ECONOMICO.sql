--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201113
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8358
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar principal sujeto en gasto
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8358'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_GASTO NUMBER(16):= 12217352;
    V_NUM_TABLAS NUMBER(16);
    
BEGIN	

   	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_GASTO||'
                AND BORRADO = 0';	
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN	

        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR PRINCIPAL SUJETO A GASTO ' ||V_GASTO);	

        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GDE_GASTOS_DETALLE_ECONOMICO SET
                    GDE_PRINCIPAL_SUJETO = 57413, USUARIOMODIFICAR = ''' || V_USR || ''',
                    FECHAMODIFICAR = SYSDATE WHERE GPV_ID = (SELECT GPV_ID FROM
                    '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_GASTO||'
                    AND BORRADO = 0) AND BORRADO = 0';	
        
        EXECUTE IMMEDIATE V_MSQL;	

        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO PRINCIPAL SUJETO A GASTO ' ||V_GASTO);	


    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE GASTO ' ||V_GASTO);	

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
EXIT;
