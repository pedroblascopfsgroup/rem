--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ
--## FECHA_CREACION=20150610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=FASE-1376	
--## PRODUCTO=SI
--## Finalidad: MIGRAR LOS DATOS DE LA COLUMNA DD_TVI_ID DE LA TABLA BIE_LOCALIZACIÓN 
--## A LOS NUEVOS REGISTROS DEL DICCIONARIO DD_TVI_TIPO_VIA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]: ');

-- Update de BIE_LOCALIZACION
DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos  las referencias de BIE_LOCALIZACION');

execute immediate 'UPDATE '||V_ESQUEMA||'.BIE_LOCALIZACION
SET DD_TVI_ID = ( SELECT tvia.DD_TVI_ID FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvia WHERE tvia.DD_TVI_CODIGO = ''CL'' )
, USUARIOMODIFICAR = ''FASE-1376''
, FECHAMODIFICAR = SYSDATE
WHERE DD_TVI_ID IN ( 
    SELECT tvi.DD_TVI_ID 
    FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvi 
    WHERE tvi.DD_TVI_CODIGO NOT IN (''AV'',''BD'',''CA'',''CJ'',''CL'',''CN'',''CO'',''CT'',''CU'',''CV'',''ET'',''GL'',''LU'',''PA'',''PB'',''PG'',''PJ'',''PL'',''PR'',''RA'',''RO'',''TV'',''UB''))';

DBMS_OUTPUT.PUT_LINE('[INFO]: Actualización realizada correctamente');

-- Update de DIJ_DIRECCION_JUZGADO
DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos  las referencias de DIJ_DIRECCION_JUZGADO');

execute immediate 'UPDATE '||V_ESQUEMA||'.DIJ_DIRECCION_JUZGADO
SET DD_TVI_ID = ( SELECT tvia.DD_TVI_ID FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvia WHERE tvia.DD_TVI_CODIGO = ''CL'' )
, USUARIOMODIFICAR = ''FASE-1376''
, FECHAMODIFICAR = SYSDATE
WHERE DD_TVI_ID IN ( 
    SELECT tvi.DD_TVI_ID 
    FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvi 
    WHERE tvi.DD_TVI_CODIGO NOT IN (''AV'',''BD'',''CA'',''CJ'',''CL'',''CN'',''CO'',''CT'',''CU'',''CV'',''ET'',''GL'',''LU'',''PA'',''PB'',''PG'',''PJ'',''PL'',''PR'',''RA'',''RO'',''TV'',''UB''))';

DBMS_OUTPUT.PUT_LINE('[INFO]: Actualización realizada correctamente');

-- Update de DIR_DIRECCIONES
DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos  las referencias de DIR_DIRECCIONES');

execute immediate 'UPDATE '||V_ESQUEMA||'.DIR_DIRECCIONES
SET DD_TVI_ID = ( SELECT tvia.DD_TVI_ID FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvia WHERE tvia.DD_TVI_CODIGO = ''CL'' )
, USUARIOMODIFICAR = ''FASE-1376''
, FECHAMODIFICAR = SYSDATE
WHERE DD_TVI_ID IN ( 
    SELECT tvi.DD_TVI_ID 
    FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvi 
    WHERE tvi.DD_TVI_CODIGO NOT IN (''AV'',''BD'',''CA'',''CJ'',''CL'',''CN'',''CO'',''CT'',''CU'',''CV'',''ET'',''GL'',''LU'',''PA'',''PB'',''PG'',''PJ'',''PL'',''PR'',''RA'',''RO'',''TV'',''UB''))';

DBMS_OUTPUT.PUT_LINE('[INFO]: Actualización realizada correctamente');

-- Update de RCF_AGE_AGENCIAS
DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos  las referencias de RCF_AGE_AGENCIAS');

execute immediate 'UPDATE '||V_ESQUEMA||'.RCF_AGE_AGENCIAS
SET DD_TVI_ID = ( SELECT tvia.DD_TVI_ID FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvia WHERE tvia.DD_TVI_CODIGO = ''CL'' )
, USUARIOMODIFICAR = ''FASE-1376''
, FECHAMODIFICAR = SYSDATE
WHERE DD_TVI_ID IN ( 
    SELECT tvi.DD_TVI_ID 
    FROM '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA tvi 
    WHERE tvi.DD_TVI_CODIGO NOT IN (''AV'',''BD'',''CA'',''CJ'',''CL'',''CN'',''CO'',''CT'',''CU'',''CV'',''ET'',''GL'',''LU'',''PA'',''PB'',''PG'',''PJ'',''PL'',''PR'',''RA'',''RO'',''TV'',''UB''))';

DBMS_OUTPUT.PUT_LINE('[INFO]: Actualización realizada correctamente');
    
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT