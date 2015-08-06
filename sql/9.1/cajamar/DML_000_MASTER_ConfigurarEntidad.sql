--/*
--##########################################
--## AUTOR=Gonzalo E.
--## FECHA_CREACION=20150805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=-
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

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';    -- [PARAMETRO] Configuracion Esquemas
    
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
    PAR_AUTHOR VARCHAR2(20 CHAR)        := 'Gonzalo Estelles';                            -- [PARAMETRO] Nick del autor
    PAR_AUTHOR_EMAIL VARCHAR2(50 CHAR)  := 'gonzalo.estelles@pfsgroup.es';   -- [PARAMETRO] Email del autor
    PAR_AUTHOR_TELF VARCHAR2(10 CHAR)   := '2034';                              -- [PARAMETRO] Teléfono del autor    
    
BEGIN	

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');

    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''jdbc/cmmaster_Oracle9iDialect'' where datakey=''jndiName'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable jndiName de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable jndiName correctamente configurada.......');      

    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''jdbc:oracle:thin:cm01/admin@//localhost:1526/ibd016'' where datakey=''url'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable url de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable url correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''cm01'' where datakey=''username'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable username de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable username correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''admin'' where datakey=''password'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable password de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable password correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''cm01'' where datakey=''schema'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Configurando la variable schema de la tabla HAYAMASTER.ENTIDADCONFIG.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Variable schema correctamente configurada.......');
    
    V_MSQL := 'update '||PAR_ESQUEMA_MASTER||'.entidadconfig set datavalue=''cm01/admin@//localhost:1526/ibd016'' where datakey=''connectionInfo'' ';
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