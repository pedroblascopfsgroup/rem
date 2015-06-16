--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=FASE-1363
--## PRODUCTO=SI
--## Finalidad: DML de migración para insertar los valores de los diccionarios de población y provincia en la tabla
--## 			BIE_DATOS_REGISTRALES haciendo MATCH con el contenido del campo BIE_DREG_MUNICIPIO_LIBRO, y teniendo en cuenta
--##			que el municipio no esté repetido en 2 provincias diferentes.
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


DBMS_OUTPUT.PUT_LINE('[INICIO]');

EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES DREG
  USING   
      (SELECT TMP.BIE_DREG_ID, DDLOC.DD_LOC_ID NUEVALOC, DDPRV.DD_PRV_ID NUEVAPROV
      FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC
      INNER JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDLOC.DD_PRV_ID = DDPRV.DD_PRV_ID
      JOIN
         (SELECT DREG.BIE_DREG_ID, DREG.BIE_DREG_MUNICIPIO_LIBRO MUNICIPIO
           FROM '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES DREG
           WHERE BIE_DREG_MUNICIPIO_LIBRO IS NOT NULL AND DREG.DD_LOC_ID IS NULL ) TMP ON UPPER (TMP.MUNICIPIO) = UPPER (DDLOC.DD_LOC_DESCRIPCION)
           AND UPPER (DDLOC.DD_LOC_DESCRIPCION) NOT IN (SELECT DISTINCT UPPER(DD_LOC_DESCRIPCION) FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD GROUP BY UPPER(DD_LOC_DESCRIPCION) HAVING COUNT(*) > 1)
      ) POB ON (DREG.BIE_DREG_ID = POB.BIE_DREG_ID) 
  WHEN MATCHED THEN
      UPDATE SET DREG.DD_LOC_ID = POB.NUEVALOC, DREG.DD_PRV_ID = POB.NUEVAPROV, usuariomodificar = ''FASE-1363'', fechamodificar = SYSDATE';

	DBMS_OUTPUT.PUT_LINE('[NUMERO DE REGISTROS MIGRADOS]: ' || sql%rowcount);   
      

         

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');



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

