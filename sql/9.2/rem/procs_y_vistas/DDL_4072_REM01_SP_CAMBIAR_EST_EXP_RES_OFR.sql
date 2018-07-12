--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20180712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1076
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_CAMBIAR_EST_EXP_RES_OFR
        (  
		  V_NUM_EXPEDIENTE IN NUMBER
        , V_ESTADO_EXPEDIENTE IN VARCHAR2
        , V_ESTADO_OFERTA IN VARCHAR2
        , V_ESTADO_RESERVA IN VARCHAR2 
		, V_USUARIO_MODIFICAR IN VARCHAR2
        , PL_OUTPUT OUT VARCHAR2
    )

   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_NUM_TABLAS NUMBER(16); -- Variable auxiliar
   USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
   V_AUX NUMBER(16);

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
        --Comprobamos que la tansición a realizar es posible.
					
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TRANS_EST_EXP_OFR_RES TRA
						WHERE DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '||V_ESTADO_EXPEDIENTE||')
						  AND DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '||V_ESTADO_OFERTA||')
						  AND DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '||V_ESTADO_RESERVA||')';	
		
		EXECUTE IMMEDIATE V_SQL INTO V_AUX;
		
		IF V_AUX = 1 THEN
					
			-- Actualizar estado expediente
			
			V_SQL := 'UPDATE ECO_EXPEDIENTE_COMERCIAL ECO 
						SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||V_ESTADO_EXPEDIENTE||''')
						   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
						   ,FECHAMODIFICAR = SYSDATE
						WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';
			
			EXECUTE IMMEDIATE V_SQL;
			
			PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado del EXPEDIENTE '||V_NUM_EXPEDIENTE|| CHR(10) ;
			
			-- Actualizar estado oferta
			
			V_SQL := 'UPDATE OFR_OFERTAS OFR 
						SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = '''||V_ESTADO_OFERTA||''')
						   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
						   ,FECHAMODIFICAR = SYSDATE
						WHERE OFR.OFR_ID = (
									SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
										INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
										WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
											)';
			                    
			EXECUTE IMMEDIATE V_SQL;
			
			PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la OFERTA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;
			
			-- Actualizar estado reserva
			
			V_SQL := 'UPDATE RES_RESERVAS RES 
						SET RES.DD_ERE_ID = (SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = '''||V_ESTADO_RESERVA||''')
						   ,USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||'''
						   ,FECHAMODIFICAR = SYSDATE
						WHERE RES.RES_ID = (SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
												INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.RES_ID AND ECO.BORRADO = 0
												WHERE RES.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'
											)';
			
			EXECUTE IMMEDIATE V_SQL;
			
			PL_OUTPUT := PL_OUTPUT ||'[INFO] Se ha actualizado el estado de la RESERVA relacionada con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;
			
		ELSE
       
			PL_OUTPUT := PL_OUTPUT ||'[ERROR] La Transición no ha sido posible porque no existe el registro en la tabla TRANS_EST_EXP_OFR_RES';
        
		END IF;
           
    COMMIT;
    
    PL_OUTPUT := PL_OUTPUT ||'[FIN] Se han actualizado los registros relacionados con el expediente '||V_NUM_EXPEDIENTE|| CHR(10) ;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_CAMBIAR_EST_EXP_RES_OFR;
/
EXIT
