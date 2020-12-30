--/*
--######################################### 
--## AUTOR=Carlos Santos
--## FECHA_CREACION=20201021
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8267
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar PVE_NOMBRE
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8267'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar
    V_OFICINA VARCHAR2(50 CHAR) :='Oficina Cajamar ';
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
              USING(SELECT PVE_COD_REM, PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA||'
              WHERE DD_TPR_ID =
              (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR
              WHERE DD_TPR_DESCRIPCION = '''||TRIM(V_OFICINA)||''')) T2
              ON(T1.PVE_ID = T2.PVE_ID)
              WHEN MATCHED THEN UPDATE SET
              T1.PVE_NOMBRE = '''||V_OFICINA||'''||T2.PVE_COD_REM,
              USUARIOMODIFICAR = '''||V_USUARIO||''', 
              FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS CORRECTAMENTE');

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