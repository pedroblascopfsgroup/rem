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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

@Component
public class ValidacionActuacionUserAssignationService implements UserAssigantionService {

	private static final String CODIGO_T002_VALIDACION_ACTUACION = "T002_ValidacionActuacion";
	
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
		return new String[]{CODIGO_T002_VALIDACION_ACTUACION};
	}
	
	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();		
		
		if(!Checks.esNulo(tareaActivo) && 
				!Checks.esNulo(tareaActivo.getTramite()) && 
				!Checks.esNulo(tareaActivo.getTramite().getTrabajo()) &&
				!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo())) {
			
			DDCartera cartera = tareaActivo.getTramite().getActivo().getCartera();

			EXTDDTipoGestor tipoGestorActivo = null;
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_SIN_CARGAS) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA)) {
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ADMISION);
				tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);	
			}
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION) &&
					(DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_TANGO.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_GIANTS.equals(cartera.getCodigo()))) {
					
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ADMISION);
				tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);	
			}
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_LPO) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_CFO) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA) || 
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_BOLETIN_GAS) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD)) {
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
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

			DDCartera cartera = tareaActivo.getTramite().getActivo().getCartera();
			
			EXTDDTipoGestor tipoGestorActivo = null;
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_ACTUALIZADA) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_NOTA_SIMPLE_SIN_CARGAS) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_AUTORIZACION_VENTA)) {
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
				tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);					 
			}
			if ((DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_TANGO.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_GIANTS.equals(cartera.getCodigo())) &&
					tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_VPO_SOLICITUD_DEVOLUCION)) {
					
					Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
					tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);	
			}			
			if (tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_LPO) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_CFO) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_BOLETIN_AGUA) || 
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_BOLETIN_GAS) ||
				tareaActivo.getTramite().getTrabajo().getSubtipoTrabajo().getCodigo().equals(DDSubtipoTrabajo.CODIGO_BOLETIN_ELECTRICIDAD)) {
				
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
				tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);			 
			}
			
			if (tipoGestorActivo!=null && !Checks.esNulo(tipoGestorActivo) && !Checks.esNulo(tipoGestorActivo.getId())) {
				return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestorActivo.getId());
			}
		}
		
		return null;
	}

}
