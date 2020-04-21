--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7055
--## PRODUCTO=NO
--## 
--## Finalidad: Arreglo campo con valor mas largo que el destino
--##                    
--## INSTRUCCIONES:  
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ACT_PRD_PROVEEDOR_DIRECCION.PRD_DIRECCION a 60CHAR.');

    
    execute immediate '
    UPDATE '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION SET 
    PRD_NOMBRE = ''Vía de los Poblado,Parque Empresarial Cristalia Edificio 9'',
	USUARIOMODIFICAR = ''REMVIP-7055'',
	FECHAMODIFICAR = SYSDATE
    where prd_id = 33506
    ';


    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');


    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
