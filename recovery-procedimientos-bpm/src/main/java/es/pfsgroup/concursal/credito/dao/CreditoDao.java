package es.pfsgroup.concursal.credito.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.concursal.credito.model.Credito;

public interface CreditoDao extends AbstractDao<Credito, Long>{

	/**
	 * Devuelve los créditos asociados a un contrato y un procedimiento.
	 * @param idExpedienteContrato Tenemos que pasar el id de la relación ExpedienteContrato
	 * @param idProcedimiento
	 * @return
	 */
	public List<Credito> findByContratoProcedimiento(Long idExpedienteContrato, Long idProcedimiento);
	
	public List<Credito> findByContratoProcedimientoDefinitivos(Long idExpedienteContrato, Long idProcedimiento);

}
