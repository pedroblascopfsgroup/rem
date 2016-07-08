--/*
--##########################################
--## AUTOR=Ivan Picazo
--## FECHA_CREACION=20160708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2299
--## PRODUCTO=SI
--##
--## Finalidad: Insertar registro tipoGestor en la tabla MEJ_IRG_INFO_REGISTRO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
    V_DESCRIPCION_GESTOR VARCHAR2(50 CHAR);
    V_INSERCCIONES NUMBER(16) := 0;
    
    V_SQL_TRAZA VARCHAR2(4000 CHAR) := 'INSERT INTO '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE, IRG_VALOR, VERSION, USUARIOCREAR,FECHACREAR, BORRADO) ' ||
		' VALUES ('||V_ESQUEMA||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL, :1, ''tipoGestor'', :2, 0, ''RECOVERY-2299'', sysdate, 0)';
    
	V_SQL_GESTOR VARCHAR2(4000 CHAR) := 'select teg.DD_TGE_DESCRIPCION from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR teg ' ||
					'join '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS cma on teg.DD_TGE_ID=cma.DD_TGE_ID ' ||
					'join '||V_ESQUEMA||'.MEJ_REG_REGISTRO reg on cma.CMA_ID=reg.CMA_ID ' ||
					'where reg.REG_ID=:1';
		
    CURSOR C_VALORES_ACTUALIZAR IS
		select distinct info.REG_ID REG_ID
		from CMA_CAMBIOS_MASIVOS_ASUNTOS cma
		join MEJ_REG_REGISTRO reg on cma.CMA_ID=reg.CMA_ID
		join MEJ_IRG_INFO_REGISTRO info on reg.REG_ID=info.REG_ID
		join MEJ_DD_TRG_TIPO_REGISTRO tipo on reg.DD_TRG_ID=tipo.DD_TRG_ID
		where tipo.DD_TRG_CODIGO='CAMBIO_MASIVO'
		and cma.CMA_ID not in(
                             select distinct cma.cma_id
                             from CMA_CAMBIOS_MASIVOS_ASUNTOS cma
                             join MEJ_REG_REGISTRO reg on cma.CMA_ID=reg.CMA_ID
                             join MEJ_IRG_INFO_REGISTRO info on reg.REG_ID=info.REG_ID
                             join MEJ_DD_TRG_TIPO_REGISTRO tipo on reg.DD_TRG_ID=tipo.DD_TRG_ID
                             where tipo.DD_TRG_CODIGO='CAMBIO_MASIVO'
                             and info.IRG_CLAVE = 'tipoGestor');
   
    V_CAMBIO C_VALORES_ACTUALIZAR%ROWTYPE;                      	
	
	PROCEDURE INSERTAR_TIPO_GESTOR(REG_ID IN NUMBER, GESTOR IN VARCHAR2) IS
	BEGIN
		EXECUTE IMMEDIATE V_SQL_TRAZA USING REG_ID, GESTOR;
	END;
	
BEGIN 
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||' -----.... ' );
	 
	OPEN C_VALORES_ACTUALIZAR;
    LOOP
    	FETCH C_VALORES_ACTUALIZAR INTO V_CAMBIO;
		EXIT WHEN C_VALORES_ACTUALIZAR%NOTFOUND; 
		
		EXECUTE IMMEDIATE V_SQL_GESTOR INTO V_DESCRIPCION_GESTOR USING V_CAMBIO.REG_ID;
	    	INSERTAR_TIPO_GESTOR(V_CAMBIO.REG_ID, V_DESCRIPCION_GESTOR);
	    	V_INSERCCIONES:=V_INSERCCIONES + 1;

    END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_INSERCCIONES||' insercciones efectuadas' );
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... inserccion de la clave tipoGestor' );

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
  	