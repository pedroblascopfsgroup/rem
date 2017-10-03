package es.pfsgroup.plugin.rem.rest.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.rest.model.ActivosModificados;

public interface ActivosModificadosDao extends AbstractDao<ActivosModificados, Long> {
	public ActivosModificados getByActivo(Activo activo);

}
