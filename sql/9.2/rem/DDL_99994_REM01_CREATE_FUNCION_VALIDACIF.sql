--/*
--##########################################
--## AUTOR=Adrian Molina Garrido
--## FECHA_CREACION=20190602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4337
--## PRODUCTO=NO
--##
--## Finalidad: VALIDANIF
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace FUNCTION VALIDACIF (CIF IN VARCHAR2) RETURN NUMERIC AS

	V_CIF VARCHAR2(50);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'ESQUEMA_MASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16);
    V_NUM_REGS2 NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	 sumaA INTEGER;
 sumaB INTEGER;
 numero1 VARCHAR2(2);
 numero2 VARCHAR2(2);
 numero3 VARCHAR2(2);
 numero4 VARCHAR2(2);
 numero5 VARCHAR2(2);
 numero6 VARCHAR2(2);
 numero7 VARCHAR2(2);
 datoFinal VARCHAR2(2);
 n1 INTEGER;
 n3 INTEGER;
 n5 INTEGER;
 n7 INTEGER;
 n1_1 INTEGER; 
 n1_2 INTEGER;
 n3_1 INTEGER;
 n3_2 INTEGER;
 n5_1 INTEGER;
 n5_2 INTEGER;
 n7_1 INTEGER;
 n7_2 INTEGER;
 sumaTotal INTEGER;
 numFinal INTEGER;

BEGIN

 V_CIF := TRIM(CIF);
 
 DBMS_OUTPUT.PUT_LINE(V_CIF);

 numero1 := SUBSTR((V_CIF),2,1);
 numero2 := SUBSTR((V_CIF),3,1);
 numero3 := SUBSTR((V_CIF),4,1);
 numero4 := SUBSTR((V_CIF),5,1);
 numero5 := SUBSTR((V_CIF),6,1);
 numero6 := SUBSTR((V_CIF),7,1);
 numero7 := SUBSTR((V_CIF),8,1);
 datoFinal := SUBSTR(UPPER(V_CIF),9,1);

 IF LENGTH(V_CIF) <> 9 THEN
    return 0;
 END IF;

 numero1 := TO_NUMBER(numero1);
 numero2 := TO_NUMBER(numero2);
 numero3 := TO_NUMBER(numero3);
 numero4 := TO_NUMBER(numero4);
 numero5 := TO_NUMBER(numero5);
 numero6 := TO_NUMBER(numero6);
 numero7 := TO_NUMBER(numero7);

 sumaA := numero2 + numero4 + numero6;

 numero1 := numero1 * 2;

 IF LENGTH(numero1) = 2 THEN
        n1_1 := SUBSTR((numero1),1,1);
        n1_2 := SUBSTR((numero1),2,1);

        numero1 := n1_1 + n1_2;
    ELSE
    numero1 := numero1;
    END IF;

numero3 := numero3 * 2;

 IF LENGTH(numero3) = 2 THEN
        n3_1 := SUBSTR((numero3),1,1);
        n3_2 := SUBSTR((numero3),2,1);

        numero3 := n3_1 + n3_2;
    ELSE
    numero3 := numero3;
    END IF;

numero5 := numero5 * 2;

 IF LENGTH(numero5) = 2 THEN
        n5_1 := SUBSTR((numero5),1,1);
        n5_2 := SUBSTR((numero5),2,1);

        numero5 := n5_1 + n5_2;
    ELSE
    numero5 := numero5;
    END IF;

numero7 := numero7 * 2;

 IF LENGTH(numero7) = 2 THEN
        n7_1 := SUBSTR((numero7),1,1);
        n7_2 := SUBSTR((numero7),2,1);

        numero7 := n7_1 + n7_2;
    ELSE
    numero7 := numero7;
    END IF;

 sumaB := numero1 + numero3 + numero5 + numero7;

 sumaTotal := sumaA + sumaB;

 sumaTotal := SUBSTR((sumaTotal),2,1);

 numFinal := 10 - sumaTotal;

 IF numFinal = 10 THEN
    numFinal := 0;
 END IF;

 IF numFinal = 0 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'J' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 1 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'A' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 2 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'B' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 3 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'C' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 4 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'D' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 5 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'E' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 6 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'F' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 7 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'G' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 8 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'H' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

ELSIF numFinal = 9 THEN
    IF ISNUMERIC(datoFinal) = 1 THEN
        IF numFinal = datoFinal THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        IF datoFinal = 'I' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    END IF;

END IF;

                          
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
	        RETURN (0);
          ROLLBACK;
          RAISE;
END VALIDACIF;
/

EXIT
