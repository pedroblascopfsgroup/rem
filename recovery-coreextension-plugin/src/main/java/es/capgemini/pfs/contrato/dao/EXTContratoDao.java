package es.capgemini.pfs.contrato.dao;

import java.util.HashMap;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;

import es.pfsgroup.recovery.ext.api.contrato.dto.EXTBusquedaContratosDto;

public interface EXTContratoDao extends AbstractDao<Contrato, Long> {

	Page buscarContratosPaginados(BusquedaContratosDto dto, Usuario usuLogado);

	/**
	 * Busca el contrato de un cliente.
	 * 
	 * @param dto
	 *            dto de busqueda
	 * @return una lista que contiene el contrato de pase.
	 */
	Page buscarContratosCliente(DtoBuscarContrato dto);

	/**
	 * Busca el contrato de un cliente.
	 * 
	 * @param dto
	 *            dto de busqueda
	 * @return una lista que contiene el contrato de pase.
	 */
	HashMap<String, Object> buscarTotalContratosCliente(DtoBuscarContrato dto);

	/**
	 * PBO: 28/11/12 Se usaba acoplado desde el plugin de UNNIM. Se copia desde
	 * el plugin de UNNIM y se adapta para poder desenchufarlo
	 */
	Page buscarContratosPaginadosAvanzado(EXTBusquedaContratosDto dto,
			Usuario usuLogado);

	/**
	 * Cántidad de contratos retornado por la búsqueda.
	 * 
	 * @param dto
	 *            BusquedaContratosDto: con los parámetros de búsqueda
	 * @return int
	 */
	int buscarContratosPaginadosCount(EXTBusquedaContratosDto dto,
			Usuario usuLogado);
}
