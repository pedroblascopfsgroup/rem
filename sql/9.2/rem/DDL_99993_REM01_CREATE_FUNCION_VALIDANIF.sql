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

create or replace FUNCTION VALIDANIF (DNI IN VARCHAR2) RETURN NUMERIC AS

	V_DNI VARCHAR2(50);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'ESQUEMA_MASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16);
    V_NUM_REGS2 NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	letrasValidas CHAR(23);
	letraLeida CHAR(1);
	numero INTEGER;
	resto INTEGER;
	
BEGIN

 V_DNI := TRIM(DNI);

 IF LENGTH(V_DNI) <> 9 THEN
    return 0;
 END IF;

    numero := SUBSTR((V_DNI),1,8);
    numero := TO_NUMBER(numero);
    resto := numero MOD 23;
    letraLeida := SUBSTR((V_DNI),9,1);
    letraLeida := UPPER(letraLeida);

    IF resto = 0 THEN
        IF letraLeida = 'T' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 1 THEN
        IF letraLeida = 'R' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 2 THEN
        IF letraLeida = 'W' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 3 THEN
        IF letraLeida = 'A' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 4 THEN
        IF letraLeida = 'G' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 5 THEN
        IF letraLeida = 'M' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 6 THEN
        IF letraLeida = 'Y' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 7 THEN
        IF letraLeida = 'F' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 8 THEN
        IF letraLeida = 'P' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 9 THEN
        IF letraLeida = 'D' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 10 THEN
        IF letraLeida = 'X' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 11 THEN
        IF letraLeida = 'B' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 12 THEN
        IF letraLeida = 'N' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 13 THEN
        IF letraLeida = 'J' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 14 THEN
        IF letraLeida = 'Z' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 15 THEN
        IF letraLeida = 'S' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 16 THEN
        IF letraLeida = 'Q' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 17 THEN
        IF letraLeida = 'V' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 18 THEN
        IF letraLeida = 'H' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 19 THEN
        IF letraLeida = 'L' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 20 THEN
        IF letraLeida = 'C' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 21 THEN
        IF letraLeida = 'K' THEN
            return 1;
        ELSE
            return 0;
        END IF;

    ELSIF resto = 22 THEN
        IF letraLeida = 'E' THEN
            return 1;
        ELSE
            return 0;
        END IF;
    ELSE
        return 0;
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
END VALIDANIF;
/

EXIT
