package es.capgemini.pfs.batch.recobro.reparto.dao;

import java.util.Date;

import es.capgemini.pfs.batch.recobro.reparto.model.HistoricoReparto;
import es.capgemini.pfs.dao.AbstractDao;

public interface RecobroRepartoDao extends AbstractDao<HistoricoReparto, Long> {

	/**
	 * Obtiene la menor fecha de un contrato en una agencia/subcartera según la tabla de historico de reparto
	 * @param cntId, id del contrato
	 * @param ageId, id de la agencia
	 * @param subId, id de la subcartera
	 * @return Menor fecha de reparto del contrato para la correspondiente agencia/subcartera
	 */	
	public Date getMinFechaCntAgeSubHistReparto(long cntId, long ageId, long subId);
	
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
	 * Devuelve el sumatorio del saldo irregular de los contratos repartidos a la agencia especificada
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
	 * Devuelve la fecha del último registro del histórico de reparto
	 * @return
	 */
	public Date getFechaUltimoRepartoHistorico();
	
	
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
	 * Devuelve el sumatorio del saldo irregular de los contratos repartidos a la agencia especificada
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
