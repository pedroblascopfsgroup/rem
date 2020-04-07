package es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.BulkOferta;

public interface BulkOfertaDao extends AbstractDao<BulkOferta, Long>{
	
	/**
	 * Busca un objeto BulkOferta a partir de un idBulk o un idOferta.
	 * @param idBulk
	 * @param idOferta
	 * @return un objeto BulkOferta
	 */
	public BulkOferta findOne(Long idBulk, Long idOferta, Boolean borrado);
	
	/**
	 * Devuelve una lista de BulkOferta pasando el idBulk
	 * @param idBulk
	 * @return Lista de BulkOferta
	 */
	public List<BulkOferta> getListBulkOfertasByIdBulk(Long idBulk);
	
}
