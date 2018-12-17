package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;

public interface ComunicacionGencatDao extends AbstractDao<ComunicacionGencat, Long> {

	ComunicacionGencat getComunicacionByActivoIdAndEstadoComunicado(String numHayaActivo);
}
