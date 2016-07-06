--/*
--##########################################
--## AUTOR=Daniel Albert Pérez
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-257
--## PRODUCTO=NO
--## Finalidad: DML reparación asuntos CAJAMAR
--##           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

	DELETE FROM
	  #ESQUEMA#.PRC_CEX
	WHERE
	  (PRC_ID, CEX_ID) IN
		(
		  SELECT
			APC.PRC_ID
			, APC.CEX_ID
		  FROM
			(
			  SELECT
				A.ASU_ID
				, A.ASU_NOMBRE
				, PC.*
			  FROM
				(
				  SELECT
					ASU_ID
				  FROM
					(
						SELECT DISTINCT
						  A.ASU_ID
						  , C.CNT_ID
						FROM
						  #ESQUEMA#.ASU_ASUNTOS A
						  , #ESQUEMA#.PRC_PROCEDIMIENTOS P
						  , #ESQUEMA#.PRC_CEX PC
						  , #ESQUEMA#.CEX_CONTRATOS_EXPEDIENTE CE
						  , #ESQUEMA#.CNT_CONTRATOS C
						WHERE
						  A.ASU_ID = P.ASU_ID
						  AND P.PRC_ID = PC.PRC_ID
						  AND CE.CEX_ID = PC.CEX_ID
						  AND CE.CNT_ID = C.CNT_ID
						  AND A.DD_EAS_ID = (SELECT DD_EAS_ID FROM #ESQUEMA_MASTER#.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_CODIGO = '03')
						  AND A.DD_TAS_ID = (SELECT DD_TAS_ID FROM #ESQUEMA_MASTER#.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = '01')
						  AND A.USUARIOCREAR = 'ALTAASUNCM'
						  AND A.BORRADO = 0
					)
				  GROUP BY
					ASU_ID
				  HAVING
					COUNT(1) > 1
				)AMC
				, #ESQUEMA#.ASU_ASUNTOS A
				, #ESQUEMA#.PRC_PROCEDIMIENTOS P
				, #ESQUEMA#.PRC_CEX PC
			  WHERE
				A.ASU_ID = AMC.ASU_ID
				AND P.ASU_ID = A.ASU_ID
				AND P.PRC_ID = PC.PRC_ID
			) APC
			, #ESQUEMA#.CEX_CONTRATOS_EXPEDIENTE CX
			, #ESQUEMA#.CNT_CONTRATOS C
		  WHERE
			APC.CEX_ID = CX.CEX_ID
			AND C.CNT_ID = CX.CNT_ID
			AND LPAD(C.CNT_CONTRATO,16,'0') <> SUBSTR(APC.ASU_NOMBRE,1,16)
		);

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
