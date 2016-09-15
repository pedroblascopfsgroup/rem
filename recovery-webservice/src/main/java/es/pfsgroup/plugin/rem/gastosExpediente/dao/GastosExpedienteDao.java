package es.pfsgroup.plugin.rem.gastosExpediente.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;

public interface GastosExpedienteDao extends AbstractDao<GastosExpediente, Long>{
	

	
	public List<GastosExpediente> getListaGastosExpediente(ComisionDto comisionDto);


}
