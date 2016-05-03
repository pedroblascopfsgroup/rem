--/*
--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160503
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3091
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA      VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

   TYPE T_TABLAS IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;
      V_BANKMASTER T_ARRAY_TABLAS := T_ARRAY_TABLAS(
                        T_TABLAS('CM01','TEL_PER'),
                        T_TABLAS('CM01','TEL_TELEFONOS')
                        );

   -- Vble. para loop
   V_TEMP_TABLAS  T_TABLAS;
   -- Vble. para almacenar esquema
   V_TEMP_ESQUEMA  VARCHAR(30);

BEGIN

dbms_output.enable(1000000);

--##########################################
--## DESACTIVAR RESTRICCIONES DE CLAVE AJENA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_BANKMASTER.FIRST .. V_BANKMASTER.LAST
   LOOP
      BEGIN
        V_TEMP_TABLAS := V_BANKMASTER(I);

        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
        LOOP
            BEGIN

                   DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );
                   EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
            END;
        END LOOP;

     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     END;
   END LOOP;
   COMMIT;

--##########################################
--## DESACTIVAR RESTRICCIONES DE CLAVE PRIMARIA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_BANKMASTER.FIRST .. V_BANKMASTER.LAST
   LOOP
      BEGIN
        V_TEMP_TABLAS := V_BANKMASTER(I);

        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
        LOOP
            BEGIN

                   DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );
                   EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';
            END;
        END LOOP;

     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     END;
   END LOOP;
   COMMIT;



--##########################################
--## TRUNCADO DE TABLAS
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**Truncamos tablas**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_BANKMASTER.FIRST .. V_BANKMASTER.LAST
   LOOP
      begin
        V_TEMP_TABLAS := V_BANKMASTER(I);
        DBMS_OUTPUT.PUT_LINE('Truncando tabla : '||V_TEMP_TABLAS(1)||'.'||V_TEMP_TABLAS(2));
        V_MSQL := 'TRUNCATE TABLE '||V_TEMP_TABLAS(1)||'.'||V_TEMP_TABLAS(2);
        EXECUTE IMMEDIATE V_MSQL;

        -- PRO_ANALIZA(V_TEMP_TABLAS(1),V_TEMP_TABLAS(2));  --ANALIZAMOS LA TABLA

        V_TEMP_ESQUEMA := V_TEMP_TABLAS(1); -- GUARDAMOS EL ESQUEMA EN USO

     exception when others then
       DBMS_OUTPUT.PUT_LINE('ERROR al truncar la tabla ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     end;
   END LOOP; --LOOP BANKMASTER
   COMMIT;

--##########################################
--## ACTIVAMOS DE NUEVO RESTRICCIONES DE CLAVE PRIMARIA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_BANKMASTER.FIRST .. V_BANKMASTER.LAST
   LOOP
        V_TEMP_TABLAS := V_BANKMASTER(I);

        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P'
                  AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
        LOOP
            BEGIN
                       DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );
                       EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;

                        --##########################################
                        --## ACTIVAMOS DE NUEVO RESTRICCIONES EN CASCADA
                        --##########################################

                       FOR H IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE R_CONSTRAINT_NAME=J.CONSTRAINT_NAME )
                        LOOP
                            BEGIN
                                DBMS_OUTPUT.PUT_LINE('Activando : '|| H.table_name ||'.'|| H.constraint_name );
                                EXECUTE IMMEDIATE 'ALTER TABLE ' || H.TABLE_NAME || ' ENABLE CONSTRAINT ' || H.CONSTRAINT_NAME;

                            EXCEPTION WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
                            END;
                        END LOOP H;

         EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
         END;
        END LOOP;
   END LOOP;
   COMMIT;

--##########################################
--## ACTIVAMOS DE NUEVO RESTRICCIONES DE CLAVE AJENA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_BANKMASTER.FIRST .. V_BANKMASTER.LAST
   LOOP
        V_TEMP_TABLAS := V_BANKMASTER(I);

        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R'
                  AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
        LOOP
            BEGIN
                       DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );
                       EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;

         EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
         END;
        END LOOP;
   END LOOP;
   COMMIT;

--##########################################
--## LISTADO RESTRICCIONES NO ACTIVADAS
--##########################################

   DBMS_OUTPUT.PUT_LINE('*******************************' );
   DBMS_OUTPUT.PUT_LINE('**FALTA ACTIVAR RESTRICCIONES**' );
   DBMS_OUTPUT.PUT_LINE('*******************************' );

        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE  STATUS='DISABLED'
                AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
        LOOP
            BEGIN
                DBMS_OUTPUT.PUT_LINE('Activacion extra : '|| J.table_name ||'.'|| J.constraint_name );
                 EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;

         EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
         END;
        END LOOP;


   DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );





EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;
END;
/
EXIT;
