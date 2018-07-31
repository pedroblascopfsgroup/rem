--/*
--#########################################
--## AUTOR=Marco y Sergio
--## FECHA_CREACION=20180615
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4220
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPV_GASTOS_PROVEEDORES -> GPV_GASTOS_PROVEEDOR
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

    TYPE T_TABLAS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;   
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER       
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_PVE_PROVEEDOR';
	V_COUNT NUMBER(10,0) := 0;
    V_MSQL VARCHAR2(32000 CHAR);

BEGIN

	DBMS_OUTPUT.PUT_LINE('Comienza el insert en ACT_PVE_PROVEEDOR');
	
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME =''AUX_ACT_PVE'' AND OWNER='''||V_ESQUEMA||''''
	INTO V_COUNT;
	
	IF V_COUNT > 0 THEN
	
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			PVE_ID,
			PVE_COD_REM,
            USUARIOCREAR,
            FECHACREAR,
			PVE_COD_UVEM,
			DD_TPR_ID, 
			PVE_NOMBRE,
			PVE_NOMBRE_COMERCIAL,
			DD_TDI_ID,
			PVE_DOCIDENTIF,
			DD_ZNG_ID,
			DD_PRV_ID,
			DD_LOC_ID,
			PVE_CP,
			PVE_DIRECCION,
			PVE_TELF1,
			PVE_TELF2,
			PVE_FAX,
			PVE_EMAIL,
			PVE_PAGINA_WEB,
			PVE_FRANQUICIA,
			PVE_IVA_CAJA,
			PVE_NUM_CUENTA,
			DD_TPC_ID,
			DD_TPE_ID,
			PVE_NIF,
			PVE_FECHA_ALTA,
			PVE_FECHA_BAJA,
			PVE_LOCALIZADA,
			DD_EPR_ID,
			PVE_FECHA_CONSTITUCION,
			PVE_AMBITO,
			PVE_OBSERVACIONES,
			PVE_HOMOLOGADO,
			DD_CPR_ID,
			PVE_TOP,
			PVE_TITULAR_CUENTA,
			PVE_RETENER,
			DD_MRE_ID,
			PVE_FECHA_RETENCION,
			PVE_FECHA_PBC,
			DD_RPB_ID,
			PVE_COD_API_PROVEEDOR,
			PVE_AUTORIZACION_WEB
		)
			SELECT 
				 '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL,
				 '||V_ESQUEMA||'.S_PVE_COD_REM.NEXTVAL,
                 ''HREOS-4220'',
                 SYSDATE,
				 AUX.*
			FROM (
			SELECT 
				 PVE_COD_UVEM                                                                                                       
				,(SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR WHERE TPR.DD_TPR_CODIGO = AUXILIAR.DD_TPR_CODIGO)                 
				,PVE_NOMBRE                                                                                                         
				,PVE_NOMBRE_COMERCIAL                                                                                               
				,(SELECT TDI.DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI WHERE TDI.DD_TDI_CODIGO = AUXILIAR.DD_TDI_CODIGO)          
				,PVE_DOCIDENTIF		                                                                                                
				,(SELECT ZNG.DD_ZNG_ID FROM '||V_ESQUEMA||'.DD_ZNG_ZONA_GEOGRAFICA ZNG WHERE ZNG.DD_ZNG_CODIGO = AUXILIAR.DD_ZNG_CODIGO)	    
				,(SELECT PRV.DD_PRV_ID FROM '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV WHERE PRV.DD_PRV_CODIGO = AUXILIAR.DD_PRV_CODIGO)        
				,(SELECT LOC.DD_LOC_ID FROM '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC WHERE LOC.DD_LOC_CODIGO = AUXILIAR.DD_LOC_CODIGO)        
				,PVE_CP				                                                                                                
				,PVE_DIRECCION		                                                                                                
				,PVE_TELF1			                                                                                                
				,PVE_TELF2			                                                                                                
				,PVE_FAX				                                                                                            
				,PVE_EMAIL			                                                                                                
				,PVE_PAGINA_WEB		                                                                                                
				,PVE_FRANQUICIA		                                                                                                
				,PVE_IVA_CAJA		                                                                                                
				,PVE_NUM_CUENTA		                                                                                                
				,(SELECT TPC.DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPOS_COLABORADOR TPC WHERE TPC.DD_TPC_CODIGO = AUXILIAR.DD_TPC_CODIGO)    
				,(SELECT TPE.DD_TPE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TPE_TIPO_PERSONA TPE WHERE TPE.DD_TPE_CODIGO = AUXILIAR.DD_TPE_CODIGO)     
				,PVE_NIF				                                                                                            
				,SYSDATE	                                                                                                
				,PVE_FECHA_BAJA		                                                                                                
				,PVE_LOCALIZADA		                                                                                                
				,(SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.DD_EPR_CODIGO = ''04'')     
				,PVE_FECHA_CONSTITUCION                                                                                             
				,PVE_AMBITO			                                                                                                
				,PVE_OBSERVACIONES	                                                                                                
				,PVE_HOMOLOGADO		                                                                                                
				,(SELECT CPR.DD_CPR_ID FROM '||V_ESQUEMA||'.DD_CPR_CALIFICACION_PROVEEDOR CPR WHERE CPR.DD_CPR_CODIGO = AUXILIAR.DD_CPR_CODIGO)   
				,PVE_TOP				                                                                                                
				,PVE_TITULAR_CUENTA	                                                                                                    
				,PVE_RETENER			                                                                                                
				,(SELECT MRE.DD_MRE_ID FROM '||V_ESQUEMA||'.DD_MRE_MOTIVO_RETENCION MRE WHERE MRE.DD_MRE_CODIGO = AUXILIAR.DD_MRE_CODIGO)         
				,PVE_FECHA_RETENCION	                                                                                                
				,PVE_FECHA_PBC		                                                                                                    
				,(SELECT RPB.DD_RPB_ID FROM '||V_ESQUEMA||'.DD_RPB_RES_PROCESO_BLANQUEO RPB WHERE RPB.DD_RPB_CODIGO = AUXILIAR.DD_RPB_CODIGO)     
				,PVE_COD_API_PROVEEDOR																								
				,PVE_AUTORIZACION_WEB																								
			FROM '||V_ESQUEMA||'.AUX_ACT_PVE AUXILIAR
			) AUX';
		END IF;

		EXECUTE IMMEDIATE V_MSQL;
		 DBMS_OUTPUT.PUT_LINE(V_MSQL);
		 DBMS_OUTPUT.PUT_LINE('Insertadas '||SQL%ROWCOUNT);

		COMMIT;
        --rollback;

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
