package es.pfsgroup.plugin.rem.rest.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.rest.model.InformesModificados;

public interface InformesModificadosDao extends AbstractDao<InformesModificados, Long> {
	public InformesModificados getByInforme(ActivoInfoComercial informe);

}
