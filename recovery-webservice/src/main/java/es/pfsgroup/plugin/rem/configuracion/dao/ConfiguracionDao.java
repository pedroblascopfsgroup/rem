package es.pfsgroup.plugin.rem.configuracion.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ConfiguracionReam;
import es.pfsgroup.plugin.rem.model.DtoMantenimientoFilter;

@SuppressWarnings("rawtypes")
public interface ConfiguracionDao extends AbstractDao{

	public List<ConfiguracionReam> getListMantenimiento(DtoMantenimientoFilter dto);

}
