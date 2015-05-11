package es.capgemini.pfs.plazoTareasDefault.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;

public interface EXTPlazoTareasDefaultDao extends AbstractDao<PlazoTareasDefault, Long>{

	public PlazoTareasDefault buscaPlazoPorDescripcion(String descripcion);

}
