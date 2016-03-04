--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=piloto1802
--## INCIDENCIA_LINK=CMREC-2282
--## PRODUCTO=NO
--## Finalidad: Actualizar validación de la tarea.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



BEGIN
	-- insertar todos los tipos de documento activos como tipos de documento de Procedimiento remoto
	
	V_MSQL:= 'insert into '||V_ESQUEMA||'.dd_tfa_fichero_adjunto (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,DD_TAC_ID)
				select '||V_ESQUEMA||'.s_dd_tfa_fichero_adjunto.nextval, tfa_nuevo_codigo, dd_tfa_descripcion, DD_TFA_DESCRIPCION_LARGA, ''SAG2502'', sysdate, 
       				(select dd_tac_id from '||V_ESQUEMA||'.dd_tac_tipo_actuacion where dd_tac_codigo = ''TR_REM'')
				from (
 					select distinct tfa.dd_tfa_descripcion, tfa.DD_TFA_DESCRIPCION_LARGA, tfa.dd_tfa_codigo, ' || q'[ 'RM-' || tfa.dd_tfa_codigo]' || ' tfa_nuevo_codigo, mtt.tfa_codigo_externo
 					from '||V_ESQUEMA||'.dd_tac_tipo_actuacion tac inner join 
      				'||V_ESQUEMA||'.dd_tfa_fichero_adjunto tfa on tfa.dd_tac_id = tac.dd_tac_id inner join 
      				'||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tac_id = tac.dd_tac_id inner join 
      				'||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM mtt on mtt.dd_tfa_id = tfa.dd_tfa_id
 					where tac.borrado = 0 and tfa.borrado = 0 and tpo.borrado = 0)';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.dd_tfa_fichero_adjunto');
	
	-- insertar en la tabla de traduccion los nuevos tipos de documento
	
	V_MSQL:= 'insert into '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM (MTT_ID, DD_TFA_ID, TFA_CODIGO_EXTERNO, USUARIOCREAR, FECHACREAR)
				select (SELECT NVL(MAX(MTT_ID)+1, 1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM) + rownum
				       , dd_tfa_id, tfa_codigo_externo, ''SAG2502'', sysdate
				from (
				 select distinct tfa.dd_tfa_descripcion, tfa.dd_tfa_codigo, tfaRM.dd_tfa_codigo, mtt.tfa_codigo_externo, tfaRM.dd_tfa_id
				 from '||V_ESQUEMA||'.dd_tac_tipo_actuacion tac inner join 
				      '||V_ESQUEMA||'.dd_tfa_fichero_adjunto tfa on tfa.dd_tac_id = tac.dd_tac_id inner join 
				      '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tac_id = tac.dd_tac_id inner join 
				      '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM mtt on mtt.dd_tfa_id = tfa.dd_tfa_id inner join 
				      '||V_ESQUEMA||'.dd_tfa_fichero_adjunto tfaRM on tfaRM.dd_tfa_codigo = ' || q'[ 'RM-' || tfa.dd_tfa_codigo]' || '
				where tac.borrado = 0 and tfa.borrado = 0 and tpo.borrado = 0)';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.dd_tfa_fichero_adjunto');

COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
