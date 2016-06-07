--/*
--##########################################
--## AUTOR=Ivan Picazo
--## FECHA_CREACION=20160607
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=PRODUCTO-1444
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar campo DD_DFI_ID para los asuntos finalizados
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
    
    V_SQL_ASU VARCHAR2(4000 CHAR)  := 'UPDATE #ESQUEMA#.ASU_ASUNTOS SET DD_DFI_ID=:1 WHERE ASU_ID=:2';
    
    CURSOR C_CAMBIOMOTIVO IS
		select distinct asu.asu_id, dp.dd_dfi_id
		from asu_asuntos asu
		inner join prc_procedimientos p on asu.asu_id=p.asu_id
		inner join dpr_decisiones_procedimientos dp on dp.prc_id=p.prc_id
		where dp.dd_dfi_id is not null
		and asu.asu_id in (
                          select asu.asu_id from (
                                                 select asu.asu_id, dp.dd_dfi_id from asu_asuntos asu
                                                 inner join prc_procedimientos p on asu.asu_id=p.asu_id
                                                 inner join dpr_decisiones_procedimientos dp on dp.prc_id=p.prc_id
                                                 where dp.dd_dfi_id is not null
                                                 group by asu.asu_id, dp.dd_dfi_id
                                                 ) asu
                          group by asu.asu_id
                          having count(*)=1);
                        
	V_CAMBIO C_CAMBIOMOTIVO%ROWTYPE;

	PROCEDURE ACTUALIZAR_DD_DFI_ID(ASU_ID IN NUMBER, DD_DFI_ID IN NUMBER) IS
	BEGIN
		EXECUTE IMMEDIATE V_SQL_ASU USING DD_DFI_ID, ASU_ID;
        --DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);		
	END;

	
BEGIN 
	OPEN C_CAMBIOMOTIVO;
    LOOP
    	FETCH C_CAMBIOMOTIVO INTO V_CAMBIO;
		EXIT WHEN C_CAMBIOMOTIVO%NOTFOUND; 
	    	ACTUALIZAR_DD_DFI_ID(V_CAMBIO.ASU_ID, V_CAMBIO.DD_DFI_ID);

    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO DD_DFI_ID' );

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
  	