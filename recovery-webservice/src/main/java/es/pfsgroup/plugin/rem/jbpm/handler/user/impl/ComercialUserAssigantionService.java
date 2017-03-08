package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Component
public class ComercialUserAssigantionService implements UserAssigantionService  {

	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	private static final String CODIGO_T013_FIRMA_PROPIETARIO = "T013_FirmaPropietario";
	private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
	private static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";
	private static final String CODIGO_T013_RESPUESTA_OFERTANTE = "T013_RespuestaOfertante";
	private static final String CODIGO_T013_DOBLE_FIRMA = "T013_DobleFirma";
	private static final String CODIGO_T013_INFORME_JURIDICO = "T013_InformeJuridico";
	private static final String CODIGO_T013_INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
	private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	private static final String CODIGO_T013_RESOLUCION_TANTEO = "T013_ResolucionTanteo";
	private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	private static final String CODIGO_T013_POSICIONAMIENTO_FIRMA = "T013_PosicionamientoYFirma";
	private static final String CODIGO_T013_DEVOLUCION_LLAVES = "T013_DevolucionLlaves";
	private static final String CODIGO_T013_DOCUMENTOS_POSTVENTA = "T013_DocumentosPostVenta";
	private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";
	private static final String CODIGO_T013_RATIFICACION_COMITE = "T013_RatificacionComite";

	

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T013_DEFINICION_OFERTA, CODIGO_T013_FIRMA_PROPIETARIO, CODIGO_T013_CIERRE_ECONOMICO, CODIGO_T013_RESOLUCION_COMITE,
				 	CODIGO_T013_RESPUESTA_OFERTANTE, CODIGO_T013_DOBLE_FIRMA, CODIGO_T013_INFORME_JURIDICO, CODIGO_T013_INSTRUCCIONES_RESERVA,
				 	CODIGO_T013_OBTENCION_CONTRATO_RESERVA, CODIGO_T013_RESOLUCION_TANTEO, CODIGO_T013_RESULTADO_PBC, CODIGO_T013_POSICIONAMIENTO_FIRMA, 
				 	CODIGO_T013_DEVOLUCION_LLAVES, CODIGO_T013_DOCUMENTOS_POSTVENTA, CODIGO_T013_RESOLUCION_EXPEDIENTE, CODIGO_T013_RATIFICACION_COMITE };
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();
		String codigoGestor = null;
		
		if(this.isTrabajoDeActivoOrLoteRestEntidad01(tareaActivo)) {
			codigoGestor = this.getMapCodigoTipoGestorActivoAndLoteRestEntidad01().get(codigoTarea);
		}
		else {
			codigoGestor = this.getMapCodigoTipoGestor().get(codigoTarea);
		}
				
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
		
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		if(Checks.esNulo(tipoGestor))
			return null;

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();
		
		String codigoSupervisor = this.getMapCodigoTipoSupervisor().get(codigoTarea);
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoSupervisor);
		
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		if(Checks.esNulo(tipoGestor))
			return null;

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}
	
	/**
	 * Comprueba si el tramite de la tarea es de un solo activo o de una agrupacion restringida, pertenecientes a CAJAMAR
	 * @param tareaActivo
	 * @return
	 */
	private boolean isTrabajoDeActivoOrLoteRestEntidad01(TareaActivo tareaActivo) {
		
		Trabajo trabajo = tareaActivo.getTramite().getTrabajo();
		Activo activo = tareaActivo.getActivo();
		String codCarteraActivo = !Checks.esNulo(activo) ? (!Checks.esNulo(activo.getCartera()) ? activo.getCartera().getCodigo() : null) : null;
		
		if(!Checks.esNulo(trabajo) && !Checks.esNulo(codCarteraActivo) && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codCarteraActivo)) 
		{	
			if(Checks.esNulo(trabajo.getAgrupacion()) || ( !Checks.esNulo(trabajo.getAgrupacion().getTipoAgrupacion()) && 
							DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(trabajo.getAgrupacion().getTipoAgrupacion().getCodigo())))
				return true;
		}

		return false;
	}

	//  --- Mapas con la relación Tarea - Tipo Gestor/supervisor  -------------------------------------------------
	@SuppressWarnings("static-access")	
	private HashMap<String,String> getMapCodigoTipoGestor() {
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		
		mapa.put(this.CODIGO_T013_DEFINICION_OFERTA, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESOLUCION_COMITE, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESPUESTA_OFERTANTE, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_INSTRUCCIONES_RESERVA, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESOLUCION_EXPEDIENTE, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_FIRMA_PROPIETARIO, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RATIFICACION_COMITE, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_CIERRE_ECONOMICO, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_DOCUMENTOS_POSTVENTA, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_RESULTADO_PBC, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_INFORME_JURIDICO, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_RESOLUCION_TANTEO, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_DEVOLUCION_LLAVES, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_POSICIONAMIENTO_FIRMA, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		
		return mapa;
	}
	
	@SuppressWarnings("static-access")
	private HashMap<String,String> getMapCodigoTipoSupervisor() {
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		
		mapa.put(this.CODIGO_T013_DEFINICION_OFERTA, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESOLUCION_COMITE, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESPUESTA_OFERTANTE, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_INSTRUCCIONES_RESERVA, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESOLUCION_EXPEDIENTE, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_FIRMA_PROPIETARIO, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RATIFICACION_COMITE, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_CIERRE_ECONOMICO, gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_DOCUMENTOS_POSTVENTA, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_RESULTADO_PBC, gestorActivoApi.CODIGO_SUPERVISOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_INFORME_JURIDICO, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_RESOLUCION_TANTEO, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_DEVOLUCION_LLAVES, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_POSICIONAMIENTO_FIRMA, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		
		return mapa;
	}
	
	/**
	 * La entidad 01 para activos o lotes restringidos tiene una configuración diferente
	 * @return
	 */
	@SuppressWarnings("static-access")
	private HashMap<String,String> getMapCodigoTipoGestorActivoAndLoteRestEntidad01() {
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		
		mapa.put(this.CODIGO_T013_DEFINICION_OFERTA, gestorActivoApi.CODIGO_GESTOR_BACKOFFICE);
		mapa.put(this.CODIGO_T013_RESOLUCION_COMITE, gestorActivoApi.CODIGO_GESTOR_BACKOFFICE);
		mapa.put(this.CODIGO_T013_RESPUESTA_OFERTANTE, gestorActivoApi.CODIGO_GESTOR_BACKOFFICE);
		mapa.put(this.CODIGO_T013_INSTRUCCIONES_RESERVA, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_RESOLUCION_EXPEDIENTE, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_FIRMA_PROPIETARIO, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_OBTENCION_CONTRATO_RESERVA, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_CIERRE_ECONOMICO, gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		mapa.put(this.CODIGO_T013_DOCUMENTOS_POSTVENTA, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_RESULTADO_PBC, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_INFORME_JURIDICO, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_RESOLUCION_TANTEO, gestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
		mapa.put(this.CODIGO_T013_DEVOLUCION_LLAVES, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		mapa.put(this.CODIGO_T013_POSICIONAMIENTO_FIRMA, gestorActivoApi.CODIGO_GESTORIA_FORMALIZACION);
		
		return mapa;
	}
	// ------------------------------------------------------------------------------------------------------------
}
