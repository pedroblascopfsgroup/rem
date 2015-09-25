--/*
--##########################################
--## AUTOR=OSCAR_DORADO
--## FECHA_CREACION=20150921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-bk-patch03
--## INCIDENCIA_LINK=BKREC-983
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





--0B79282562 OLIMOTO SL
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''titulo'',null,''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''fechaAnuncio'',''2015-05-14'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''fechaSenyalamiento'',''2015-07-20'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''costasLetrado'',''8204.41'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''costasProcurador'',''4587.57'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''intereses'',''164451.2'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''observaciones'',''LOS HONORARIOS NO SON LOS EXACTOS, YA QUE POR DEFECTO NO ME DEJA INTRODUCIR MAS DEL 5% DEL PRINCIPAL EN LOS HONORARIOS DE LETRADO, SIENDO SOLO VALIDO ESTE SUPUESTO PARA LOS CASOS DE VIVIENDA HABITUAL.  LOS HONORARIOS CORRECTOS DE LETRADO SON: 14.635,31 €'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18717253'',''principal'',''8204.4'',''0'',''A172554'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';


--B97165930 SAFOR GUIA S.L.
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''titulo'',null,''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''fechaAnuncio'',''2015-06-19'',''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''fechaSenyalamiento'',''2015-09-03'',''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''costasLetrado'',''0'',''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''costasProcurador'',''0'',''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''intereses'',''23.3'',''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''observaciones'',null,''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''18864479'',''principal'',''5443.4'',''0'',''A135243'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';


--453851678 SIMON DAVID OXLEY
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''titulo'',null,''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''fechaAnuncio'',''2015-06-25'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''fechaSenyalamiento'',''2015-09-09'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''costasLetrado'',''4303.71'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''costasProcurador'',''2073.46'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''intereses'',''44498.56'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''observaciones'',''No se trata de vivienda habitual, con lo cual las costas de letrado ascenderán a 10.708,72 € sin limitación al 5%'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13440853'',''principal'',''4303.72'',''0'',''A164031'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';


--043549826Q ADORACION CUENCA CASAS
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''titulo'',null,''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''fechaAnuncio'',''2015-05-25'',''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''fechaSenyalamiento'',''2015-09-08'',''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''costasLetrado'',''11491.48'',''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''costasProcurador'',''2295.08'',''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''intereses'',''76918.76'',''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''observaciones'',null,''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13319495'',''principal'',''11491.49'',''0'',''A171748'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';


--052192267T MONTSERRAT PARACUELLOS TURO
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''titulo'',null,''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''fechaAnuncio'',''2015-07-03'',''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''fechaSenyalamiento'',''2015-09-10'',''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''costasLetrado'',''6947.53'',''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''costasProcurador'',''2163.11'',''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''intereses'',''42685.55'',''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''observaciones'',null,''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';
EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.tev_tarea_externa_valor (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEV_VALOR_CLOB,DTYPE) values ('||V_ESQUEMA||'.s_tev_tarea_externa_valor.nextval,''13557617'',''principal'',''6947.54'',''0'',''A164071'',sysdate,null,null,null,null,''0'', EMPTY_CLOB(),''EXTTareaExternaValor'')';






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