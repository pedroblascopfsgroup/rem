package es.pfsgroup.plugin.rem.oferta.dao;


import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.VPropuestaAlqBankia;


public interface VPropuestaAlqBankiaDao extends AbstractDao<VPropuestaAlqBankia, Long>{
	

	public List<VPropuestaAlqBankia> getListPropuestasAlqBankiaFromView(Long ecoId);


}
