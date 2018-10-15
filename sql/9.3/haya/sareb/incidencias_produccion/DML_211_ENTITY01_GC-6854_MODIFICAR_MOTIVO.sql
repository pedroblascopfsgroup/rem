--/*
--##########################################
--## AUTOR=Jorge Mollá
--## FECHA_CREACION=20180727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HRNIVDOS-9612
--## PRODUCTO=NO
--## Finalidad: Insertar liquidaciones a precontenciosos sin liquidaciones.
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
    
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				-- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 	-- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); 								-- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); 								-- Vble. para validar la existencia de una tabla.   
    err_num NUMBER; 										-- Numero de errores
    err_msg VARCHAR2(2048); 								-- Mensaje de error

    

BEGIN	
    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]: MODIFICAMOS EL MOTIVO DE FINALIZACIÓN');
    
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000000247]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000003744 AND DPR_ID = 1000000000107689]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000002772 AND DPR_ID = 1000000000084539]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000005662 AND DPR_ID = 1000000000100862]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000005699 AND DPR_ID = 1000000000101239]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007127 AND DPR_ID = 1000000000109924]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000006935]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007434]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007435]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007402]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007405]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007406]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007433]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007437]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000006948]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007367]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007377]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007394 AND DPR_ID = 1000000000106515]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007403]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000007404]';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL:= q'[UPDATE #ESQUEMA#.DPR_DECISIONES_PROCEDIMIENTOS SET DD_DFI_ID = 2, USUARIOMODIFICAR = 'HRNIVDOS-9612', FECHAMODIFICAR = SYSDATE WHERE PRC_ID = 1000000000049316]';
	EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: MOTIVO MODIFICADO CORRECTAMENTE');
    
    COMMIT;
    

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
  	
