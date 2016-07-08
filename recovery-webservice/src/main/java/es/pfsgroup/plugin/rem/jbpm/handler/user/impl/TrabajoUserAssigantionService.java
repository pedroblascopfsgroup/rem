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
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component
public class TrabajoUserAssigantionService implements UserAssigantionService {

	private static final String CODIGO_T004_RESULTADO_TARIFICADA = "T004_ResultadoTarificada";
	private static final String CODIGO_T004_RESULTADO_NOTARIFICADA = "T004_ResultadoNoTarificada";
	
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
		return new String[]{CODIGO_T004_RESULTADO_TARIFICADA, CODIGO_T004_RESULTADO_NOTARIFICADA};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		ActivoProveedorContacto proveedor = tareaActivo.getTramite().getTrabajo().getProveedorContacto();
		if(!Checks.esNulo(proveedor))
			return proveedor.getUsuario();

		return null;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		//TODO: ¡Hay que cambiar el método para que no pida ID sino código!
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_ACTIVO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

}
