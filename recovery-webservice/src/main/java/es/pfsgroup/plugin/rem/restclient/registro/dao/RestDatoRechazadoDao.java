package es.pfsgroup.plugin.rem.restclient.registro.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.DatosRechazados;

public interface RestDatoRechazadoDao extends AbstractDao<DatosRechazados, Long> {
	public void guardaRegistro(final DatosRechazados obj);
}
