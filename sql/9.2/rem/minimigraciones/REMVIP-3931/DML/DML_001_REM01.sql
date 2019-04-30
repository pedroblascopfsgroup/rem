--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190430
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3931
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-3931';
    V_MSQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;

	CURSOR CERTIFICADOS IS SELECT distinct 
										act.act_id
									,   AUX.ACTIVO 
									,   AUX.REM_FC_ALTA
									,   AUX.FECHA_CADUCIDAD 
									,   AUX.CALIFICACION
									,	TPA.dd_tpa_codigo
									FROM REM01.AUX_REMVIP_3931 AUX
									inner join REM01.ACT_ACTIVO act on aux.activo = ACT.ACT_NUM_ACTIVO 
									left join REM01.ACT_ADO_ADMISION_DOCUMENTO ado on ACT.ACT_ID = ADO.ACT_ID
									left join REM01.ACT_CFD_CONFIG_DOCUMENTO cfd on cfd.cfd_id = ado.cfd_id
									left join REM01.DD_TPA_TIPO_ACTIVO tpa on tpa.dd_tpa_id = act.dd_tpa_id
									left join REM01.DD_TPD_TIPO_DOCUMENTO tpd on cfd.dd_tpd_id = TPD.DD_TPD_ID;
									
	FILA CERTIFICADOS%ROWTYPE;

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 
	
	
	OPEN CERTIFICADOS;

	LOOP
  		FETCH CERTIFICADOS INTO FILA;
  		EXIT WHEN CERTIFICADOS%NOTFOUND;

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO (		
                                ADO_ID
							, 	ACT_ID
							, 	CFD_ID
							, 	DD_EDC_ID
							, 	ADO_APLICA
							,	ADO_NUM_DOC
							, 	ADO_FECHA_VERIFICADO
							, 	ADO_FECHA_SOLICITUD
							, 	ADO_FECHA_EMISION
							, 	ADO_FECHA_OBTENCION
							, 	ADO_FECHA_CADUCIDAD
							, 	ADO_FECHA_ETIQUETA
							, 	ADO_FECHA_CALIFICACION
							, 	DD_TCE_ID
							, 	VERSION
							, 	USUARIOCREAR
							, 	FECHACREAR 
							, 	BORRADO
							, 	ADO_REF_DOC)
					VALUES (
						'||V_ESQUEMA||'.S_ACT_ADO_ADMISION_DOCUMENTO.NEXTVAL
					,   '||FILA.ACT_ID||'
					,   CASE 
						WHEN '''||FILA.dd_tpa_codigo||''' = ''02'' THEN (select cfd.cfd_id 
															from ACT_CFD_CONFIG_DOCUMENTO cfd
															inner join DD_TPD_TIPO_DOCUMENTO tpd on tpd.dd_tpd_id = cfd.dd_tpd_id and tpd.dd_tpd_codigo = ''92''
															inner join DD_TPA_TIPO_ACTIVO tpa on cfd.dd_tpa_id = tpa.dd_tpa_id and tpa.dd_tpa_codigo = ''02'')
						WHEN '''||FILA.dd_tpa_codigo||''' = ''03'' THEN (select cfd.cfd_id 
															from ACT_CFD_CONFIG_DOCUMENTO cfd
															inner join DD_TPD_TIPO_DOCUMENTO tpd on tpd.dd_tpd_id = cfd.dd_tpd_id and tpd.dd_tpd_codigo = ''92''
															inner join DD_TPA_TIPO_ACTIVO tpa on cfd.dd_tpa_id = tpa.dd_tpa_id and tpa.dd_tpa_codigo = ''03'')
						WHEN '''||FILA.dd_tpa_codigo||''' = ''05'' THEN (select cfd.cfd_id 
															from ACT_CFD_CONFIG_DOCUMENTO cfd
															inner join DD_TPD_TIPO_DOCUMENTO tpd on tpd.dd_tpd_id = cfd.dd_tpd_id and tpd.dd_tpd_codigo = ''92''
															inner join DD_TPA_TIPO_ACTIVO tpa on cfd.dd_tpa_id = tpa.dd_tpa_id and tpa.dd_tpa_codigo = ''05'')
						END
					,   1
					,   1
					,   NULL
					,   NULL
					,   NULL
					,   TO_DATE(TRIM('''||FILA.REM_FC_ALTA||'''),''MM/DD/YYYY'')
					,   NULL
					,   TO_DATE(TRIM('''||FILA.FECHA_CADUCIDAD||'''),''MM/DD/YYYY'')
					,   TO_DATE(TRIM('''||FILA.REM_FC_ALTA||'''),''MM/DD/YYYY'')
					,   TO_DATE(TRIM('''||FILA.REM_FC_ALTA||'''),''MM/DD/YYYY'')
					,   (SELECT DD_TCE_ID FROM DD_TCE_TIPO_CALIF_ENERGETICA WHERE DD_TCE_CODIGO = TRIM('''||FILA.CALIFICACION||'''))
					,   0   
					,   '''||V_USUARIOMODIFICAR||'''
					,   SYSDATE
					,   0
					,   NULL )';
		
        -- DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
			
		V_COUNT := V_COUNT + 1 ;
        V_COUNT2 := V_COUNT2 +1 ;
        
        IF V_COUNT2 = 100 THEN
            
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('	[INFO] Se comitean '||V_COUNT2||' registros ');
            V_COUNT2 := 0;
            
        END IF;
  		
	END LOOP;
	
    DBMS_OUTPUT.PUT_LINE('	[INFO] Se comitean '||V_COUNT2||' registros ');
    
	CLOSE CERTIFICADOS;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');

	

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
