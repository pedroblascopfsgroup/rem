package es.pfsgroup.plugin.rem.clienteComercial.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;

public interface ClienteComercialDao extends AbstractDao<ClienteComercial, Long>{
	
	
	public Long getNextClienteRemId();
	
	public List<ClienteComercial> getListaClientes(ClienteDto clienteDto);

	void deleteTmpClienteByDocumento(String documento);

	public List<ClienteComercial> getListaClientesByDocumento(String documento);

}
