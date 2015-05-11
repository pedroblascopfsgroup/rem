package es.capgemini.pfs.batch.recobro.simulacion.dao;

import es.capgemini.pfs.batch.recobro.simulacion.model.TemporalRepartos;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz de métodos para el acceso a BBDD temporal reparto
 * @author javier
 *
 */
public interface TemporalRepartoDao extends AbstractDao<TemporalRepartos, Long> {

	/**
	 * Devuelve el número de clientes repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Long getCountClientes(Long agenciaId);
	
	/**
	 * Devuelve el número de contratos repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Long getCountContratos(Long agenciaId);
	
	/**
	 * Devuelve el sumatorio del saldo irregular de los contratos repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Double getSaldoIrregular(Long agenciaId);
	
	/**
	 * Devuelve el sumatorio del saldo vivo de los contratos repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Double getSaldoVivo(Long agenciaId);
	
	/**
	 * Devuelve el número de clientes repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Long getCountClientes(Long agenciaId, Long subCarteraId);
	
	/**
	 * Devuelve el número de contratos repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Long getCountContratos(Long agenciaId, Long subCarteraId);
	
	/**
	 * Devuelve el sumatorio del saldo irregular de los contratos repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Double getSaldoIrregular(Long agenciaId, Long subCarteraId);
	
	/**
	 * Devuelve el sumatorio del saldo vivo de los contratos repartidos a la agencia especificada
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Double getSaldoVivo(Long agenciaId, Long subCarteraId);

}
