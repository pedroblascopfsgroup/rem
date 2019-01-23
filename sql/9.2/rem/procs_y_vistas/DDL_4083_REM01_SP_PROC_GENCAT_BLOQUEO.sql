﻿--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20190121
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5183
--## PRODUCTO=no
--## Finalidad: Creación SP
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 [HREOS-5183] Se han cambiado los literales
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE PROC_GENCAT_BLOQUEO(SP_OUTPUT OUT VARCHAR2) AS
--v0.2
    DIFERENCIA_DIAS NUMBER (16,0);
    
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.	
    V_COUNT NUMBER;
    NUM_OFERTA NUMBER(16,0);
    NUM_ACTIVO NUMBER(16,0);
    V_USUARIO VARCHAR2 (200 CHAR):= 'HREOS-5183';

    V_TABLA_MAIL    VARCHAR2 (30 CHAR) := 'EMAIL_OFERTAS_BLOQ';
    V_TABLA VARCHAR2 (30 CHAR):= 'GENCAT_BLOQ_TMP';
    V_FROM 			VARCHAR2(100 CHAR) := 'noreply.rem@pfsgroup.es';
    V_TO 			VARCHAR2(100 CHAR) := 'jpoyatos@haya.es';
    V_BODY 			VARCHAR2(1000 CHAR) := 'Se ha bloqueado la oferta del activo YYYYYYY para su comunicación a GENCAT debido a un exceso de días de formalización.' || chr(10);
    V_ASUNTO 		VARCHAR2(250 CHAR) := 'Bloqueo de la oferta del activo YYYYYYY para su comunicación a GENCAT por exceso de días de formalización.';
    V_ADJUNTO 		VARCHAR2(250 CHAR) := 'ofertas_bloqueadas.xlsx';

BEGIN

DBMS_OUTPUT.PUT_LINE(' [INICIO] COMPROBACION DE Proceso bloqueo – revisión plazos ');


