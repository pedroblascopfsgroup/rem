--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200820
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7971
--## PRODUCTO=NO
--## 
--## Finalidad: PONER DESCRIPCION EN TABLA TEMPORAL Y ACTUALIZAR CON INFO DE TABLA AUX
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-7971';
    V_COUNT NUMBER(16):= 0;
    V_VALIDATOR NUMBER(16); -- Longitud de la cadena total
    V_EXTRA_CHAR NUMBER(16):= 0; -- Cantidad de caracteres a eliminar
    V_TEXTO_CORTADO VARCHAR(100 CHAR);

    V_TEXT VARCHAR(100 CHAR):= '*Oferta válida para contratos formalizados entre el 15 de agosto y el 15 de septiembre de 2020';
    
    CURSOR ACTIVOS IS 
        SELECT ACT_NUM, ACT_DESC
        FROM REM01.AUX_REMVIP_7971;

    FILA ACTIVOS%ROWTYPE;
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
      
    OPEN ACTIVOS;
    
    V_COUNT := 0;
    
    LOOP
        FETCH ACTIVOS INTO FILA;
        EXIT WHEN ACTIVOS%NOTFOUND;

	--INSERTAMOS EN LA TABLA TEMPORAL
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_REMVIP_7971
		(ACT_ID,ACT_DESCRIPCION) VALUES (
		(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||'  AND BORRADO = 0),
		(SELECT ACT_DESCRIPCION FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||'  AND BORRADO = 0))';

	EXECUTE IMMEDIATE V_MSQL;

	--COMPROBAMOS LONGITUD DEL CAMPO A INTRODUCIR
	V_MSQL := 'SELECT LENGTH(CONCAT(CONCAT('''||FILA.ACT_DESC||''', (SELECT ACT_DESCRIPCION FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||'  AND BORRADO = 0)), '''||V_TEXT||''')) FROM DUAL';

	EXECUTE IMMEDIATE V_MSQL INTO V_VALIDATOR;

        V_EXTRA_CHAR := 0;
        
        IF V_VALIDATOR > 250 THEN

            V_MSQL := 'SELECT LENGTH(ACT_DESCRIPCION) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||'  AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXTRA_CHAR;

            V_EXTRA_CHAR := V_EXTRA_CHAR - (V_VALIDATOR - 250);

            V_MSQL := 'SELECT SUBSTR(ACT_DESCRIPCION,0,'||V_EXTRA_CHAR||') FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||'  AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_TEXTO_CORTADO;

            -- ACTUALIZAMOS DESCRIPCION CON VALOR DE TABLA AUX 
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
                SET ACT_DESCRIPCION = CONCAT(CONCAT('''||FILA.ACT_DESC||''','''||V_TEXTO_CORTADO||'''),	'''||V_TEXT||'''),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||' AND BORRADO = 0';				
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');

        ELSE
		
            -- ACTUALIZAMOS DESCRIPCION CON VALOR DE TABLA AUX 
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
                SET ACT_DESCRIPCION = CONCAT(CONCAT('''||FILA.ACT_DESC||''', (SELECT SUBSTR(ACT_DESCRIPCION,'||V_EXTRA_CHAR||') FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||'  AND BORRADO = 0)), 				'''||V_TEXT||'''),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_NUM_ACTIVO = '||FILA.ACT_NUM||' AND BORRADO = 0';				
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');
        
        END IF;

            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se han iterado con '||V_COUNT||' activos de AUX_REMVIP_7971');
    CLOSE ACTIVOS;
     
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
