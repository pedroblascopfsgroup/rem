--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2728
--## PRODUCTO=NO
--##
--## Finalidad: preparar gastos para envío a UVEM y revisar su retorno
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2728';
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

   EXECUTE IMMEDIATE   'MERGE INTO REM01.GGE_GASTOS_GESTION T1
                        USING (
                            SELECT GPV_ID
                            FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                            WHERE GPV_NUM_GASTO_HAYA IN (10103936, 
				10103938, 
				10103940, 
				10016810, 
				10046359, 
				10046360, 
				10046399, 
				9462119, 
				9462099, 
				9462111, 
				9462140, 
				9462139, 
				9462110, 
				9462137, 
				9462103, 
				9462102, 
				9462117, 
				9462116, 
				9462101, 
				9462118, 
				10015603, 
				10015606, 
				10015607, 
				10015619, 
				10015636, 
				10015645, 
				10015648, 
				10015652, 
				10015669, 
				10015672, 
				10015679, 
				10015682, 
				10015693, 
				10015695, 
				10015699, 
				10015700, 
				10015707, 
				10015710, 
				10015714, 
				10015718, 
				10015735, 
				10015736, 
				10015740, 
				10015758, 
				10015772, 
				10015805, 
				10015806, 
				10015807, 
				10015810, 
				10015811, 
				10015815, 
				10015816, 
				10015817, 
				10015818, 
				10015819, 
				10015820, 
				10015826, 
				10015828, 
				10015830, 
				10015832, 
				10015841, 
				10015842, 
				10015843, 
				10015844, 
				10098141, 
				9462586, 
				9629792, 
				9461533, 
				9461538, 
				9461532, 
				9461537, 
				9461540, 
				9461530, 
				9461529, 
				9461536, 
				9461535, 
				9461528, 
				9461544, 
				9462972, 
				10015689, 
				10015796, 
				10015797, 
				10015798, 
				10015799, 
				10015809, 
				10015829, 
				10015795, 
				10015835, 
				10015837, 
				10015794, 
				10015791, 
				10015814, 
				10015836, 
				10015838, 
				10015792, 
				10015839, 
				10015840, 
				9461885, 
				9461873, 
				9461907, 
				9461875, 
				9461858, 
				9461874, 
				9461908, 
				9461872, 
				9461906, 
				9461871, 
				9461905, 
				9461851, 
				9461904, 
				9461857, 
				9461883, 
				9461882, 
				9461856, 
				9461855, 
				9461881, 
				9461849, 
				9461848, 
				9461853)
                        
                            ) T2
                        ON (T1.GPV_ID = T2.GPV_ID)
                        WHEN MATCHED THEN UPDATE SET
                            T1.DD_EAH_ID = 3
                          , T1.GGE_FECHA_EAH = SYSDATE
                          , T1.DD_EAP_ID = 1
                          , T1.GGE_FECHA_EAP = NULL
                          , T1.GGE_MOTIVO_RECHAZO_PROP = NULL
                          , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL
                          , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                          , T1.FECHAMODIFICAR = SYSDATE';
                       

 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GGE_GASTOS_GESTION');    

--Ponemos el estado de autorización por parte de Haya en Autorizado y eliminamos el estado de autorización del propietario, así como actualizar la fecha del estado de autorización de Haya y eliminamos las fechas de estado de autorización del propietario y de envío al propietario

         EXECUTE IMMEDIATE   ' MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1
                               USING (
                                   SELECT GPV_ID
                                   FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                   WHERE GPV_NUM_GASTO_HAYA IN (10103936, 
				10103938, 
				10103940, 
				10016810, 
				10046359, 
				10046360, 
				10046399, 
				9462119, 
				9462099, 
				9462111, 
				9462140, 
				9462139, 
				9462110, 
				9462137, 
				9462103, 
				9462102, 
				9462117, 
				9462116, 
				9462101, 
				9462118, 
				10015603, 
				10015606, 
				10015607, 
				10015619, 
				10015636, 
				10015645, 
				10015648, 
				10015652, 
				10015669, 
				10015672, 
				10015679, 
				10015682, 
				10015693, 
				10015695, 
				10015699, 
				10015700, 
				10015707, 
				10015710, 
				10015714, 
				10015718, 
				10015735, 
				10015736, 
				10015740, 
				10015758, 
				10015772, 
				10015805, 
				10015806, 
				10015807, 
				10015810, 
				10015811, 
				10015815, 
				10015816, 
				10015817, 
				10015818, 
				10015819, 
				10015820, 
				10015826, 
				10015828, 
				10015830, 
				10015832, 
				10015841, 
				10015842, 
				10015843, 
				10015844, 
				10098141, 
				9462586, 
				9629792, 
				9461533, 
				9461538, 
				9461532, 
				9461537, 
				9461540, 
				9461530, 
				9461529, 
				9461536, 
				9461535, 
				9461528, 
				9461544, 
				9462972, 
				10015689, 
				10015796, 
				10015797, 
				10015798, 
				10015799, 
				10015809, 
				10015829, 
				10015795, 
				10015835, 
				10015837, 
				10015794, 
				10015791, 
				10015814, 
				10015836, 
				10015838, 
				10015792, 
				10015839, 
				10015840, 
				9461885, 
				9461873, 
				9461907, 
				9461875, 
				9461858, 
				9461874, 
				9461908, 
				9461872, 
				9461906, 
				9461871, 
				9461905, 
				9461851, 
				9461904, 
				9461857, 
				9461883, 
				9461882, 
				9461856, 
				9461855, 
				9461881, 
				9461849, 
				9461848, 
				9461853)
                               
                                   ) T2
                               ON (T1.GPV_ID = T2.GPV_ID)
                               WHEN MATCHED THEN UPDATE SET
                                   T1.DD_EGA_ID = 3, T1.PRG_ID = NULL, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
                               
        
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GPV_GASTOS_PROVEEDOR');
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
