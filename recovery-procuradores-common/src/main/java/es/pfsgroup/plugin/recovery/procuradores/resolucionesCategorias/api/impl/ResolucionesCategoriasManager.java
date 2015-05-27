package es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.api.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.api.ResolucionesCategoriasApi;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.dao.ResolucionesCategoriasDao;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.model.ResolucionesCategorias;

@Service("ResolucionesCategorias")
@Transactional(readOnly = false)
public class ResolucionesCategoriasManager implements ResolucionesCategoriasApi{
	@Autowired
	private ResolucionesCategoriasDao resolucionesCategoriasDao;
	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_GET_RESOLUCIONES_PENDIENTES)
	public List<ResolucionesCategorias> getResolucionesPendientes(Long idUsuario) {
		return resolucionesCategoriasDao.getResolucionesPendientes(idUsuario);
	}

}
