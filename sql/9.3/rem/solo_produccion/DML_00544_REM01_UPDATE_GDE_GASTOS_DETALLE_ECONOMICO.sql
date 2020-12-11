--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201124
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8398
--## PRODUCTO=NO
--## 
--## Finalidad: Poner recargo del gasto 12448209 a 0
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
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
   PL_OUTPUT VARCHAR2(20000 CHAR);
   V_MSQL VARCHAR(20000 CHAR);
   V_NUM_TABLAS NUMBER(16);
   V_USUARIO VARCHAR(25 CHAR) := 'REMVIP-8398';
   V_TABLA_GASTOS_PROVEEDOR VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR';
   V_TABLA_GASTOS_DETALLE VARCHAR2(50 CHAR):= 'GDE_GASTOS_DETALLE_ECONOMICO';
   V_GASTO_NUM NUMBER(16) := 12448209;
   V_GASTO_ID NUMBER(16);
 
BEGIN

   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.put_line('[INFO] ACTUALIZAR IMPORTE DE RECARGO DEL GASTO '''|| V_GASTO_NUM ||'''');

   -- Comprobamos que el gasto existe
   V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'|| V_TABLA_GASTOS_PROVEEDOR ||' WHERE GPV_NUM_GASTO_HAYA = '|| V_GASTO_NUM;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

   IF V_NUM_TABLAS = 1 THEN

      -- Cogemos el ID del gasto
      V_MSQL := 'SELECT GPV_ID FROM '|| V_ESQUEMA ||'.'|| V_TABLA_GASTOS_PROVEEDOR ||' WHERE GPV_NUM_GASTO_HAYA = '|| V_GASTO_NUM;
	   EXECUTE IMMEDIATE V_MSQL INTO V_GASTO_ID;	

      -- Actualizamos los campos necesarios
      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_GASTOS_DETALLE ||' 
               SET GDE_RECARGO = 0,
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE
               WHERE GPV_ID = '|| V_GASTO_ID ||'';

      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] GASTO ACTUALIZADO CON ÉXITO');
   
   ELSE 

      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL GASTO '''|| V_GASTO_NUM ||'''');

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
