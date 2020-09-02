--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7994
--## PRODUCTO=NO
--## 
--## Finalidad: Quitar saltos de linea del campo nombre de la tabla proveedor
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_TABLA VARCHAR2(100 CHAR):='ACT_PVE_PROVEEDOR'; --Vble. auxiliar para almacenar el nombre de la tabla
    V_ID_PROVEEDOR VARCHAR2(100 CHAR):='8816'; --Vble. auxiliar para almacenar el id del proveedor
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-7994'; --Vble. auxiliar para almacenar el usuario que modifica
    V_NOMBRE VARCHAR2(100 CHAR); --Vble. auxiliar para almacenar el nombre sin saltos de linea
    V_NOMBRE_COMERCIAL VARCHAR2(100 CHAR); --Vble. auxiliar para almacenar el nombre sin saltos de linea
    V_COUNT NUMBER(16); --Vble. auxiliar para realizar comprobaciones

   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
      
   --COMPRUEBO SU EXISTE EL PROVEEDOR
   DBMS_OUTPUT.PUT_LINE('[INFO] Realizando comprobaciones');

   V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_ID='||V_ID_PROVEEDOR||'';
   EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	if V_COUNT = 1 then

        --OBTENEMOS EL NOMBRES SIN SALTOS DE LINEA
        V_MSQL :='SELECT REPLACE (REPLACE (REPLACE (PVE_NOMBRE,CHR (10), ''''),CHR (13), ''''),'''','''') 
                 FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_ID='||V_ID_PROVEEDOR||' ';

            EXECUTE IMMEDIATE V_MSQL INTO V_NOMBRE;

            V_MSQL :='SELECT REPLACE (REPLACE (REPLACE (PVE_NOMBRE_COMERCIAL,CHR (10), ''''),CHR (13), ''''),'''','''') 
                 FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PVE_ID='||V_ID_PROVEEDOR||' ';

            EXECUTE IMMEDIATE V_MSQL INTO V_NOMBRE_COMERCIAL;

       -- ACTUALIZAMOS EL NOMBRE SIN ESPACIOS
        DBMS_OUTPUT.PUT_LINE('[INFO] Existe proveedor, realizando modificacion');

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                SET PVE_NOMBRE = '''||V_NOMBRE||''',
                PVE_NOMBRE_COMERCIAL = '''||V_NOMBRE_COMERCIAL||''',
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE 
                WHERE PVE_ID = '||V_ID_PROVEEDOR||'';				
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');

    else
      DBMS_OUTPUT.PUT_LINE('[INFO] No existe el proveedor con el id '||V_ID_PROVEEDOR||' en la tabla '||V_TABLA||'');
    end if;     
     
     
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
