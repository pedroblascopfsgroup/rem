package es.pfsgroup.recovery.recobroCommon.contrato.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.contrato.dto.CicloRecobroContratoDto;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;

/**
 * Interfaz de métodos para la persistencia de los ciclos de recobro de contratos
 * @author Diana
 *
 */
public interface CicloRecobroContratoDao extends AbstractDao<CicloRecobroContrato, Long> {

	/**
	 * Obtiene una página de ciclos de recobro de contratos a partir de unos parámetros de entrada
	 * @param dto
	 * @return
	 */
	public Page getPage(CicloRecobroContratoDto dto);

	/**
	 * Obtener los ciclos de recobro de contratos por expediente y contrato
	 * @param idExpediente
	 * @param idContrato
	 * @return
	 */
	public List<CicloRecobroContrato> getCiclosRecobroContratoExpediente(
			Long idExpediente, Long idContrato);
	
	/**
	 * Obtener los ciclos de recobro de contratos por subcartera, agencia, fecha de inicio y fecha de fin
	 * @param idSubcartera
	 * @param idAgencia
	 * @param fechaInicio
	 * @param fechaFin
	 * @return
	 */
	public List<CicloRecobroContrato> getCiclosRecobroContratoPorAgenciaSubcarteraIntervaloFechas(
			Long idSubcartera, Long idAgencia, Date fechaInicio, Date fechaFin);
	
	
	/**
	 * Obtener los ciclos de recobro de las entradas de contratos por subcartera, agencia, fecha de inicio y fecha de fin
	 * @param idSubcartera
	 * @param idAgencia
	 * @param fechaInicio
	 * @param fechaFin
	 * @return
	 */
	public List<CicloRecobroContrato> getCiclosRecobroEntradasContratoPorAgenciaSubcarteraIntervaloFechas(
			Long idSubcartera, Long idAgencia, Date fechaInicio, Date fechaFin);

	/**
	 * Devuelve una lista de ciclos de recobro de contrato, en un expediente y para una agencia
	 * @param idExpediente
	 * @param idContrato
	 * @param idAgencia
	 * @return
	 */
	public List<CicloRecobroContrato> getCiclosRecobroContratoExpedienteAgencia(
			Long idExpediente, Long idContrato, Long idAgencia);

}
