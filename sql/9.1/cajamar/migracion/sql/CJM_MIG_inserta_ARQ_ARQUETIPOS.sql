--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Se inserta ARQUETIPO específico para migración
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial (Sergio Alarcon)
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   'CM01'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; 		-- Configuracion Esquema Master
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM CM01.ARQ_ARQUETIPOS
  WHERE ARQ_NOMBRE = 'Migracion';

 
  IF V_EXISTE = 0 THEN   

 --MOA_MODELOS_ARQ
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MOA_MODELOS_ARQ (MOA_ID,MOA_NOMBRE,MOA_DESCRIPCION,DD_ESM_ID,MOA_OBSERVACIONES,MOA_FECHA_INI_VIGENCIA,MOA_FECHA_FIN_VIGENCIA,USUARIOCREAR,FECHACREAR) VALUES (CM01.S_MOA_MODELOS_ARQ.nextval,''Modelo Migracion'',''Modelo Migracion'',(SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO  WHERE DD_ESM_DESCRIPCION = ''HISTÓRICO''),null,sysdate,null,''PFS-CONF'', sysdate )';          
     EXECUTE IMMEDIATE V_MSQL;

--ITI_ITINERARIOS
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ITI_ITINERARIOS (ITI_ID,ITI_NOMBRE,USUARIOCREAR,FECHACREAR,DD_TIT_ID,DD_AEX_ID,TPL_ID) VALUES ( '||V_ESQUEMA||'.S_ITI_ITINERARIOS.nextval,''Migracion'',''PFS-CONF'',sysdate,(SELECT DD_TIT_ID FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''REC''),(select DD_AEX_ID from '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE where DD_AEX_CODIGO = ''CP''),(select TPL_ID from '||V_ESQUEMA||'.TPL_TIPO_POLITICA where TPL_CODIGO = ''TPL02''))';
     EXECUTE IMMEDIATE V_MSQL;

--RULE_DEFINITION
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.RULE_DEFINITION (RD_ID,RD_NAME,RD_DEFINITION,RD_NAME_LONG,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_RULE_DEFINITION.nextval, ''Migracion'',''<rule title="bloque 0" type="or">  <rule style="" values="[101]" ruleid="3" operator="equal" title="Tipo Persona FISICA">Tipo Persona FISICA  </rule>  <rule style="" values="[102]" ruleid="3" operator="equal" title="Tipo Persona JURIDICA">Tipo Persona JURIDICA  </rule> </rule>'',''Todos los clientes aprovisionados'',''PFS-CONF'',sysdate,null,null,null,null,0)';
     EXECUTE IMMEDIATE V_MSQL;

--LIA_LISTA_ARQUETIPOS
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS (LIA_ID,ITI_ID,LIA_PRIORIDAD,LIA_NOMBRE,USUARIOCREAR,FECHACREAR,LIA_NIVEL,LIA_GESTION,LIA_PLAZO_DISPARO,DD_TSN_ID,RD_ID) VALUES ('||V_ESQUEMA||'.S_LIA_LISTA_ARQUETIPOS.nextval,null,null,''GR. Migracion'',''PFS-CONF'',sysdate,0,1,90,(SELECT DD_TSN_ID  FROM '||V_ESQUEMA_M||'.DD_TSN_TIPO_SALTO_NIVEL  WHERE DD_TSN_CODIGO = ''TODOS''),(SELECT RD_ID  FROM '||V_ESQUEMA||'.RULE_DEFINITION  WHERE RD_NAME =''Migracion''))';
     EXECUTE IMMEDIATE V_MSQL;
     
--MRA_REL_MODELO_ARQ
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ (MRA_ID,MOA_ID,LIA_ID,MRA_NIVEL,ITI_ID,MRA_PRIORIDAD,USUARIOCREAR, FECHACREAR,MRA_PLAZO_DISPARO) VALUES ('||V_ESQUEMA||'.S_MRA_REL_MODELO_ARQ.nextval,(SELECT MOA_ID FROM '||V_ESQUEMA||'.MOA_MODELOS_ARQ WHERE MOA_NOMBRE = ''Modelo Migracion'') ,(SELECT LIA_ID FROM '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS WHERE LIA_NOMBRE = ''GR. Migracion''),0,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), 1,''PFS-CONF'',sysdate,90)';
     EXECUTE IMMEDIATE V_MSQL;
     
--ARQ_ARQUETIPOS
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ARQ_ARQUETIPOS (ARQ_ID,ITI_ID,ARQ_PRIORIDAD,ARQ_NOMBRE,USUARIOCREAR,FECHACREAR,BORRADO,ARQ_NIVEL,ARQ_GESTION,ARQ_PLAZO_DISPARO,DD_TSN_ID,RD_ID,MRA_ID,DTYPE) VALUES ( '||V_ESQUEMA||'.S_ARQ_ARQUETIPOS.nextval,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''),1,''Migracion'',''PFS-CONF'',sysdate,1,0,1,90,(SELECT DD_TSN_ID FROM '||V_ESQUEMA_M||'.DD_TSN_TIPO_SALTO_NIVEL WHERE DD_TSN_CODIGO = ''TODOS''),(SELECT RD_ID FROM '||V_ESQUEMA||'.RULE_DEFINITION WHERE RD_NAME = ''Migracion''), (select MRA_ID from MRA_REL_MODELO_ARQ where LIA_ID = (select LIA_ID from LIA_LISTA_ARQUETIPOS where LIA_NOMBRE =  ''Migracion'' )),''ARQArquetipo'')';
     EXECUTE IMMEDIATE V_MSQL;
     
--EST_ESTADOS
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CAR''),0,5184000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''GV''),0,864000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CE''),0,864000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''RE''),0,432000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''DC''),0,604800000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''FP''),0,1296000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Arquetipo específico para migración creado.');     
  ELSE   
     DBMS_OUTPUT.PUT_LINE('Ya existe al arquetipo específico para migración');
  END IF;   
          
--Fin inserta arquetipos
 COMMIT;

--Actualizamos estados en caso de que no se hubieran creado


  V_MSQL := 'select COUNT(*) 
             FROM EST_ESTADOS 
             where NVL(PEF_ID_GESTOR,0) =NVL((SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),0)
              AND NVL(PEF_ID_SUPERVISOR,0) =NVL((SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),0)
              AND TEL_ID is null
              and DCA_ID is null
              AND ITI_ID = (SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion'')
              AND DD_EST_ID =(SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CAR'')
              AND EST_TELECOBRO =0
              AND EST_PLAZO =5184000000
              AND EST_AUTOMATICO IS null
              AND USUARIOCREAR = ''PFS-CONF''' ;   
              
       EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;            
              
  
  IF V_EXISTE = 0 THEN       
--EST_ESTADOS
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CAR''),0,5184000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''GV''),0,864000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CE''),0,864000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''RE''),0,432000000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''DC''),0,604800000,null,''PFS-CONF'',sysdate)';
     EXECUTE IMMEDIATE V_MSQL;
 -- V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Migracion''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''FP''),0,1296000000,null,''PFS-CONF'',sysdate)';
 --    EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Registros pendientes de la EST_ESTADOS para el arquetipo de migración insertados.');     
  ELSE   
     DBMS_OUTPUT.PUT_LINE('La EST_ESTADOS no tiene información pendiente de arquetipo para migración');
  END IF;    
 
 
 COMMIT;
 
--Excepciones

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





