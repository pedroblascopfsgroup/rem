--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERÁ
--## FECHA_CREACION=20160203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-1886
--## PRODUCTO=NO
--## 
--## Finalidad: Nuevos cmapos extras en el PCR
--##									char_extra1 -> Ranking
--##									num_extra3 -> Riesgo Top 200
--##                               , esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30 CHAR) :='EXT_DD_IFX_INFO_EXTRA_CLI';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 
  
  --EXT_DD_IFX_INFO_EXTRA_CLI.DD_IFX_DESCRIPCION Y EXT_DD_IFX_INFO_EXTRA_CLI.DD_IFX_DESCRIPCION_LARGA
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||TABLA||' 
			SET DD_IFX_DESCRIPCION = ''Ranking'', DD_IFX_DESCRIPCION_LARGA = ''Orden en riesgo de los acreditados.''
			WHERE UPPER(DD_IFX_CODIGO) = ''CHAR_EXTRA1''';
  
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Campos EXT_DD_IFX_INFO_EXTRA_CLI CHAR_EXTRA1.');
  
  --EXT_DD_IFX_INFO_EXTRA_CLI.DD_IFX_DESCRIPCION Y EXT_DD_IFX_INFO_EXTRA_CLI.DD_IFX_DESCRIPCION_LARGA
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||TABLA||' 
			SET DD_IFX_DESCRIPCION = ''Riesgo Top 200'', DD_IFX_DESCRIPCION_LARGA = ''Riesgo Top 200''
			WHERE UPPER(DD_IFX_CODIGO) = ''NUM_EXTRA3''';
  
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Campos EXT_DD_IFX_INFO_EXTRA_CLI NUM_EXTRA3.');
  
  COMMIT;

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
