-- VISTA MATERIALIZADA DEL FILTRO DE AGENDA 

-- BORRADO DE LA VISTA MATERIALIZADA PARA EL FILTRO DE AGENDA
DROP MATERIALIZED VIEW UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN;

-- CREACI�N DE LA VISTA MATERIALIZADA PARA EL FILTRO DE AGENDA
CREATE MATERIALIZED VIEW UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN AS
  SELECT DISTINCT
    asu.ASU_ID,
    usu.USU_USERNAME,
    tno.TAR_EMISOR,
    trg.DD_TRG_CODIGO,
    iReg.IRG_CLAVE,
    lower(iReg.IRG_VALOR) "IRG_VALOR"
  FROM ASU_ASUNTOS asu
    LEFT JOIN TAR_TAREAS_NOTIFICACIONES tno ON asu.ASU_ID = tno.ASU_ID AND tno.DD_STA_ID in (700, 701)
    LEFT JOIN MEJ_REG_REGISTRO reg ON asu.ASU_ID = reg.TRG_EIN_ID AND tno.ASU_ID = reg.TRG_EIN_ID AND reg.TRG_EIN_CODIGO = '3'
    LEFT JOIN MEJ_IRG_INFO_REGISTRO iReg ON reg.REG_ID = iReg.REG_ID AND iReg.IRG_CLAVE IN ('emailTo', 'TIPO_ANO_TAREA', 'TIPO_ANO_NOTIF', 'TIPO_ANO_COMENT')
    LEFT JOIN UNMASTER.USU_USUARIOS usu ON tno.TAR_ID_DEST = usu.USU_ID
    LEFT JOIN MEJ_DD_TRG_TIPO_REGISTRO trg ON reg.DD_TRG_ID = trg.DD_TRG_ID;

-- BORRADO INDICES PARA LA VISTA MATERIALIZADA DEL FILTRO DE AGENDA    
--DROP INDEX UN001.DX_V_BUSQUEDA_ASU_AGE_ASU;
--DROP INDEX UN001.DX_V_BUSQUEDA_ASU_AGE_USU;
--DROP INDEX UN001.DX_V_BUSQUEDA_ASU_AGE_TRG;
--DROP INDEX UN001.DX_V_BUSQUEDA_ASU_AGE_IRG_CLV;
--DROP INDEX UN001.DX_V_BUSQUEDA_ASU_AGE_IRG_VAL;
--DROP INDEX UN001.DX_V_BUSQUEDA_ASU_AGE_EMISOR;
     
-- CREACI�N INDICES PARA LA VISTA MATERIALIZADA DEL FILTRO DE AGENDA
CREATE INDEX UN001.IDX_V_BUSQUEDA_ASU_AGE_ASU ON UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN
(ASU_ID)
LOGGING
TABLESPACE UN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;    

CREATE INDEX UN001.IDX_V_BUSQUEDA_ASU_AGE_USU ON UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN
(USU_USERNAME)
LOGGING
TABLESPACE UN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;    

CREATE INDEX UN001.IDX_V_BUSQUEDA_ASU_AGE_TRG ON UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN
(DD_TRG_CODIGO)
LOGGING
TABLESPACE UN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;    

CREATE INDEX UN001.IDX_V_BUSQUEDA_ASU_AGE_IRG_CLV ON UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN
(IRG_CLAVE)
LOGGING
TABLESPACE UN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;    

CREATE INDEX UN001.IDX_V_BUSQUEDA_ASU_AGE_IRG_VAL ON UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN
(IRG_VALOR)
LOGGING
TABLESPACE UN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;  

CREATE INDEX UN001.IDX_V_BUSQUEDA_ASU_AGE_EMISOR ON UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN
(TAR_EMISOR)
LOGGING
TABLESPACE UN001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;  

-- PLANIFICACION DEL REFRESCO COMPLETO Y PERIODICO DE LA VISTA MATERIALIZADA TODOS LOS DIAS A A LAS 8  DE LA MA�ANA
ALTER MATERIALIZED VIEW UN001.V_BUSQUEDA_ASUNTOS_FILTRO_AGEN 
  REFRESH COMPLETE 
  START WITH TRUNC(SYSDATE) + 8/24  
  NEXT TRUNC(SYSDATE+1) + 8/24;      