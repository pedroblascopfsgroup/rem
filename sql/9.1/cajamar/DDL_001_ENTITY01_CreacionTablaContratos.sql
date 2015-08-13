--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150807
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-453
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TEMPORAL CONTRATOS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := 'CM01';
 TABLA VARCHAR(30) :='TMP_CNT_CONTRATOS';
 ITABLE_SPACE VARCHAR(25) :='IRECOVERYONL8M';
 TABLE_SPACE VARCHAR(25)  :='DRECOVERYONL8M';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);


BEGIN 

EXECUTE IMMEDIATE('DROP TABLE '||TABLA||'  ');
DBMS_OUTPUT.PUT_LINE(''||TABLA||' BORRADA');

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	"TMP_CNT_ID" NUMBER(16,0) NOT NULL ENABLE,                                                                                                                              
	"TMP_CNT_FECHA_EXTRACCION" DATE NOT NULL ENABLE,                                                                                                                            
	"TMP_CNT_FECHA_DATO" DATE NOT NULL ENABLE,                                                                                                                                  
	"TMP_CNT_APLICATIVO_ORIGEN" VARCHAR2(10 CHAR) NOT NULL ENABLE,                                                                                                              
	"TMP_CNT_COD_ENTIDAD" NUMBER(4,0) NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_CODIGO_PROPIETARIO" NUMBER(5,0) NOT NULL ENABLE,                                                                                                                   
	"TMP_CNT_TIPO_PRODUCTO" VARCHAR2(5 CHAR) NOT NULL ENABLE,                                                                                                                   
	"TMP_CNT_CONTRATO" NUMBER(17,0) NOT NULL ENABLE,                                                                                                                            
	"TMP_CNT_NUM_ESPEC" NUMBER(15,0) NOT NULL ENABLE,                                                                                                                           
	"TMP_CNT_IBAN_CNT" VARCHAR2(24 CHAR),                                                                                                                                       
	"TMP_CNT_MONEDA" NUMBER(4,0) NOT NULL ENABLE,                                                                                                                               
	"TMP_CNT_POS_VIVA_NO_VENCIDA" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                 
	"TMP_CNT_POS_VIVA_VENCIDA" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                    
	"TMP_CNT_DEUDA_IRREGULAR" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                     
	"TMP_CNT_INT_REMUNERATORIOS" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                  
	"TMP_CNT_INT_MORATORIOS" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                      
	"TMP_CNT_COMISIONES" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_GASTOS" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                              
	"TMP_CNT_IMPUESTOS" NUMBER(15,2),                                                                                                                                           
	"TMP_CNT_ENTREGAS" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                            
	"TMP_CNT_INTERESES_ENTREGAS" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                  
	"TMP_CNT_CUOTA_IMPORTE" NUMBER(15,2),                                                                                                                                       
	"TMP_CNT_CUOTA_PERIODICIDAD" NUMBER(3,0),                                                                                                                                   
	"TMP_CNT_CUOTAS_VENCIDAS_IMP" NUMBER(3,0),                                                                                                                                  
	"TMP_CNT_DISPUESTO" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                           
	"TMP_CNT_PTE_DESEMBOLSO" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                      
	"TMP_CNT_SALDO_EXCE" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_LIMITE_INI" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_LIMITE_FIN" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_LIMITE_DESC" NUMBER(15,2),                                                                                                                                         
	"TMP_CNT_LTV_INI" NUMBER(5,2) NOT NULL ENABLE,                                                                                                                              
	"TMP_CNT_LTV_FIN" NUMBER(5,2) NOT NULL ENABLE,                                                                                                                              
	"TMP_CNT_SIST_AMORTIZACION" VARCHAR2(8 CHAR),                                                                                                                               
	"TMP_CNT_INTERES_FIJO_VBLE" VARCHAR2(1 CHAR),                                                                                                                               
	"TMP_CNT_TIPO_INTERES" NUMBER(7,5),                                                                                                                                         
	"TMP_CNT_SALDO_PASIVO" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                        
	"TMP_SALDO_PASIVO_OTROS"   NUMBER(15,2),  			                                                                                                                        
	"TMP_CNT_SALDO_DUDOSO" NUMBER(15,2),                                                                                                                                        
	"TMP_CNT_SALDO_MUY_DUDOSO" NUMBER(15,2),                                                                                                                                    
	"TMP_CNT_PROVISION" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                           
	"TMP_CNT_PORCEN_PROVISION" NUMBER(5,2) NOT NULL ENABLE,                                                                                                                     
	"TMP_CNT_RIESGO" NUMBER(15,2),                                                                                                                                              
	"TMP_CNT_RIESGO_GARANT" NUMBER(15,2) NOT NULL ENABLE,                                                                                                                       
	"TMP_CNT_FECHA_CONSTITUCION" DATE NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_FECHA_VENC" DATE,                                                                                                                                                  
	"TMP_CNT_FECHA_INI_EPI_IRREG" DATE,                                                                                                                                         
	"TMP_CNT_FECHA_POS_VENCIDA" DATE NOT NULL ENABLE,                                                                                                                           
	"TMP_CNT_FECHA_DUDOSO" DATE,                                                                                                                                                
	"TMP_CNT_ESTADO_FINANCIERO" VARCHAR2(4 CHAR) NOT NULL ENABLE,                                                                                                                    
	"TMP_CNT_ESTADO_FINANCIERO_ANT"  VARCHAR2(4 CHAR) NOT NULL ENABLE,                                                                                                                
	"TMP_CNT_FECHA_ESTADO_FINANC" DATE NOT NULL ENABLE,                                                                                                                         
	"TMP_ESTADO_CONTRATO" VARCHAR2(9 CHAR) NOT NULL ENABLE,                                                                                                                     
	"TMP_FECHA_ESTADO_CONTRATO" DATE NOT NULL ENABLE,                                                                                                                           
	"TMP_CNT_FINALIDAD_OFI" VARCHAR2(5 CHAR),                                                                                                                                   
	"TMP_CNT_FINALIDAD_CON" VARCHAR2(4 CHAR),                                                                                                                                   
	"TMP_CNT_SCORING" VARCHAR2(10 CHAR),                                                                                                                                        
	"TMP_CNT_GARANTIA_1" NUMBER(4,0),                                                                                                                                           
	"TMP_CNT_GARANTIA_2" NUMBER(4,0),                                                                                                                                           
	"TMP_CNT_CATALOGO_1" VARCHAR2(12 CHAR),                                                                                                                                     
	"TMP_CNT_CATALOGO_2" VARCHAR2(12 CHAR),                                                                                                                                     
	"TMP_CNT_CATALOGO_3" VARCHAR2(12 CHAR),                                                                                                                                     
	"TMP_CNT_CATALOGO_4" VARCHAR2(12 CHAR),                                                                                                                                     
	"TMP_CNT_CATALOGO_5" VARCHAR2(12 CHAR),                                                                                                                                     
	"TMP_CNT_CATALOGO_6" VARCHAR2(12 CHAR),                                                                                                                                     
	"TMP_CNT_DOMICILIACION" VARCHAR2(20 CHAR),                                                                                                                                  
	"TMP_CNT_COD_ENT_OFI_CNTBLE" NUMBER(5,0) NOT NULL ENABLE,                                                                                                                   
	"TMP_CNT_COD_OFI_CNTBLE" NUMBER(5,0) NOT NULL ENABLE,                                                                                                                       
	"TMP_CNT_COD_SUBSC_OFI_CNTBLE" NUMBER(2,0) NOT NULL ENABLE,                                                                                                                 
	"TMP_CNT_COD_ENTIDAD_OFI_ADM" NUMBER(5,0) NOT NULL ENABLE,                                                                                                                  
	"TMP_CNT_COD_OFICINA_ADM" NUMBER(5,0) NOT NULL ENABLE,                                                                                                                      
	"TMP_CNT_COD_SUBSEC_OFI_ADM" NUMBER(2,0) NOT NULL ENABLE,                                                                                                                   
	"TMP_CNT_COD_GESTION_ESPECIAL" VARCHAR2(4 CHAR),                                                                                                                            
	"TMP_CNT_REMU_GEST_ESPECIAL" VARCHAR2(4 CHAR) NOT NULL ENABLE,                                                                                                              
	"TMP_CNT_IND_DOMICI_EXTERNA" VARCHAR2(1 CHAR) NOT NULL ENABLE,                                                                                                              
	"TMP_CNT_FECHA_RECIBO_DEV_ANT" DATE,                                                                                                                                        
	"TMP_CNT_SALDO_VENC_NO_RECLAM" NUMBER(15,2),                                                                                                                                
	"TMP_CONTRATO_PADRE_NIVEL_1" NUMBER(22,0),                                                                                                                                  
	"TMP_CONTRATO_PADRE_NIVEL_2" NUMBER(22,0),                                                                                                                                  
	-- "TMP_CNT_CD_CONTRATO_PARAGUAS" NUMBER(22,0),                                                                                                                             
	"TMP_CNT_NUM_CNT_ANTERIOR" NUMBER(17,0),                                                                                                                                    
	"TMP_CNT_MOTIVO_RENUMERACION" VARCHAR2(20 CHAR),                                                                                                                            
	"TMP_CNT_LCHAR_EXTRA1" VARCHAR2(250 CHAR),                                                                                                                                  
	"TMP_CNT_CHAR_EXTRA1" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA2" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA3" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA4" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA5" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA6" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA7" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA8" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA9" VARCHAR2(50 CHAR),                                                                                                                                    
	"TMP_CNT_CHAR_EXTRA10" VARCHAR2(50 CHAR),                                                                                                                                   
	"TMP_CNT_CHAR_EXTRA11" VARCHAR2(50 CHAR), 			                                                                                                                        
	"TMP_CNT_CHAR_EXTRA12" VARCHAR2(50 CHAR), 			                                                                                                                        
	"TMP_CNT_CHAR_EXTRA13" VARCHAR2(50 CHAR),			                                                                                                                        
	"TMP_CNT_CHAR_EXTRA14" VARCHAR2(50 CHAR),			                                                                                                                        
	"TMP_CNT_CHAR_EXTRA15" VARCHAR2(50 CHAR),			                                                                                                                        
	"TMP_CNT_CHAR_EXTRA16" VARCHAR2(50 CHAR),			                                                                                                                        
	"TMP_CNT_FLAG_EXTRA1" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA2" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA3" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA4" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA5" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA6" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA7" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA8" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA9" VARCHAR2(1 CHAR),                                                                                                                                     
	"TMP_CNT_FLAG_EXTRA10" VARCHAR2(1 CHAR),                                                                                                                                    
	"TMP_CNT_FLAG_EXTRA11" VARCHAR2(1 CHAR),  			                                                                                                                        
	"TMP_CNT_FLAG_EXTRA12" VARCHAR2(1 CHAR),  			                                                                                                                        
	"TMP_CNT_FLAG_EXTRA13" VARCHAR2(1 CHAR),  			                                                                                                                        
	"TMP_CNT_DATE_EXTRA1" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA2" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA3" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA4" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA5" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA6" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA7" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA8" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA9" DATE,                                                                                                                                                 
	"TMP_CNT_DATE_EXTRA10" DATE,                                                                                                                                                
	"TMP_CNT_DATE_EXTRA11" DATE,  			                                                                                                                                    
	"TMP_CNT_DATE_EXTRA12" DATE,  			                                                                                                                                    
	"TMP_CNT_NUM_EXTRA1" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA2" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA3" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA4" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA5" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA6" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA7" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA8" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA9" NUMBER(15,2),                                                                                                                                          
	"TMP_CNT_NUM_EXTRA10" NUMBER(15,2),                                                                                                                                         
	"TMP_CNT_NUM_EXTRA11" NUMBER(15,2),   			                                                                                                                            
	"TMP_CNT_NUM_EXTRA12" NUMBER(15,2),   			                                                                                                                            
	"TMP_CNT_NUM_EXTRA13" NUMBER(15,2),   			                                                                                                                            
	"TMP_CNT_COD_OFICINA" NUMBER(12,0) NOT NULL ENABLE,                                                                                                                         
	"TMP_CNT_FECHA_CREA_CNT" DATE NOT NULL ENABLE,                                                                                                                              
	"TMP_CNT_FICHERO_CARGA" VARCHAR2(50 CHAR) NOT NULL ENABLE,                                                                                                                  
	"TMP_CNT_COD_OFI_OP" NUMBER(12,0) NOT NULL ENABLE,                                                                                                                          
	"TMP_CNT_FECHA_CARGA" DATE DEFAULT SYSDATE NOT NULL ENABLE,                                                                                                                 
	"TMP_CNT_CODIGO_CNT50" VARCHAR2(50 CHAR),                                                                                                                                   
	 CONSTRAINT "PK_TMP_CNT_CONTRATOS" PRIMARY KEY ("TMP_CNT_ID")                                                                                                           
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                                                                 
  TABLESPACE '||ITABLE_SPACE||'  ENABLE ,                                                                                                                                   
	 CONSTRAINT "UK_TMP_CNT_CONTRATOS" UNIQUE ("TMP_CNT_CODIGO_CNT50")                                                                                                      
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                                                             
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645                                                                                                         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
 TABLESPACE '||ITABLE_SPACE||'  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 NOCOMPRESS NOLOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
 TABLESPACE '||TABLE_SPACE||'' ;
     
	 EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;  
