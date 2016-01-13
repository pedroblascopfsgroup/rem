/***************************************/
-- MIGRACION BUROFAXES CAJAMAR (BCC)
-- Creador: Jaime Sánchez-Cuenca, PFS Group
-- Modificador: 
-- Fecha: 12/01/2016
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set timing on
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    USUARIO varchar2(20) := 'MIGRACM01PCO';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR MIGRACION EXPEDIENTES_NOTIFICACIONES');    

	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.PCO_BUR_BUROFAX(PCO_BUR_BUROFAX_ID
                            ,PCO_PRC_ID
                            ,PER_ID
                            ,DD_PCO_BFE_ID
                            ,CNT_ID
                            ,DD_TIN_ID
                            ,SYS_GUID
                            ,VERSION
                            ,USUARIOCREAR
                            ,FECHACREAR)
	SELECT '||V_ESQUEMA||'.S_PCO_BUR_BUROFAX_ID.NEXTVAL,
	       PCO.PCO_PRC_ID,
	       PER.PER_ID,
	       DECODE(MIG.FECHA_ACUSE_RECIBO,NULL,2,1) AS DD_PCO_BFE_ID,
	       CEX.CNT_ID,
	       CPE.DD_TIN_ID,
	       SYS_GUID(),
	       0,
	       '''||USUARIO||''',
	       SYSDATE
	FROM '||V_ESQUEMA||'.MIG_EXPEDIENTES_NOTIFICACIONES MIG,
	     '||V_ESQUEMA||'.PER_PERSONAS PER,
	     '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO,
	     '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX,
	     '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP,
	     '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE
	WHERE MIG.CODIGO_ENTIDAD||MIG.CODIGO_PERSONA = PER.PER_COD_CLIENTE_ENTIDAD
	  AND MIG.CD_EXPEDIENTE = PCO.PCO_PRC_NUM_EXP_INT
	  AND MIG.CD_EXPEDIENTE = EXP.CD_EXPEDIENTE_NUSE
	  AND EXP.EXP_ID = CEX.EXP_ID
	  AND PER.PER_ID = CPE.PER_ID
	  AND CEX.CNT_ID = CPE.CNT_ID';

        DBMS_OUTPUT.PUT_LINE('Primer Insert en PCO_BUR_BUROFAX: '||sql%rowcount);

	EXECUTE IMMEDIATE '
	INSERT INTO '||V_ESQUEMA||'.PCO_BUR_BUROFAX(PCO_BUR_BUROFAX_ID
                            ,PCO_PRC_ID
                            ,PER_ID
                            ,DD_PCO_BFE_ID
                            ,CNT_ID
                            ,DD_TIN_ID
                            ,SYS_GUID
                            ,VERSION
                            ,USUARIOCREAR
                            ,FECHACREAR)
	SELECT '||V_ESQUEMA||'.S_PCO_BUR_BUROFAX_ID.NEXTVAL,
	       PCO.PCO_PRC_ID,
	       PER.PER_ID,
	       DECODE(MIG.FECHA_ACUSE_RECIBO,NULL,2,1) AS DD_PCO_BFE_ID,
	       NULL,
	       NULL,
	       SYS_GUID(),
	       0,
	       '''||USUARIO||''',
	       SYSDATE
	FROM '||V_ESQUEMA||'.MIG_EXPEDIENTES_NOTIFICACIONES MIG,
	     '||V_ESQUEMA||'.PER_PERSONAS PER,
	     '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
	WHERE MIG.CODIGO_ENTIDAD||MIG.CODIGO_PERSONA = PER.PER_COD_CLIENTE_ENTIDAD
	AND MIG.CD_EXPEDIENTE = PCO.PCO_PRC_NUM_EXP_INT
	AND NOT EXISTS(SELECT 1
		       FROM '||V_ESQUEMA||'.PCO_BUR_BUROFAX BUR
		       WHERE BUR.PCO_PRC_ID = PCO.PCO_PRC_ID 
		       AND BUR.PER_ID = PER.PER_ID)';

        DBMS_OUTPUT.PUT_LINE('Segundo Insert en PCO_BUR_BUROFAX: '||sql%rowcount);

        COMMIT;

	EXECUTE IMMEDIATE'
	INSERT INTO '||V_ESQUEMA||'.PCO_BUR_ENVIO(PCO_BUR_ENVIO_ID
                          ,PCO_BUR_BUROFAX_ID
                          ,DIR_ID
                          ,DD_PCO_BFT_ID
                          ,PCO_BUR_ENVIO_FECHA_SOLICITUD
                          ,PCO_BUR_ENVIO_FECHA_ENVIO
                          ,PCO_BUR_ENVIO_FECHA_ACUSO
                          ,DD_PCO_BFR_ID
                          ,SYS_GUID
                          ,VERSION
                          ,USUARIOCREAR
                          ,FECHACREAR)
	SELECT '||V_ESQUEMA||'.S_PCO_BUR_ENVIO_ID.NEXTVAL,
	       BUR.PCO_BUR_BUROFAX_ID,
	       DIR.DIR_ID,
	       3 AS DD_PCO_BFT_ID,
	       MIG.FECHA_ENVIO,
	       MIG.FECHA_ENVIO,
	       MIG.FECHA_ACUSE_RECIBO,
	       DECODE(MIG.FECHA_ENVIO,NULL,2,101) AS DD_PCO_BFR_ID,
	       SYS_GUID(),
	       0,
	       '''||USUARIO||''',
	       SYSDATE       
	FROM '||V_ESQUEMA||'.MIG_EXPEDIENTES_NOTIFICACIONES MIG,
	     '||V_ESQUEMA||'.PCO_BUR_BUROFAX BUR,
	     '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO,
	     '||V_ESQUEMA||'.PER_PERSONAS PER,
	     '||V_ESQUEMA||'.DIR_DIRECCIONES DIR
	WHERE MIG.CD_EXPEDIENTE = PCO.PCO_PRC_NUM_EXP_INT
	AND PCO.PCO_PRC_ID = BUR.PCO_PRC_ID
	AND MIG.CODIGO_ENTIDAD||MIG.CODIGO_PERSONA = PER.PER_COD_CLIENTE_ENTIDAD
	AND PER.PER_ID = BUR.PER_ID
	AND SUBSTR(REPLACE(MIG.NOMBRE_VIA,''C/'',''''),1,INSTR(MIG.NOMBRE_VIA,'','')-1) = DIR.DIR_DOMICILIO
	AND MIG.CODIGO_POSTAL = DIR.DIR_COD_POST_INTL';

        DBMS_OUTPUT.PUT_LINE('Insert en PCO_BUR_ENVIO: '||sql%rowcount);

        COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR MIGRACION EXPEDIENTES_NOTIFICACIONES');    
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
