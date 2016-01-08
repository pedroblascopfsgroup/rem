--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150804
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-464
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TEMPORAL PERSONAS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DROP TABLE  "CM01"."TMP_PER_PERSONAS" ;

  CREATE TABLE "CM01"."TMP_PER_PERSONAS" 
   (	
    "TMP_PER_ID" NUMBER(16,0) NOT NULL ENABLE, 																										
	"TMP_PER_FECHA_EXTRACCION" DATE NOT NULL ENABLE,                                                                               
	"TMP_PER_FECHA_DATO" DATE NOT NULL ENABLE,                                                                                     
	"TMP_PER_COD_PROPIETARIO" NUMBER(5,0) NOT NULL ENABLE,                                                                         
	"TMP_PER_COD_ENTIDAD" NUMBER(4,0) NOT NULL ENABLE,                                                                             
	"TMP_PER_COD_PERSONA" NUMBER(16,0) NOT NULL ENABLE,                                                                            
	"TMP_PER_TIPO_PERSONA" NUMBER(1,0) NOT NULL ENABLE,                                                                            
	"TMP_PER_TIPO_DOCUMENTO" VARCHAR2(20 CHAR) ,                                                                                   
	"TMP_PER_NIF_CIF_PASAP_NIE" VARCHAR2(20 CHAR),                                                                                 
	"TMP_PER_NOMBRE" VARCHAR2(100 CHAR) NOT NULL ENABLE,                                                                           
	"TMP_PER_NOM50" VARCHAR2(300 CHAR) NOT NULL ENABLE,                                                                            
	"TMP_PER_APELLIDO1" VARCHAR2(100 CHAR),                                                                                        
	"TMP_PER_APELLIDO2" VARCHAR2(100 CHAR),                                                                                        
	"TMP_PER_COD_ESTADO_CICLO_VIDA" VARCHAR2(50 CHAR),                                                                             
	"TMP_PER_FECHA_INICIO_ECV" DATE,                                                                                               
	"TMP_PER_TELEFONO1" VARCHAR2(20 CHAR),                                                                                         
	"TMP_PER_ORIGEN_TELEFONO1" VARCHAR2(6 CHAR),                                                                                   
	"TMP_PER_CONSENT_TELEFONO1" VARCHAR2(1 CHAR),                                                                                  
	"TMP_PER_FECHA_EXP_VIGEN_TEL1" DATE,                                                                                           
	"TMP_PER_TIPO_TELEFONO1" VARCHAR2(5 CHAR),                                                                                     
	"TMP_PER_CORREO_ELECTRONICO" VARCHAR2(100 CHAR),                                                                               
	"TMP_PER_NACIONALIDAD" VARCHAR2(3 CHAR),                                                                                       
	"TMP_PER_PAIS_NACIMIENTO" VARCHAR2(3 CHAR),                                                                                    
	"TMP_PER_FECHA_CONSTITUCION" DATE,                                                                                             
	"TMP_PER_FECHA_NACIMIENTO" DATE,                                                                                               
	"TMP_PER_SEXO" VARCHAR2(1 CHAR),                                                                                               
	"TMP_PER_SEGMENTO_CLIENTE_1" VARCHAR2(10 CHAR) ,                                                                               
	"TMP_PER_SEGMENTO_CLIENTE_2" VARCHAR2(10 CHAR),                                                                                
	"TMP_PER_POLITICA_ENTIDAD" VARCHAR2(10 CHAR),                                                                                  
	"TMP_PER_RATING_REFERENCIA" VARCHAR2(10 CHAR),                                                                                 
	"TMP_PER_RATING_FECHA" DATE ,                                                                                                  
	"TMP_PER_SCORING" VARCHAR(10 CHAR),                                                                                            
	"TMP_PER_NIVEL" VARCHAR2(1 CHAR) ,                                                                                             
	"TMP_PER_RIESGO_AUTORIZADO" NUMBER(15,2) NOT NULL ENABLE,                                                                      
	"TMP_PER_RIESGO_DISPUESTO" NUMBER(15,2) NOT NULL ENABLE,                                                                       
	"TMP_PER_RIESGO_INDIRECTO" NUMBER(15,2) NOT NULL ENABLE,                                                                       
	"TMP_PER_PASIVO_VISTA" NUMBER(15,2) NOT NULL ENABLE,                                                                           
	"TMP_PER_PASIVO_PLAZO" NUMBER(15,2) NOT NULL ENABLE,                                                                           
	"TMP_PER_EMPLEADO" VARCHAR2(1 CHAR) NOT NULL ENABLE,                                                                           
	"TMP_PER_COLECTIVO_SINGULAR" VARCHAR2(4 CHAR),                                                                                 
	"TMP_PER_INGRESOS_DOMICILIADOS" VARCHAR2(1 CHAR),                                                                              
	"TMP_PER_SERV_NOMINA_PENSION" VARCHAR2(1 CHAR) NOT NULL ENABLE,                                                                
	"TMP_PER_VR_OTRAS_ENTIDADES" NUMBER(15,2),                                                                                     
	"TMP_PER_VR_DANYADO_OTRAS_ENTS" NUMBER(15,2),                                                                                  
	"TMP_PER_VOLUMEN_FACTURACION" NUMBER(15,2),                                                                                    
	"TMP_PER_VOLUMEN_FACTURAC_FECHA" DATE,                                                                                          
	"TMP_PER_NUMERO_EMPLEADOS" NUMBER(6,0),                                                                                        
	"TMP_PER_COD_ENT_OFI_GESTORA" NUMBER(5,0),                                                                                     
	"TMP_PER_COD_OFICINA_GESTORA" NUMBER(5,0),                                                                                     
	"TMP_PER_COD_SUBSEC_OFI_GESTORA" NUMBER(2,0),                                                                                   
	"TMP_PER_COD_CENTRO_GESTOR" VARCHAR2(20 CHAR),                                                                                 
	"TMP_PER_TIPO_GESTOR" VARCHAR2(4 CHAR),                                                                                        
	"TMP_PER_PERFIL_GESTOR" NUMBER(16,0),                                                                                          
	"TMP_PER_USUARIO_GESTOR" VARCHAR2(50 CHAR),                                                                                    
	"TMP_PER_COD_GRUPO_GESTOR" VARCHAR2(50 CHAR),                                                                                  
	"TMP_PER_COD_AREA" VARCHAR2(10 CHAR),                                                                                          
	"TMP_PER_ULTIMA_ACTUACION" VARCHAR2(1024 CHAR),                                                                                
	"TMP_PER_SITUACION_CONCURSAL" VARCHAR2(1 CHAR),                                                                                
	"TMP_PER_CHAR_EXTRA1" VARCHAR2(50 CHAR),                                                                                            
	"TMP_PER_CHAR_EXTRA2" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA3" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA4" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA5" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA6" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA7" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA8" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA9" VARCHAR2(50 CHAR),                                                                                       
	"TMP_PER_CHAR_EXTRA10" VARCHAR2(50 CHAR),                                                                                      
	"TMP_PER_FLAG_EXTRA1" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA2" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA3" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA4" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA5" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA6" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA7" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA8" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA9" VARCHAR2(1 CHAR),                                                                                        
	"TMP_PER_FLAG_EXTRA10" VARCHAR2(1 CHAR),                                                                                       
	"TMP_PER_DATE_EXTRA1" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA2" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA3" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA4" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA5" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA6" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA7" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA8" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA9" DATE,                                                                                                    
	"TMP_PER_DATE_EXTRA10" DATE,                                                                                                   
	"TMP_NUM_EXTRA1" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA2" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA3" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA4" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA5" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA6" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA7" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA8" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA9" NUMBER(15,2),                                                                                                 
	"TMP_NUM_EXTRA10" NUMBER(15,2),                                                                                                
	"TMP_NUM_EXTRA11" NUMBER(15,2),                                                                                                
	"TMP_NUM_EXTRA12" NUMBER(15,2),                                                                                                
	"TMP_PER_FECHA_CREACION" DATE,                                                                                                 
	"TMP_PER_FECHA_CARGA" DATE DEFAULT SYSDATE NOT NULL ENABLE,                                                                    
	"TMP_PER_FICHERO_CARGA" VARCHAR2(50 CHAR),                                                                                     
	 CONSTRAINT "PK_TMP_PER_PERSONAS" PRIMARY KEY ("TMP_PER_ID")                                                                   
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                                                                
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 NOCOMPRESS NOLOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;
 

  CREATE UNIQUE INDEX "CM01"."UK_TMP_PER_PERSONAS" ON "CM01"."TMP_PER_PERSONAS" ("TMP_PER_COD_PERSONA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DRECOVERYONL8M" ;

EXIT;
 
