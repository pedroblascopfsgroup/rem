SET SERVEROUTPUT ON;
declare
 v_count number;
 v_max number;
 v_sql varchar2(1000);
 
 v_owner varchar2(30);
 v_table varchar2(30);
 v_attrib varchar2(30);
 v_sequen varchar2(30);

begin

 v_owner  := 'BANK01';
 v_table  := 'PRC_PROCEDIMIENTOS';
 v_attrib := 'PRC_ID';
 v_sequen := 'S_PRC_PROCEDIMIENTOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
   
    v_owner  := 'BANK01';
 v_table  := 'TEV_TAREA_EXTERNA_VALOR';
 v_attrib := 'TEV_ID';
 v_sequen := 'S_TEV_TAREA_EXTERNA_VALOR';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'TEX_TAREA_EXTERNA';
 v_attrib := 'TEX_ID';
 v_sequen := 'S_TEX_TAREA_EXTERNA';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'TAR_TAREAS_NOTIFICACIONES';
 v_attrib := 'TAR_ID';
 v_sequen := 'S_TAR_TAREAS_NOTIFICACIONES';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
   
    v_owner  := 'BANK01';
 v_table  := 'DPR_DECISIONES_PROCEDIMIENTOS';
 v_attrib := 'DPR_ID';
 v_sequen := 'S_DPR_DEC_PROCEDIMIENTOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'HCA_HISTORICO_CAMBIOS_ASUNTO';
 v_attrib := 'HCA_ID';
 v_sequen := 'S_HCA_HISTORICO_CAMBIOS_ASUNTO';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'HAC_HISTORICO_ACCESOS';
 v_attrib := 'HAC_ID';
 v_sequen := 'S_HAC_HISTORICO_ACCESOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'MEJ_REG_REGISTRO';
 v_attrib := 'REG_ID';
 v_sequen := 'S_MEJ_REG_REGISTRO';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'AAS_ANALISIS_ASUNTO';
 v_attrib := 'AAS_ID';
 v_sequen := 'S_AAS_ANALISIS_ASUNTO';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
    v_owner  := 'BANK01';
 v_table  := 'MEJ_IRG_INFO_REGISTRO';
 v_attrib := 'IRG_ID';
 v_sequen := 'S_MEJ_IRG_INFO_REGISTRO';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));   
   
    v_owner  := 'BANK01';
 v_table  := 'GAA_GESTOR_ADICIONAL_ASUNTO';
 v_attrib := 'GAA_ID';
 v_sequen := 'S_GAA_GESTOR_ADICIONAL_ASUNTO';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
    v_owner  := 'BANK01';
 v_table  := 'PRD_PROCEDIMIENTOS_DERIVADOS';
 v_attrib := 'PRD_ID';
 v_sequen := 'S_PRD_PROCED_DERIVADOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));



    v_owner  := 'BANK01';
 v_table  := 'ADA_ADJUNTOS_ASUNTOS';
 v_attrib := 'ADA_ID';
 v_sequen := 'S_ADA_ADJUNTOS_ASUNTOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   

    v_owner  := 'BANK01';
 v_table  := 'ADJ_ADJUNTOS';
 v_attrib := 'ADJ_ID';
 v_sequen := 'S_ADJ_ADJUNTOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
   

    v_owner  := 'BANK01';
 v_table  := 'ADP_ADJUNTOS_PERSONAS';
 v_attrib := 'ADP_ID';
 v_sequen := 'S_ADP_ADJUNTOS_PERSONAS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
   

    v_owner  := 'BANK01';
 v_table  := 'ADC_ADJUNTOS_CONTRATOS';
 v_attrib := 'ADC_ID';
 v_sequen := 'S_ADC_ADJUNTOS_CONTRATOS';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
   

    v_owner  := 'BANK01';
 v_table  := 'ADE_ADJUNTOS_EXPEDIENTES';
 v_attrib := 'ADE_ID';
 v_sequen := 'S_ADE_ADJUNTOS_EXPEDIENTES';
 
 DBMS_OUTPUT.PUT_LINE('[INICIO] '||to_char(sysdate,'HH24:MI:SS'));
 -- maximo valor en la tabla
 v_max := 0;
 v_sql:='select max('||v_attrib||') from '||v_owner||'.'||v_table;
 execute immediate v_sql into v_max;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo tabla: '||v_max);
 
 -- maximo valor en la secuencia
 v_count:=0;
 v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
 execute immediate v_sql into v_count;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Valor máximo secuencia: '||v_count);
 
 while v_count <= v_max
   loop
     v_sql:='select '||v_owner||'.'||v_sequen||'.nextval from dual';
     execute immediate v_sql into v_count;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Creado valor: '||v_count);
   end loop;
  
   DBMS_OUTPUT.PUT_LINE('[FIN] '||to_char(sysdate,'HH24:MI:SS'));
   
   
end;
