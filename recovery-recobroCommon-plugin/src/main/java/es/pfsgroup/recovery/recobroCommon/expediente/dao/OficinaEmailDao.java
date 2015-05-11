package es.pfsgroup.recovery.recobroCommon.expediente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.oficina.model.Oficina;

public interface OficinaEmailDao extends AbstractDao<Oficina, Long>  {

	public String obtenerEmailOficina(Long id);
	
}
