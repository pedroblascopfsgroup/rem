package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

@Component
public class PreciosUserAssignationService implements UserAssigantionService {
	
	private static final String CODIGO_T010_ANALISIS_PETICION_CARGA = "T010_AnalisisPeticionCargaList";
	private static final String CODIGO_T009_ANALISIS_PETICION = "T009_AnalisisPeticion";
	private static final String CODIGO_T009_GENERAR_PROPUESTA_PRECIOS = "T009_GenerarPropuestaPrecios";
	private static final String CODIGO_T009_ENVIO_PROPUESTA_PROPIETARIO = "T009_EnvioPropuestaPropietario";
	private static final String CODIGO_T009_SANCION_CARGA_PROPUESTA = "T009_SancionCargaPropuesta";
	
	
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
		return new String[]{CODIGO_T010_ANALISIS_PETICION_CARGA, CODIGO_T009_ANALISIS_PETICION, 
				CODIGO_T009_GENERAR_PROPUESTA_PRECIOS, CODIGO_T009_ENVIO_PROPUESTA_PROPIETARIO, CODIGO_T009_SANCION_CARGA_PROPUESTA};
	}

	
	@Override
	@SuppressWarnings("static-access")
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_PRECIOS);
		String codigoSubtipoTrabajo = tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo();
		
		if(codigoSubtipoTrabajo.equals(DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS_DESCUENTO) || codigoSubtipoTrabajo.equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_DESCUENTO)) {
			filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_MARKETING);
		}
		
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

	@Override
	@SuppressWarnings("static-access")
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_SUPERVISOR_PRECIOS);
		String codigoSubtipoTrabajo = tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo();
		
		if(codigoSubtipoTrabajo.equals(DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS_DESCUENTO) || codigoSubtipoTrabajo.equals(DDSubtipoTrabajo.CODIGO_TRAMITAR_PROPUESTA_DESCUENTO)) {
			filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_SUPERVISOR_MARKETING);
		}
		
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}
}
