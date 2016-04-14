package es.pfsgroup.tipoContenedor.Dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.tipoContenedor.MapeoTipoContenedor;

public interface MapeoTipoContenedorDao extends AbstractDao<MapeoTipoContenedor,Long> {
	
	public MapeoTipoContenedor getMapeoByTfaAndTdn2(String tipoExp, String claseExp, String tipoFichero);

}
