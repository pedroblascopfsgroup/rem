package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component
public class DefaultUserAssigantionService implements UserAssigantionService {

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
		return new String[]{DEFAULT_SERVICE_BEAN_KEY};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento)tareaExterna.getTareaProcedimiento();
		Usuario gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tareaProcedimiento.getTipoGestor().getId());
		return gestor;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento)tareaExterna.getTareaProcedimiento();
		
		Usuario gestor = null;
		
		/*
		 * Gestor de admisión --> Supervisor de admisión
		 * Gestor de activos --> Supervisor de activos
		 * Gestoría de admisión --> Gestor de activos
		 * Proveedor --> Gestor de activos
		 * 
		 */
		
		if(GestorActivoApi.CODIGO_GESTOR_ADMISION.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
			gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
		} else{
			if(GestorActivoApi.CODIGO_GESTOR_ACTIVO.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
				gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
			}else{
				if(GestorActivoApi.CODIGO_GESTORIA_ADMISION.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
					gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
				}else{
					if(GestorActivoApi.CODIGO_PROVEEDOR.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
						gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
					}
				}
			}
		}
		
		//Validamos por si no se hubiese obtenido el supervisor.
		if(Checks.esNulo(gestor))
			return this.getUser(tareaExterna);
		else
			return gestor;
	}

}
