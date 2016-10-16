package es.pfsgroup.plugin.rem.api;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIMetaServiceException;

import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPETS07_INS.GMPETS07_INS;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;

/**
 * Interface operaciones UVEM
 * 
 * @author rllinares
 *
 */
public interface UvemManagerApi {

	
	
/*******************************************TASACIONES***************************************************/
	
	/**
	 * Solicitar tasación de un bien
	 * 
	 * @param bienId
	 * @param nombreGestor
	 * @param gestion
	 * @return
	 * @throws WIMetaServiceException
	 * @throws WIException
	 * @throws TipoDeDatoException
	 */
	public Integer ejecutarSolicitarTasacion(Long bienId, String nombreGestor, String gestion)
			throws WIMetaServiceException, WIException, TipoDeDatoException;

	
	
	
	/**
	 * Obtiene el identificador de la tasacion
	 * 
	 * @return
	 */
	public GMPETS07_INS resultadoSolicitarTasacion();

	
	
	
	
	
/*******************************************CLIENTES URSUS***************************************************/
	
	/**
	 * 
	 * (DE CLIENTE SOLO DEBERIA USARSE ESTE)
	 * Devuelve los clientes partir de los datos pasados por parámetro
	 * 
	 * @param nDocumento: documento identificativo del cliente a consultar
	 * @param tipoDocumento:Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	DatosClienteDto ejecutarDatosClientePorDocumento(DtoClienteUrsus dtoCliente) throws Exception;
	
	
	
	/**
	 * Devuelve los clientes Ursus a partir de los datos pasados por parámetro
	 * 
	 * @param nDocumento: documento identificativo del cliente a consultar
	 * @param tipoDocumento:Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	public Integer obtenerNumClienteUrsus(String nDocumento, String tipoDocumento, String qcenre)  throws WIException;
	
	
	/**
	 * Devuelve los datos de un cliente Ursus a partir de los datos pasados por parámetro
	 * 
	 * @param nDocumento: documento identificativo del cliente a consultar
	 * @param tipoDocumento:Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	public GMPAJC93_INS obtenerDatosClienteUrsus(String nDocumento, String tipoDocumento, String qcenre)  throws WIException;
	

		
	/**
	 * Servicio GMPAJC11_INS que a partir del nº y tipo de documento, así como Entidad del
	 * Cliente (y tipo) devolverá el/los nº cliente/s Ursus coincidentes
	 * 
	 * @param nDocumento: Documento según lo expresado en COCLDO. DNI, CIF, etc
	 * @param tipoDocumento: Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	public Integer ejecutarNumCliente(String nDocumento, String tipoDocumento, String qcenre) throws Exception;


	/**
	 * Servicio GMPAJC93_INS que a partir del nº cliente URSUS se devuelvan
	 * los datos del mismo, tanto identificativos como de cara a poder dar
	 * cumplimiento a la normativa relativa a PBC.
	 * 
	 * @param numcliente: numero cliente Ursus (idclow)
	 * @param qcenre: Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia habitat 05021
	 */
	public DatosClienteDto ejecutarDatosCliente(Integer numcliente, String qcenre)  throws Exception;

	
	
	
	
	
/*******************************************INSTANCIA DECISION***************************************************/
	
	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para consultar una instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto consultarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws Exception;
	
	
	
	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para dar de alta un instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto altaInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws Exception;
	
	
	
	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para modificar una instancia de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto modificarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto) throws Exception;
	

	
	
	
	
	
/*******************************************CONSULTA PRESTAMO***************************************************/
	

	/**
	 * Invoca al servicio GMPAJC34_INS de BANKIA para consultar los datos de un prestamo
	 * 
	 * @param numExpedienteRiesgo12
	 * @param tipoRiesgo
	 * @return IMPORTE CONCEDIDO Multiplicado por 100 (para que no tenga decimales).
	 */
	public Long consultaDatosPrestamo(String numExpedienteRiesgo12, int tipoRiesgo) throws Exception;







}
