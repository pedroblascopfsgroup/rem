REM INSERTING into MOA_MODELOS_ARQ
SET DEFINE OFF;
Insert into MOA_MODELOS_ARQ (MOA_ID,MOA_NOMBRE,MOA_DESCRIPCION,DD_ESM_ID,MOA_OBSERVACIONES,MOA_FECHA_INI_VIGENCIA,MOA_FECHA_FIN_VIGENCIA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('21','Seg y Vencidos','Prueba 2 Seg y Vencidos','1',null,null,null,'1','CAJAMAR',to_timestamp('05/10/15 18:35:41,908000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('05/10/15 18:35:53,433000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into MOA_MODELOS_ARQ (MOA_ID,MOA_NOMBRE,MOA_DESCRIPCION,DD_ESM_ID,MOA_OBSERVACIONES,MOA_FECHA_INI_VIGENCIA,MOA_FECHA_FIN_VIGENCIA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('1','Modelo 1','Modelo para pruebas 28/09/2015','3',null,to_timestamp('29/09/15 17:39:01,913000000','DD/MM/RR HH24:MI:SSXFF'),null,'5','CAJAMAR',to_timestamp('28/09/15 19:15:04,842000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('29/09/15 17:39:01,929000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');


REM INSERTING into ITI_ITINERARIOS
SET DEFINE OFF;
Insert into ITI_ITINERARIOS (ITI_ID,ITI_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TIT_ID,DD_AEX_ID,TPL_ID) values ('148','Persona física Hipotecario_copia','2','CAJAMAR',to_timestamp('05/10/15 18:36:44,397000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('05/10/15 18:37:51,296000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0','2','7',null);
Insert into ITI_ITINERARIOS (ITI_ID,ITI_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TIT_ID,DD_AEX_ID,TPL_ID) values ('128','Persona física Hipotecario','2','CAJAMAR',to_timestamp('28/09/15 18:17:54,005000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:19:03,826000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0','1','3',null);
Insert into ITI_ITINERARIOS (ITI_ID,ITI_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TIT_ID,DD_AEX_ID,TPL_ID) values ('102','Generico','1','DD',to_timestamp('22/09/15 18:02:25,000000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0','1','1',null);


REM INSERTING into RULE_DEFINITION
SET DEFINE OFF;
Insert into RULE_DEFINITION (RD_ID,RD_NAME,RD_DEFINITION,RD_NAME_LONG,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('308','10 o mas dias en irregular','	<rule values="[1000]" ruleid="132" operator="greaterThan" title="Deuda irregular de la persona (1 valor) mayor que 1000">Deuda irregular de la persona (1 valor) mayor que 1000	</rule> ',null,'CAJAMAR',to_timestamp('29/09/15 18:25:33,635000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into RULE_DEFINITION (RD_ID,RD_NAME,RD_DEFINITION,RD_NAME_LONG,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('307','Genérico','	<rule title="bloque 0" type="or">		<rule style="" values="[101]" ruleid="3" operator="equal" title="Tipo Persona FISICA">Tipo Persona FISICA		</rule>		<rule style="" values="[102]" ruleid="3" operator="equal" title="Tipo Persona JURIDICA">Tipo Persona JURIDICA		</rule>	</rule> ','Todos los clientes aprovisionados','CAJAMAR',to_timestamp('28/09/15 19:25:59,367000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into RULE_DEFINITION (RD_ID,RD_NAME,RD_DEFINITION,RD_NAME_LONG,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('306','Persona física Hipotecario','	<rule title="bloque 0" type="and">				<rule values="[101]" ruleid="3" operator="equal" title="Tipo Persona FISICA">Tipo Persona FISICA								</rule>				<rule values="[13]" ruleid="137" operator="greaterThan" title="Dias irregular del Contrato mayor que 13">Dias irregular del Contrato mayor que 13				</rule>				<rule values="[27]" ruleid="137" operator="lessThan" title="Dias irregular del Contrato menor que 27">Dias irregular del Contrato menor que 27		</rule>		</rule>','Personas físicas con contrato hipotecario y más de 600 euros de deuda irregular','CAJAMAR',to_timestamp('29/09/15 18:39:57,593000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into RULE_DEFINITION (RD_ID,RD_NAME,RD_DEFINITION,RD_NAME_LONG,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('305','Prueba 1','	<rule values="[12,16]" ruleid="201" operator="between" title="Dias irreguar del Contrato (2 Valores) Entre 12 y entre 16">Dias irreguar del Contrato (2 Valores) Entre 12 y entre 16	</rule> ',null,'CAJAMAR',to_timestamp('28/09/15 19:12:18,282000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'CAJAMAR',to_timestamp('28/09/15 19:13:03,291000000','DD/MM/RR HH24:MI:SSXFF'),'1');


REM INSERTING into LIA_LISTA_ARQUETIPOS
SET DEFINE OFF;
Insert into LIA_LISTA_ARQUETIPOS (LIA_ID,ITI_ID,LIA_PRIORIDAD,LIA_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,LIA_NIVEL,LIA_GESTION,LIA_PLAZO_DISPARO,DD_TSN_ID,RD_ID) values ('1',null,null,'Persona física Hipotecario','0','CAJAMAR',to_date('28/09/15','DD/MM/RR'),null,null,null,null,'0','0','1','1','1','306');
Insert into LIA_LISTA_ARQUETIPOS (LIA_ID,ITI_ID,LIA_PRIORIDAD,LIA_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,LIA_NIVEL,LIA_GESTION,LIA_PLAZO_DISPARO,DD_TSN_ID,RD_ID) values ('2',null,null,'Resto','0','CAJAMAR',to_date('28/09/15','DD/MM/RR'),null,null,null,null,'0','0','0',null,null,'307');


REM INSERTING into MRA_REL_MODELO_ARQ
SET DEFINE OFF;
Insert into MRA_REL_MODELO_ARQ (MRA_ID,MOA_ID,LIA_ID,MRA_NIVEL,ITI_ID,MRA_PRIORIDAD,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,MRA_PLAZO_DISPARO) values ('21','21','2','0',null,'1','0','CAJAMAR',to_timestamp('05/10/15 18:35:53,398000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0',null);
Insert into MRA_REL_MODELO_ARQ (MRA_ID,MOA_ID,LIA_ID,MRA_NIVEL,ITI_ID,MRA_PRIORIDAD,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,MRA_PLAZO_DISPARO) values ('22','21','1','0',null,'2','0','CAJAMAR',to_timestamp('05/10/15 18:35:53,426000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0','1');
Insert into MRA_REL_MODELO_ARQ (MRA_ID,MOA_ID,LIA_ID,MRA_NIVEL,ITI_ID,MRA_PRIORIDAD,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,MRA_PLAZO_DISPARO) values ('1','1','1','0','128','1','1','CAJAMAR',to_timestamp('28/09/15 19:17:26,757000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 19:17:39,479000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0','1');
Insert into MRA_REL_MODELO_ARQ (MRA_ID,MOA_ID,LIA_ID,MRA_NIVEL,ITI_ID,MRA_PRIORIDAD,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,MRA_PLAZO_DISPARO) values ('2','1','2','0','102','2','0','CAJAMAR',to_timestamp('28/09/15 19:26:41,859000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0',null);


REM INSERTING into ARQ_ARQUETIPOS
SET DEFINE OFF;
Insert into ARQ_ARQUETIPOS (ARQ_ID,ITI_ID,ARQ_PRIORIDAD,ARQ_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,ARQ_NIVEL,ARQ_GESTION,ARQ_PLAZO_DISPARO,DD_TSN_ID,RD_ID,MRA_ID,DTYPE) values ('202','128','1','Persona física Hipotecario','0','CAJAMAR',to_timestamp('29/09/15 17:39:01,942000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0','0','1','1','1','306','1','ARQArquetipo');
Insert into ARQ_ARQUETIPOS (ARQ_ID,ITI_ID,ARQ_PRIORIDAD,ARQ_NOMBRE,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,ARQ_NIVEL,ARQ_GESTION,ARQ_PLAZO_DISPARO,DD_TSN_ID,RD_ID,MRA_ID,DTYPE) values ('203','102','2','Resto','0','CAJAMAR',to_timestamp('29/09/15 17:39:01,967000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0','0','0',null,null,'307','2','ARQArquetipo');


REM INSERTING into EST_ESTADOS
SET DEFINE OFF;
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('403',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),null,null,'148','1','0','864000000',null,'0','CAJAMAR',to_timestamp('05/10/15 18:36:44,424000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('404',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),null,null,'148','2','0','1296000000',null,'0','CAJAMAR',to_timestamp('05/10/15 18:36:44,438000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('405',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'GES_RIESGOS'),null,null,'148','3','0','864000000',null,'0','CAJAMAR',to_timestamp('05/10/15 18:36:44,439000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('406',(select PEF_ID from pef_perfiles where pef_codigo = 'GES_RIESGOS'),(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),null,null,'148','4','0','864000000',null,'0','CAJAMAR',to_timestamp('05/10/15 18:36:44,439000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('407',(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),null,null,'148','5','0','6480000000',null,'0','CAJAMAR',to_timestamp('05/10/15 18:36:44,440000000','DD/MM/RR HH24:MI:SSXFF'),null,null,null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('315',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),null,null,'128','1','0','864000000',null,'1','CAJAMAR',to_timestamp('28/09/15 18:17:54,058000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:23:59,890000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('316',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),null,null,'128','2','0','1296000000',null,'1','CAJAMAR',to_timestamp('28/09/15 18:17:54,059000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:23:59,891000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('317',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'GES_RIESGOS'),null,null,'128','3','0','864000000','1','2','CAJAMAR',to_timestamp('28/09/15 18:17:54,060000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('14/10/15 18:04:51,516000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('318',(select PEF_ID from pef_perfiles where pef_codigo = 'GES_RIESGOS'),(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),null,null,'128','4','0','864000000','0','3','CAJAMAR',to_timestamp('28/09/15 18:17:54,060000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('14/10/15 20:05:27,329000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('319',(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),null,null,'128','5','0','6480000000',null,'1','CAJAMAR',to_timestamp('28/09/15 18:17:54,061000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:23:59,896000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('310',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),null,null,'102','1','0','86400000','0','2','DD',to_timestamp('22/09/15 18:25:46,000000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:06:43,095000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('311',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),null,null,'102','2','0','86400000','0','2','DD',to_timestamp('22/09/15 18:25:47,000000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:06:43,097000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('312',(select PEF_ID from pef_perfiles where pef_codigo = 'OFI_OFICINA'),(select PEF_ID from pef_perfiles where pef_codigo = 'GES_RIESGOS'),null,null,'102','3','0','1296000000','0','2','DD',to_timestamp('22/09/15 18:25:48,000000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:06:43,099000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('313',(select PEF_ID from pef_perfiles where pef_codigo = 'GES_RIESGOS'),(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),null,null,'102','4','0','1296000000','0','2','DD',to_timestamp('22/09/15 18:25:50,000000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:06:43,101000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');
Insert into EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values ('314',(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),(select PEF_ID from pef_perfiles where pef_codigo = 'DIR_RIESGOS'),null,null,'102','5','0','1296000000','0','2','DD',to_timestamp('22/09/15 18:25:51,000000000','DD/MM/RR HH24:MI:SSXFF'),'CAJAMAR',to_timestamp('28/09/15 18:06:43,103000000','DD/MM/RR HH24:MI:SSXFF'),null,null,'0');

/*Incluimos los titulares*/
update dd_tin_tipo_intervencion set dd_tin_titular = 1 where dd_tin_codigo = '01' or dd_tin_codigo = '02';

/*Cambiamos el signo a la deuda irregular ya que actualmente viene en negativo*/
update mov_movimientos set MOV_DEUDA_IRREGULAR = MOV_DEUDA_IRREGULAR * -1;


COMMIT;