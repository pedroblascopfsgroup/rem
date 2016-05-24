package es.pfsgroup.plugin.recovery.mejoras.contrato.dao;

import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.mejoras.contrato.dto.MEJBusquedaContratosDto;

public interface MEJContratoDao extends AbstractDao<Contrato, Long>{

	Page buscarContratosCliente(DtoBuscarContrato dto);
	HashMap<String, Object> buscarTotalContratosCliente(DtoBuscarContrato dto);
	Page buscarContratosExpedienteSinAsignar(DtoBuscarContrato dto);
 
	/**
	 * PBO: Incorporado al desenchufar referencias a UNNIM
	 */
	public Page buscaContratosSinAsignar(Long idAsunto, List<Procedimiento> procedimientos, MEJBusquedaContratosDto dto);
	
	/**
	 * Obtiene un String, si lo hubiera, del estado de bloqueo de un contrato.
	 * 
	 * @param idContrato : id del contrato.
	 * @return un string con la descripcion del bloque, si lo hay. Si no devuelve null.
	 */
	public String getEstadoBloqueoContrato(Long idContrato);

}
