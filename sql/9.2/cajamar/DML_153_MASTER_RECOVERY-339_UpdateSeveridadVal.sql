--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ SAJARDO
--## FECHA_CREACION=20160705
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-339
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar la severidad a 'LOW' de aquellas validaciones que estan a 'HIGH' cuando no proceden.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_UPDATES NUMBER(16); -- Vble. para almacenar los updates realizados.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  V_TABLA VARCHAR2(30 CHAR) := 'BATCH_JOB_VALIDATION'; -- Tabla que se va a modificar

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE ACTUALIZACION DEL CAMPO JOB_VAL_SEVERITY EN LA TABLA '||V_TABLA||'');
          
   V_SQL := '
			MERGE INTO '||V_ESQUEMA_M||'.'||V_TABLA||' JVAL
			USING
			(
			  SELECT VAL.JOB_VAL_ID
			  FROM '||V_ESQUEMA_M||'.'||V_TABLA||' VAL
			  WHERE VAL.JOB_VAL_CODIGO IN	(
												''cnt-01.entityValidator'',
												''cnt-02.loadDateValidator.Oracle9iDialect'',
												''cnt-06.currencyCodeValidator'',
												''cnt-07.productTypeCodeValidator'',
												''cnt-09.movimientoPrevio'',
												''cnt-13.finalidadOficial'',
												''cnt-14.finalidadContrato'',
												''cnt-15.garantia1'',
												''cnt-16.garantia2'',
												''cnt-17.catalogo1'',
												''cnt-18.catalogo2'',
												''cnt-19.catalogo3'',
												''cnt-20.catalogo4'',
												''cnt-24.aplicativoOrigen'',
												''cnt-25.codPropietario'',
												''cnt-26.estadoFinanciero'',
												''cnt-27.officeAdmCodeValidator'',
												''cnt-28.gestionEspecial'',
												''cnt-29.condicionesRemuneracion'',
												''cnt-30.motivoRenumeracion'',
												''cnt-33.estadoFinancieroAnterior'',
												''cnt-35.tipoProducto'',
												''per-01.entityValidator'',
												''per-02.loadDateValidator.Oracle9iDialect'',
												''per-04.documentTypeValidator'',
												''per-05.segmentValidator'',
												''per-09.tipoTelefono1'',
												''per-10.tipoTelefono2'',
												''per-11.tipoTelefono3'',
												''per-12.tipoTelefono4'',
												''per-13.tipoTelefono5'',
												''per-14.tipoTelefono6'',
												''per-15.perfilGestor'',
												''per-17.grupoGestor'',
												''per-18.politica'',
												''per-19.ratingExterno'',
												''per-20.insertRatingAuxiliar'',
												''per-20.ratingAuxiliar'',
												''per-21.nacionalidad'',
												''per-22.paisNacimiento'',
												''per-23.sexo'',
												''per-24.segment2Validator'',
												''per-25.codPropietarioValidator'',
												''per-26.origenTelefono1Validator'',
												''per-27.personaNivelValidator'',
												''per-28.colectivoSingularValidator'',
												''per-29.tipoGestorValidator'',
												''per-30.areaGestionValidator'',
												''per-33.tipoGestorPersonaValidator'',
												''per-34.tipoGestorOficinaValidator'',
												''per-35.insertTipoPolitica'',
												''per-35.tipoPolitica'',
												''cnt-per-01.entityValidator'',
												''cnt-per-02.loadDateValidator.MySQLDialect'',
												''cnt-per-02.loadDateValidator.Oracle9iDialect'',
												''cnt-per-03.intervencionValidator''
											)
			  AND VAL.JOB_VAL_SEVERITY = (SELECT JVS.DD_JVS_ID FROM '||V_ESQUEMA_M||'.DD_JVS_JOB_VAL_SEVERITY JVS WHERE JVS.DD_JVS_CODIGO = ''HIGH'' AND JVS.BORRADO = 0)
			  AND VAL.BORRADO = 0
			) TMP
			ON (TMP.JOB_VAL_ID = JVAL.JOB_VAL_ID)
			WHEN MATCHED THEN UPDATE SET
					 JVAL.JOB_VAL_SEVERITY = (SELECT JVS.DD_JVS_ID FROM '||V_ESQUEMA_M||'.DD_JVS_JOB_VAL_SEVERITY JVS WHERE JVS.DD_JVS_CODIGO = ''LOW'' AND JVS.BORRADO = 0),
					 JVAL.USUARIOMODIFICAR = ''RECOVERY-339'',
					 JVAL.FECHAMODIFICAR = SYSDATE
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL;      
    
    V_NUM_UPDATES := sql%rowcount;
        
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA_M||'.'||V_TABLA||' COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.'||V_TABLA||' ANALIZADA.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN ACTUALIZADO '||V_NUM_UPDATES||' REGISTROS EN '||V_ESQUEMA_M||'.'||V_TABLA||'');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA '||V_ESQUEMA_M||'.'||V_TABLA||' SE HA ACTUALIZADO CORRECTAMENTE');
 
 
EXCEPTION

   WHEN OTHERS THEN
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
