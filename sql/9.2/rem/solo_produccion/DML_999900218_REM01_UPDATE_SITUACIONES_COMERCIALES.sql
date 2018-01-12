--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20180108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3523
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica las situaciones comercialoes de los activos con las condiciones dadas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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

    TABLA_ACTIVO VARCHAR2(30 CHAR) := 'ACT_ACTIVO';
    TABLA_OFERTAS VARCHAR2(30 CHAR) := 'OFR_OFERTAS';
    TABLA_ECO VARCHAR2(30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
    TABLA_RESERVAS VARCHAR2(30 CHAR) := 'RES_RESERVAS';
    
    ID_ACTIVO NUMBER;
    ACTUALIZAR NUMBER;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT USING (
        SELECT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO
          FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
         WHERE ACT.BORRADO = 0 AND ACT.DD_SCM_ID = (SELECT DD_SCM_ID
                                            FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL
                                           WHERE DD_SCM_CODIGO = ''04'')
        MINUS
        SELECT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO
          FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR ON ACTOFR.ACT_ID = ACT.ACT_ID
               INNER JOIN '||V_ESQUEMA||'.'||TABLA_OFERTAS||' OFR ON OFR.OFR_ID = ACTOFR.OFR_ID AND OFR.BORRADO = 0
               INNER JOIN '||V_ESQUEMA||'.'||TABLA_ECO||' ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
               INNER JOIN '||V_ESQUEMA||'.'||TABLA_RESERVAS||' RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0
         WHERE RES.DD_ERE_ID = (SELECT DD_ERE_ID
                                  FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA
                                 WHERE DD_ERE_CODIGO = ''02'')  
           AND ACT.BORRADO = 0
           AND ECO.DD_EEC_ID <> (SELECT DD_EEC_ID
                                   FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL
                                  WHERE DD_EEC_CODIGO = ''02'') 
		) REG
	ON (ACT.ACT_ID = REG.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	ACT.DD_SCM_ID = NULL,
	ACT.FECHAMODIFICAR = SYSDATE,
	ACT.USUARIOMODIFICAR = ''HREOS-3523'''
	;

	DBMS_OUTPUT.PUT_LINE('[FIN]: '||SQL%ROWCOUNT||' registros mergeados');

	COMMIT;
    
   	DBMS_OUTPUT.PUT_LINE('[INICIO]: SP INICIADO');

    	ID_ACTIVO := 0;
   	ACTUALIZAR := 1;
    
  	REM01.SP_ASC_ACT_SIT_COM_VACIOS ( ID_ACTIVO, ACTUALIZAR );
    
  	DBMS_OUTPUT.PUT_LINE('[FIN]: SP FINALIZADO');
  

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

EXIT;
