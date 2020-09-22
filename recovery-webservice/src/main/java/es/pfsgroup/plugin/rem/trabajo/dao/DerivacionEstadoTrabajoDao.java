package es.pfsgroup.plugin.rem.trabajo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DerivacionEstadoTrabajo;

public interface DerivacionEstadoTrabajoDao extends AbstractDao<DerivacionEstadoTrabajo, Long>{
	
	List<String> getListOfPerfilesValidosForDerivacionEstadoTrabajo();
	List<String> getPosiblesEstados(String estadoActual, List<String> clauseInPerfiles);
}
