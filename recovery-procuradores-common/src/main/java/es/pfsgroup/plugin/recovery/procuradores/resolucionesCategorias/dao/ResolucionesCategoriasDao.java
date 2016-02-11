package es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.dao;


import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.resolucionesCategorias.model.ResolucionesCategorias;

public interface ResolucionesCategoriasDao extends AbstractDao<ResolucionesCategorias, Long>{

	public List<ResolucionesCategorias> getResolucionesPendientes(Long idUsuario);

}