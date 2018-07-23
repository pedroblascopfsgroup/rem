--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1206
--## PRODUCTO=NO
--##
--## Finalidad: Sancionar oferta como UVEM
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1206';
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

     Insert into REM01.RCB_RESOL_COMITE_BANKIA
       (RCB_ID
       ,ECO_ID
       ,DD_COS_ID
       ,DD_ERE_ID
       ,DD_DCB_ID
       ,RCB_FECHA_ANULA
       ,RCB_IMPORTE_CONTRAOFR
       ,VERSION
       ,USUARIOCREAR
       ,FECHACREAR
       ,USUARIOMODIFICAR
       ,FECHAMODIFICAR
       ,USUARIOBORRAR
       ,FECHABORRAR
       ,BORRADO
       ,DD_TRE_ID
       ,DD_MAN_ID
       ,DD_PEN_ID
       ,RCB_FECHA_RESOLUCION) 
    values (
        rem01.s_RCB_resol_comite_bankia.nextval,
        (select eco_id from rem01.eco_expediente_comercial where eco_num_expediente = 109531),
        (select DD_COS_ID from DD_COS_COMITES_SANCION where dd_cos_codigo ='2'),
        (select DD_ERE_ID from DD_ERE_ESTADO_RESOLUCION where dd_ere_codigo = '1'),
        null,
        null,
        null,
        '0',
        'REMVIP-1206',
        sysdate,
        null,
        null,
        null,
        null,
        '0',
        '1',
        null,
        null,
        to_date('05/06/18','DD/MM/RR')
     );
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registros en la RCB_RESOL_COMITE_BANKIA');
    
    update rem01.eco_expediente_comercial
          set dd_eec_id = (select dd_eec_id from REM01.DD_EEC_EST_EXP_COMERCIAL where dd_eec_codigo = '11')
            , eco_fecha_sancion = to_date('05/06/18','DD/MM/RR')
    where eco_num_expediente = 109531;
    
    
        
    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registros en la DD_EEC_EST_EXP_COMERCIAL');
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
