package es.capgemini.pfs.batch.recobro.reparto.manager;

import java.util.Date;

/**
 * Interfaz de métodos del manager de historico de reparto
 * @author javier
 *
 */
public interface RecobroRepartoManager {
	
	/**
	 * Obtiene la fecha de entrada de un contrato en una agencia/subcartera según la tabla de historico de reparto
	 * @param cntId, id del contrato
	 * @param ageId, id de la agencia
	 * @param subId, id de la subcartera
	 * @return Primera fecha de reparto del contrato para la correspondiente agencia/subcartera
	 */
	public Date FechaEntradaCntAgeSub(long cntId, long ageId, long subId);
	
	/**
	 * Devuelve el número de clientes repartidos a la agencia especificada
	 * @param fechaHistorico
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Long getCountClientes(Date fechaHistorico, Long agenciaId);	
	
	/**
	 * Devuelve el número de contratos repartidos a la agencia especificada
	 * @param fechaHistorico 
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Long getCountContratos(Date fechaHistorico, Long agenciaId);
	
	/**
	 * Devuelve el sumatorio del saldo irregular de los contratos repartidos a la agencia especificadaç
	 * @param fechaHistorico 
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Double getSaldoIrregular(Date fechaHistorico, Long agenciaId);	
	
	/**
	 * Devuelve el sumatorio del saldo vivo de los contratos repartidos a la agencia especificada
	 * @param fechaHistorico 
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @return
	 */
	public Double getSaldoVivo(Date fechaHistorico, Long agenciaId);
	
	/**
	 * Devuelve la fecha del registro mas joven del historico de reparto
	 * @return
	 */
	public Date getFechaUltimoHistoricoReparto();
	
	/**
	 * Devuelve el número de clientes repartidos a la agencia especificada
	 * @param fechaHistorico
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Long getCountClientes(Date fechaHistorico, Long agenciaId, Long subCarteraId);	
	
	/**
	 * Devuelve el número de contratos repartidos a la agencia especificada
	 * @param fechaHistorico 
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Long getCountContratos(Date fechaHistorico, Long agenciaId, Long subCarteraId);
	
	/**
	 * Devuelve el sumatorio del saldo irregular de los contratos repartidos a la agencia especificadaç
	 * @param fechaHistorico 
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Double getSaldoIrregular(Date fechaHistorico, Long agenciaId, Long subCarteraId);	
	
	/**
	 * Devuelve el sumatorio del saldo vivo de los contratos repartidos a la agencia especificada
	 * @param fechaHistorico 
	 * @param agenciaId, si es null, se devuelve el total de todas las agencias
	 * @param subCarteraId
	 * @return
	 */
	public Double getSaldoVivo(Date fechaHistorico, Long agenciaId, Long subCarteraId);
	
}
