package es.pfsgroup.recovery.hrebcc.Dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.hrebcc.model.Vencidos;

public interface RiesgoOperacionalVencidosDao extends AbstractDao<Vencidos, Long> {

	
	public List<Vencidos> getListVencidos(Long cntId);
}
