--/*
--##########################################
--## AUTOR=SERGIO HERNANDEZ
--## FECHA_CREACION=20151222
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=HR-1499
--## INCIDENCIA_LINK=HR-1499
--## PRODUCTO=NO
--## Finalidad: DML
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

        V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.MOA_MODELOS_ARQ WHERE MOA_NOMBRE= ''Modelo Aprovisionamiento''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN      
                DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.MOA_MODELOS_ARQ ...no se modificará nada.');
        ELSE
        
--MOA_MODELOS_ARQ        
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MOA_MODELOS_ARQ (MOA_ID,MOA_NOMBRE,MOA_DESCRIPCION,DD_ESM_ID,MOA_OBSERVACIONES,MOA_FECHA_INI_VIGENCIA,MOA_FECHA_FIN_VIGENCIA,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_MOA_MODELOS_ARQ.nextval,''Modelo Aprovisionamiento'',''Modelo Aprovisionamiento'',(SELECT DD_ESM_ID FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO  WHERE DD_ESM_DESCRIPCION = ''HISTÓRICO''),null,sysdate,null,''PFS-CONF'', sysdate )';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.MOA_MODELOS_ARQ... Datos del diccionario insertado');

--ITI_ITINERARIOS

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ITI_ITINERARIOS (ITI_ID,ITI_NOMBRE,USUARIOCREAR,FECHACREAR,DD_TIT_ID,DD_AEX_ID,TPL_ID) VALUES ( '||V_ESQUEMA||'.S_ITI_ITINERARIOS.nextval,''Aprovisionamiento'',''PFS-CONF'',sysdate,(SELECT DD_TIT_ID FROM '||V_ESQUEMA_M||'.DD_TIT_TIPO_ITINERARIOS WHERE DD_TIT_CODIGO = ''REC''),(select DD_AEX_ID from '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE where DD_AEX_CODIGO = ''CP''),(select TPL_ID from '||V_ESQUEMA||'.TPL_TIPO_POLITICA where TPL_CODIGO = ''TPL02''))';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.ITI_ITINERARIOS... Datos del diccionario insertado');
        


--RULE_DEFINITION
        V_MSQL := 'select '||V_ESQUEMA||'.S_RULE_DEFINITION.nextval from dual';
        EXECUTE IMMEDIATE V_MSQL;
        EXECUTE IMMEDIATE V_MSQL;
        EXECUTE IMMEDIATE V_MSQL;
        EXECUTE IMMEDIATE V_MSQL;

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.RULE_DEFINITION (RD_ID,RD_NAME,RD_DEFINITION,RD_NAME_LONG,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_RULE_DEFINITION.nextval, ''Aprovisionamiento'',''<rule title="bloque 0" type="or">  <rule style="" values="[101]" ruleid="3" operator="equal" title="Tipo Persona FISICA">Tipo Persona FISICA  </rule>  <rule style="" values="[102]" ruleid="3" operator="equal" title="Tipo Persona JURIDICA">Tipo Persona JURIDICA  </rule> </rule>'',''Todos los clientes aprovisionados'',''PFS-CONF'',sysdate,null,null,null,null,0)';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.RULE_DEFINITION... Datos del diccionario insertado');
        



--LIA_LISTA_ARQUETIPOS

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS (LIA_ID,ITI_ID,LIA_PRIORIDAD,LIA_NOMBRE,USUARIOCREAR,FECHACREAR,LIA_NIVEL,LIA_GESTION,LIA_PLAZO_DISPARO,DD_TSN_ID,RD_ID) VALUES ('||V_ESQUEMA||'.S_LIA_LISTA_ARQUETIPOS.nextval,null,null,''GR. Aprovisionamiento'',''PFS-CONF'',sysdate,0,1,90,(SELECT DD_TSN_ID  FROM '||V_ESQUEMA_M||'.DD_TSN_TIPO_SALTO_NIVEL  WHERE DD_TSN_CODIGO = ''TODOS''),(SELECT RD_ID  FROM '||V_ESQUEMA||'.RULE_DEFINITION  WHERE RD_NAME =''Aprovisionamiento''))';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS... Datos del diccionario insertado');
        



--MRA_REL_MODELO_ARQ

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ (MRA_ID,MOA_ID,LIA_ID,MRA_NIVEL,ITI_ID,MRA_PRIORIDAD,USUARIOCREAR, FECHACREAR,MRA_PLAZO_DISPARO) VALUES ('||V_ESQUEMA||'.S_MRA_REL_MODELO_ARQ.nextval,(SELECT MOA_ID FROM '||V_ESQUEMA||'.MOA_MODELOS_ARQ WHERE MOA_NOMBRE = ''Modelo Aprovisionamiento'') ,(SELECT LIA_ID FROM '||V_ESQUEMA||'.LIA_LISTA_ARQUETIPOS WHERE LIA_NOMBRE = ''GR. Aprovisionamiento''),0,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), 1,''PFS-CONF'',sysdate,90)';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.MRA_REL_MODELO_ARQ... Datos del diccionario insertado');
        



--ARQ_ARQUETIPOS

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ARQ_ARQUETIPOS (ARQ_ID,ITI_ID,ARQ_PRIORIDAD,ARQ_NOMBRE,USUARIOCREAR,FECHACREAR,ARQ_NIVEL,ARQ_GESTION,ARQ_PLAZO_DISPARO,DD_TSN_ID,RD_ID,MRA_ID,DTYPE,BORRADO) VALUES ( '||V_ESQUEMA||'.S_ARQ_ARQUETIPOS.nextval,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''),1,''Aprovisionamiento'',''PFS-CONF'',sysdate,0,1,90,(SELECT DD_TSN_ID FROM '||V_ESQUEMA_M||'.DD_TSN_TIPO_SALTO_NIVEL WHERE DD_TSN_CODIGO = ''TODOS''),(SELECT RD_ID FROM '||V_ESQUEMA||'.RULE_DEFINITION WHERE RD_NAME = ''Aprovisionamiento''), (select MRA_ID from MRA_REL_MODELO_ARQ where LIA_ID = (select LIA_ID from LIA_LISTA_ARQUETIPOS where LIA_NOMBRE =  ''Aprovisionamiento'' )),''ARQArquetipo'',1)';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.ARQ_ARQUETIPOS... Datos del diccionario insertado');
        



--EST_ESTADOS

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CAR''),0,5184000000,null,''PFS-CONF'',sysdate)';

        EXECUTE IMMEDIATE V_MSQL;
        

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''GV''),0,864000000,null,''PFS-CONF'',sysdate)';

        EXECUTE IMMEDIATE V_MSQL;
        

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''CE''),0,864000000,null,''PFS-CONF'',sysdate)';

        EXECUTE IMMEDIATE V_MSQL;
        

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''RE''),0,432000000,null,''PFS-CONF'',sysdate)';

        EXECUTE IMMEDIATE V_MSQL;
        

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_TERRITORIAL_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''DC''),0,604800000,null,''PFS-CONF'',sysdate)';

        EXECUTE IMMEDIATE V_MSQL;
        

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EST_ESTADOS (EST_ID,PEF_ID_GESTOR,PEF_ID_SUPERVISOR,TEL_ID,DCA_ID,ITI_ID,DD_EST_ID,EST_TELECOBRO,EST_PLAZO,EST_AUTOMATICO,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_EST_ESTADOS.nextval,(SELECT PEF_ID FROM PEF_PERFILES WHERE PEF_CODIGO = ''SER_CENTRALES''),(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''DIR_RIESGOS''),null,null,(SELECT ITI_ID FROM '||V_ESQUEMA||'.ITI_ITINERARIOS WHERE ITI_NOMBRE = ''Aprovisionamiento''), (SELECT DD_EST_ID FROM '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = ''FP''),0,1296000000,null,''PFS-CONF'',sysdate)';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.EST_ESTADOS... Datos del diccionario insertado');
        
        
    END IF;     
    
    


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
