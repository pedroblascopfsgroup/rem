--/*
--##########################################
--## AUTOR=María V.
--## FECHA_CREACION=20160623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=RECOVERY-2159
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade campo puntuación a las tablas de persona
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema ESQUEMA_DWH
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN 

 DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIR CAMPO PUNTUACION A LAS TABLAS DE PERSONA ');

 -------------- H_PER ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''PUNTUACION'' and table_name=''H_PER'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla H_PER ya tiene el campo PUNTUACION.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.H_PER ADD PUNTUACION NUMBER(38,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO PUNTUACION A H_PER');

 -------------- H_PER_SEMANA ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''PUNTUACION'' and table_name=''H_PER_SEMANA'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla H_PER_SEMANA ya tiene el campo PUNTUACION.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.H_PER_SEMANA ADD PUNTUACION NUMBER(38,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO PUNTUACION A H_PER_SEMANA');



     -------------- H_PER_MES ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''PUNTUACION'' and table_name=''H_PER_MES'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla H_PER_MES ya tiene el campo PUNTUACION.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.H_PER_MES ADD PUNTUACION NUMBER(38,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO PUNTUACION A H_PER_MES');


   -------------- H_PER_TRIMESTRE ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''PUNTUACION'' and table_name=''H_PER_TRIMESTRE'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla H_PER_TRIMESTRE ya tiene el campo PUNTUACION.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.H_PER_TRIMESTRE ADD PUNTUACION NUMBER(38,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO PUNTUACION A H_PER_TRIMESTRE');


   -------------- H_PER_ANIO ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''PUNTUACION'' and table_name=''H_PER_ANIO'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla H_PER_ANIO ya tiene el campo PUNTUACION.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.H_PER_ANIO ADD PUNTUACION NUMBER(38,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO PUNTUACION A H_PER_ANIO');

     -------------- TMP_H_PER ---------------------------------------------

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''PUNTUACION'' and table_name=''TMP_H_PER'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_H_PER ya tiene el campo PUNTUACION.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.TMP_H_PER ADD PUNTUACION NUMBER(38,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO PUNTUACION A TMP_H_PER');


  DBMS_OUTPUT.PUT_LINE('[FIN] AÑADIR CAMPO PUNTUACION A LAS TABLAS DE PERSONA ');

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