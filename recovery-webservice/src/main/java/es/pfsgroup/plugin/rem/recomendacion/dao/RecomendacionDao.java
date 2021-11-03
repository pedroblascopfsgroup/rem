package es.pfsgroup.plugin.rem.recomendacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ConfiguracionRecomendacion;

public interface RecomendacionDao extends AbstractDao<ConfiguracionRecomendacion, Long> {

	public void deleteConfigRecomendacionById(Long id);

}
