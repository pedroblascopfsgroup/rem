package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

@Component
public class AutorizacionBankiaUserAssignation implements UserAssigantionService {

	private static final String CODIGO_T002_AUTORIZACION_BANKIA = "T002_AutorizacionBankia";
	
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
		return new String[]{CODIGO_T002_AUTORIZACION_BANKIA};
	}
	
	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();		
		
		if(!Checks.esNulo(tareaActivo) && 
				!Checks.esNulo(tareaActivo.getTramite()) && 
				!Checks.esNulo(tareaActivo.getTramite().getTrabajo()) &&
				!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo())) {

			EXTDDTipoGestor tipoGestorActivo = null;
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_SIN_CARGAS) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION)) {
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ADMISION);
				tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);					 
			}
			
			if (tipoGestorActivo!=null && !Checks.esNulo(tipoGestorActivo) && !Checks.esNulo(tipoGestorActivo.getId())) {
				return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestorActivo.getId());
			}
		}

		//Si no se ha podido determinar el gestor destinatario se mantiene el que tenga asociado la TAR_TAREAS
		//(gestor del activo para estas tareas)
		return null;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		if(!Checks.esNulo(tareaActivo) && 
				!Checks.esNulo(tareaActivo.getTramite()) && 
				!Checks.esNulo(tareaActivo.getTramite().getTrabajo()) &&
				!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo())) {

			EXTDDTipoGestor tipoGestorActivo = null;
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_SIN_CARGAS) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION)) {
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
				tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);					 
			}
			
			if (tipoGestorActivo!=null && !Checks.esNulo(tipoGestorActivo) && !Checks.esNulo(tipoGestorActivo.getId())) {
				return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestorActivo.getId());
			}
		}
		
		return null;
	}
}
