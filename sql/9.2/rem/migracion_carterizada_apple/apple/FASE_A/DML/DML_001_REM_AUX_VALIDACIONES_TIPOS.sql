--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20170522
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.4
--## INCIDENCIA_LINK=HREOS-2041
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  Rellenar el array
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  
  TYPE T_DRE IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_DRE IS TABLE OF T_DRE;
   
  V_ESQUEMA          VARCHAR2(25 CHAR):= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M   VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_TABLA   VARCHAR2(30 CHAR):= 'VALIDACIONES_TIPOS'; 
  TABLE_COUNT number(3); 											-- Vble. para validar la existencia de las Tablas.
  err_num NUMBER; 													-- Numero de errores
  err_msg VARCHAR2(2048); 											-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_EXIST NUMBER(10);

  V_DRE T_ARRAY_DRE := T_ARRAY_DRE
  (
		T_DRE('0','OK. Dato correcto.'),
		T_DRE('1','KO. [DUPLICADO]         Registro duplicado (en MIGRA o en PRODUCCION).'),
		T_DRE('2','KO. [DICCIONARIO]       Registro con valores de Diccionario incorrectos.'),
		T_DRE('3','KO. [VALOR POR DEFECTO] Registro con valores por defecto incorrectos.'),
		T_DRE('4','KO. [OBLIGATORIEDAD]    Registro con valores obligatorios no informados.'),		
		T_DRE('5','KO. [FUNCIONAL]         Registro con fallos funcionales.'),
		T_DRE('6','KO. [DEPENDENCIA]       Registro con registro dependiente no migrado.')
  );
  V_TMP_DRE T_DRE;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;

    IF TABLE_COUNT = 1 THEN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
        FOR I IN V_DRE.FIRST .. V_DRE.LAST
            LOOP
                V_TMP_DRE := V_DRE(I);
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CODIGO_RECHAZO = '''||V_TMP_DRE(1)||''' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXIST;

                IF V_EXIST = 1 THEN
                  DBMS_OUTPUT.PUT_LINE('Ya existe la validación: '''||V_TMP_DRE(1)||'''|'''||V_TMP_DRE(2)||''' ');
                ELSE

                  DBMS_OUTPUT.PUT_LINE('Insertando la validación: '''||V_TMP_DRE(1)||'''|'''||V_TMP_DRE(2)||''' ');
                  V_MSQL := '
                  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
                    (CODIGO_RECHAZO, MOTIVO_RECHAZO)
                  VALUES 
                    ('''||V_TMP_DRE(1)||''','''||V_TMP_DRE(2)||''')';
                  EXECUTE IMMEDIATE V_MSQL;
                END IF;
            END LOOP;
        END IF;

        V_TMP_DRE := NULL;

        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('[FIN] Motivos de rechazo insertados.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/
EXIT