DBMS_OUTPUT.PUT_LINE(' TRUNCATE de las tablas auxiliares ');

 --TRUNCATE TABLA MAIL
	    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_MAIL||''' AND OWNER = '''||V_ESQUEMA||'''';
	    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	    IF V_COUNT = 1 THEN
	     
		#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE',''||V_TABLA_MAIL||'');
		SP_OUTPUT := SP_OUTPUT || ' [INFO] Tabla '||V_TABLA_MAIL||' truncate'||CHR(10);
	    
	  END IF;

	   V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
	    IF V_COUNT = 1 THEN

		#ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE',''||V_TABLA||'');
		SP_OUTPUT := SP_OUTPUT || ' [INFO] Tabla '||V_TABLA||' truncate'||CHR(10);

	  END IF;

--Se comprueba los activos que estan sancionados y tienen una oferta sin firmar 


 V_MSQL := '
	INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA ||' (
			ECO_ID, 	   
			CMG_ID,
			ACT_ID, 	 		 
			OFR_ID, 	 		 
			V_BODY,
			CC_MAIL 
	) 
	SELECT
	ECO_ID				ECO_ID,
	CMG_ID				CMG_ID,
	ACT_ID		 		ACT_ID,
	OFR_ID				OFR_ID,
	'''|| V_BODY ||''' 		V_BODY,
	CC_MAIL				CC_MAIL

					
		  FROM (WITH MAIL_GESTOR_FORMALIZACION AS (
		  SELECT DISTINCT USU_MAIL, GAC_GESTOR_ADD_ACTIVO.ACT_ID
		  FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU_USUARIOS, '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR DD_TGE_TIPO_GESTOR, 
		'|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO, '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD
		  WHERE 
		   GAC_GESTOR_ADD_ACTIVO.GEE_ID = GEE_GESTOR_ENTIDAD.GEE_ID
		  AND GEE_GESTOR_ENTIDAD.DD_TGE_ID = DD_TGE_TIPO_GESTOR.DD_TGE_ID
		  AND REMMASTER.DD_TGE_TIPO_GESTOR.DD_TGE_CODIGO = ''GFORM''
		  AND GEE_GESTOR_ENTIDAD.USU_ID = USU_USUARIOS.USU_ID AND USU_USUARIOS.BORRADO = 0
		),
		MAIL_GESTORIA_FORMALIZACION AS (
		SELECT USU_MAIL, GAC_GESTOR_ADD_ACTIVO.ACT_ID
		  FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU_USUARIOS, '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR DD_TGE_TIPO_GESTOR,
		 '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO, '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD
		  WHERE GAC_GESTOR_ADD_ACTIVO.GEE_ID = GEE_GESTOR_ENTIDAD.GEE_ID
		  AND GEE_GESTOR_ENTIDAD.DD_TGE_ID = DD_TGE_TIPO_GESTOR.DD_TGE_ID
		  AND DD_TGE_TIPO_GESTOR.DD_TGE_CODIGO = ''GIAFORM''
		  AND GEE_GESTOR_ENTIDAD.USU_ID = USU_USUARIOS.USU_ID AND USU_USUARIOS.BORRADO = 0
		 )   
			  
		SELECT DISTINCT ACT.ACT_ID AS ACT_ID,
		OFR.OFR_ID AS OFR_ID,
		NVL(LISTAGG (MG.USU_MAIL, '';'') WITHIN GROUP (ORDER BY MG.USU_MAIL),'''') ||'';''||
		LISTAGG (MGI.USU_MAIL, ''; '') WITHIN GROUP (ORDER BY MGI.USU_MAIL) CC_MAIL,
		CMG.CMG_ID AS CMG_ID,
		ECO.ECO_ID AS ECO_ID

		FROM '|| V_ESQUEMA ||'.ACT_CMG_COMUNICACION_GENCAT CMG 
				JOIN '|| V_ESQUEMA ||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
			JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID=CMG.ACT_ID AND  ACT.BORRADO = 0
				JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFG.OFR_ID = ECO.OFR_ID
			JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID=ECO.OFR_ID AND OFR.BORRADO = 0
			LEFT JOIN MAIL_GESTOR_FORMALIZACION MG ON MG.ACT_ID = ACT.ACT_ID
			LEFT JOIN MAIL_GESTORIA_FORMALIZACION MGI ON MGI.ACT_ID = ACT.ACT_ID
		WHERE CMG.DD_ECG_ID = (SELECT DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_COM_GENCAT ECG WHERE ECG.DD_ECG_CODIGO = ''SANCIONADO'') 
						AND ECO.DD_EEC_ID <> (SELECT DD_EEC_ID FROM '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL ECC WHERE ECC.DD_EEC_CODIGO=''03'' )
						AND (ECO.ECO_BLOQUEADO IS NULL OR ECO.ECO_BLOQUEADO = 0) AND TRUNC(SYSDATE-CMG.CMG_FECHA_SANCION) > 60
		 GROUP BY  
			OFR.OFR_ID,
			ACT.ACT_ID,
			ECO.ECO_ID,
			CMG.CMG_ID)';

      
      	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] OFERTAS PARA BLOQUEAR '||sql%rowcount||'');
	SP_OUTPUT := SP_OUTPUT || ' [INFO] OFERTAS PARA BLOQUEAR : '||sql%rowcount||''|| CHR(10);
	

	V_MSQL:= '
		UPDATE '|| V_ESQUEMA ||'.GENCAT_BLOQ_TMP 
		SET 
		CC_MAIL = (SELECT LISTAGG(CC_MAIL,'';'') WITHIN GROUP (ORDER BY CC_MAIL) CC_MAIL FROM  '|| V_ESQUEMA ||'.GENCAT_BLOQ_TMP)';
	
	EXECUTE IMMEDIATE V_MSQL;


    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
	   USING (
	   	SELECT DISTINCT TMP.ECO_ID FROM '|| V_ESQUEMA ||'.GENCAT_BLOQ_TMP TMP 
		    ) AUX
	   ON (AUX.ECO_ID=ECO.ECO_ID)
	   WHEN MATCHED THEN 
	   UPDATE 
	     SET 
	     USUARIOMODIFICAR='''|| V_USUARIO ||'''
	    ,FECHAMODIFICAR=SYSDATE
        ,ECO_BLOQUEADO=1';
        
      	EXECUTE IMMEDIATE V_MSQL;
        
        
        DBMS_OUTPUT.PUT_LINE('[INFO] OFERTAS BLOQUEADAS '||sql%rowcount||' ECO_EXPEDIENTE_COMERCIAL ');

 	IF  sql%rowcount > 0 THEN

		   DBMS_OUTPUT.PUT_LINE('[INFO] Se crea el contenido del EMAIL');
	    
		  V_MSQL := '
			INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA_MAIL ||' (
			DESDE_MAIL,  
			PARA_MAIL,  
			BODY_MAIL, 
			CC_MAIL, 
			ASUNTO_MAIL,
			ADJUNTO_MAIL 
				) 
				SELECT
				'''||V_FROM||'''		DESDE_MAIL,
				'''||V_TO||'''			PARA_MAIL,
				TMP.V_BODY 			BODY_MAIL,
				TMP.CC_MAIL			CC_MAIL,
				'''||V_ASUNTO||'''		ASUNTO_MAIL,
				'''|| V_ADJUNTO ||''' 		ADJUNTO_MAIL


					
					FROM '|| V_ESQUEMA ||'.'|| V_TABLA ||' TMP WHERE ROWNUM=1';

		EXECUTE IMMEDIATE V_MSQL;
		SP_OUTPUT := SP_OUTPUT || ' [INFO] Tabla '||V_TABLA_MAIL||' INSERCCION DE DATOS'|| CHR(10);
        
	END IF;
	
	COMMIT;	

	DBMS_OUTPUT.PUT_LINE(' [FIN] SP REVISION DE PLAZOS');

    
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END PROC_GENCAT_BLOQUEO;

/

EXIT
