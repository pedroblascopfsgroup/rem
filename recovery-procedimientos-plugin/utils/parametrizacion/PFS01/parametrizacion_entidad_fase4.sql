-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

-- Insertar nuevos tipos de procedimientos
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\insertar_clasificacion_procedimientos.sql

-- JUDICIALES -------------------------------------------------------------------------------------
-- actualizar tipo de procedimiento
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\judiciales\update_TAC_ID.sql
-- actualizar plaza juzgado numprocedimiento por defecto.
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\judiciales\update_plazaJuzgNumProc_porDefecto.sql
-- actualizar campo textProc
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\judiciales\updates_TFI_TAREAS_TextProc.sql


-- CONCURSAL -------------------------------------------------------------------------------------
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\inserts_DD_TPO_TIPO_PROCEDIMIENTO.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\22-procedimientoSolicitudConcursal.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\23-tramiteFaseComunAbreviado.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\24-tramiteFaseComunOrdinario.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\25-tramiteDemandaIncidental.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\26-tramiteDemandadoEnIncidente.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\27-tramiteSolicitudActuacionesReintegracionContra3.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\28-tramiteRegistrarResolucionDeInteres.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\35-tramitePresentaciónPropuestaConvenio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\29-tramiteFaseConvenio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\30-tramitePropuestaAnticipadaConvenio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\31-tramiteFaseLiquidacion.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Concursal\34-tramiteCalificacion.sql


-- PENALES -------------------------------------------------------------------------------------
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Penales\inserts_DD_TPO_TIPO_PROCEDIMIENTO.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Penales\32-procedimientoAbreviado.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Penales\33-tramiteArchivo.sql


-- ADJUDICADOS -------------------------------------------------------------------------------------
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\inserts_DD_TPO_TIPO_PROCEDIMIENTO.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\36-PODeslindeAmojonamiento.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\37-JVDeslindeAmojonamiento.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\38-POAccionDominio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\39-JVAccionDominio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\40-POAccionPauliana.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\41-JVAccionPauliana.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\42-tramiteDeRegistro.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\43-POAccionNegatoriaDeServidumbre.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\44-JVAccionNegatoriaDeServidumbre.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\45-POAccionConfirmatoriaDeServidumbre.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\46-JVAccionConfirmatoriaDeServidumbre.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\47-PODivisionCosaComun.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\48-JVDivisionCosaComun.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\49-PONulidadContratoArrendamiento.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\50-JVNulidadContratoArrendamiento.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\51-JVDesaucio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\52-POInterdictoDeRecobroPosesorio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\53-JVInterdictoDeRecobroPosesorio.sql
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\Adjudicados\54-tramiteDePosesion.sql

-- FASE PROCESAL 
-- actualizar fase procesal Judiciales y parte de adjudicados
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\update_Judiciales_FaseProcesal_TAP_TAREA_PROCEDIMIENTO.sql
-- actualizar fase procesal concursal
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\update_Concursal_FaseProcesal_TAP_TAREA_PROCEDIMIENTO.sql
-- actualizar fase procesal adjudicados
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\update_Adjudicados_FaseProcesal_TAP_TAREA_PROCEDIMIENTO.sql
-- actualizar fase procesal penales
@C:\Proyectos\pfs\pfs_group\parametrizacion\_TramitesProcedimientos\update_penales_FaseProcesal_TAP_TAREA_PROCEDIMIENTO.sql

