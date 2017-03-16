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
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class CedulaHabitabilidadUserAssigantionService implements UserAssigantionService {

	private static final String CODIGO_T008_SOLICITUD_DOCUMENTO = "T008_SolicitudDocumento";
	private static final String CODIGO_T008_OBTENCION_DOCUMENTO = "T008_ObtencionDocumento";
	
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
		return new String[]{CODIGO_T008_SOLICITUD_DOCUMENTO, CODIGO_T008_OBTENCION_DOCUMENTO};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		if(!Checks.esNulo(tareaActivo) && 
				!Checks.esNulo(tareaActivo.getTramite()) && 
				!Checks.esNulo(tareaActivo.getTramite().getActivo()) &&
				!Checks.esNulo(tareaActivo.getTramite().getActivo().getCartera())) {
			
			DDCartera cartera = tareaActivo.getTramite().getActivo().getCartera();
			
			// Si la cartera es BANKIA o SAREB, el gestor de las tareas es GESTOR DE CEDULA
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo())){
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTORIA_CEDULAS);
				EXTDDTipoGestor tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

				if(!Checks.esNulo(tipoGestorActivo.getId()))
					return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestorActivo.getId());

			} else {
			//Otras carteras, el gestor de las tareas es GESTOR ACTIVOS
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
				EXTDDTipoGestor tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

				if(!Checks.esNulo(tipoGestorActivo.getId()))
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
		
		//TODO: ¡Hay que cambiar el método para que no pida ID sino código!
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

}
