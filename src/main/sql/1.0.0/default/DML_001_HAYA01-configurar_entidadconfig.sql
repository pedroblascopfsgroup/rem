/*
--######################################################################
--## Author: Roberto
--## Finalidad: Configurar la tabla ENTIDADCONFIG de HAYAMASTER
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';    -- [PARAMETRO] Configuracion Esquemas
    
    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar    
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.
    VAR_CURR_ROWARRAY VARCHAR2(25 CHAR);                -- Variable con fila array actual - para excepciones
    VAR_CURR_TABLE VARCHAR2(50 CHAR);                   -- Variable con tabla actual - para excepciones    
    
    /*
    * CONFIGURACION: IDENTIDAD SCRIPT
    *---------------------------------------------------------------------
    */
	PAR_TIT_TRAMITE VARCHAR2(50 CHAR)   := 'Altas de Perfiles para Haya';   -- [PARAMETRO] Título del trámite    
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Roberto';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'roberto.lavalle@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2035';                              -- [PARAMETRO] Teléfono del autor    
    
BEGIN	

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');

    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''jdbc/haya01_Oracle9iDialect'' where datakey=''jndiName'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable jndiName de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable jndiName correctamente configurada.......');      

    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''jdbc:oracle:thin:haya01/admin@//localhost:1521/intehaya'' where datakey=''url'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable url de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable url correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''haya01'' where datakey=''username'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable username de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable username correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''admin'' where datakey=''password'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable password de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable password correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''haya01'' where datakey=''schema'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable schema de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable schema correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''haya01/admin@//localhost:1521/intehaya'' where datakey=''connectionInfo'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable connectionInfo de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable connectionInfo correctamente configurada.......');    
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''/opt/app/oracle/product/11.2.0/dbhome_1/bin/sqlldr'' where datakey=''pathToSqlLoader'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable pathToSqlLoader de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable pathToSqlLoader correctamente configurada.......');    
    
    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */

EXCEPTION

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                   TRATAMIENTO DE EXCEPCIONES
    *---------------------------------------------------------------------------------------------------------
    */
    WHEN OTHERS THEN
        /*
        * EXCEPTION: WHATEVER ERROR
        *---------------------------------------------------------------------
        */     
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[KO]');
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          IF (ERR_NUM = -1427 OR ERR_NUM = -1) THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los registros de este script insertados en la tabla '||VAR_CURR_TABLE
                              ||'. Encontrada fila num '||VAR_CURR_ROWARRAY||' de su array.');
            DBMS_OUTPUT.PUT_LINE('[INFO] Ejecute el script de limpieza del tramite '||PAR_TIT_TRAMITE||' y vuelva a ejecutar.');
          END IF;
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE('SQL que ha fallado:');
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ROLLBACK ALL].............................................');
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE('Contacto incidencia.....: '||PAR_AUTHOR);
          DBMS_OUTPUT.PUT_LINE('Email...................: '||PAR_AUTHOR_EMAIL);
          DBMS_OUTPUT.PUT_LINE('Telf....................: '||PAR_AUTHOR_TELF);
          DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');                    
          RAISE;   
END;
/

EXIT;