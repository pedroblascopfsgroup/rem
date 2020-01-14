package es.pfsgroup.plugin.rem.bulkAdvisoryNote.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.BulkOferta;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface BulkOfertaDao extends AbstractDao<BulkOferta, Long>{
	
	public BulkOferta findOne(Long idBulk, Long idOferta);
	
	public List<Oferta> getListOfertasByIdBulk(Long idBulk);
	
}
