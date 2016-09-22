package es.pfsgroup.plugin.rem.api;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIMetaServiceException;

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.GMPDJB13_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu;
import es.cajamadrid.servicios.GM.GMPETS07_INS.GMPETS07_INS;
import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;

/**
 * Interface operaciones UVEM
 * 
 * @author rllinares
 *
 */
public interface UvemManagerApi {

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

	/**
	 * Servicio que a partir del nº y tipo de documento, así como Entidad del
	 * Cliente (y tipo) devolverá el/los nº cliente/s Ursus coincidentes
	 * 
	 * @param nudnio:
	 *            Documento según lo expresado en COCLDO. DNI, CIF, etc
	 * @param cocldo:
	 *            Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param idclow:
	 *            Identificador Cliente Oferta
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 */
	public void ejecutarNumCliente(String nudnio, String cocldo, String qcenre) throws WIException;

	/**
	 * 
	 */
	public GMPAJC11_INS resultadoNumCliente();

	/**
	 * Servicio REM  UVEM para que a partir del nº cliente URSUS se devuelvan
	 * los datos del mismo, tanto identificativos como de cara a poder dar
	 * cumplimiento a la normativa relativa a PBC.
	 * 
	 * @param idclow:
	 *            Identificador Cliente Oferta
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 */
	public void ejecutarDatosCliente(Long idclow, String qcenre)  throws WIException;

	/**
	 * 
	 */
	public GMPAJC93_INS resultadoDatosCliente();

	/**
	 * Servicio REM  UVEM para que a partir del codigoDeOfertaHaya, tipoPropuesta(1Venta/3Contraoferta) y
	 * indicadorDeFinanciacionCliente(S/N) se determine el comite decisor que debe resolver una oferta/propuesta
	 * según aplicación de la política de FFDD vigente en Bankia.
	 */
	public 	void consultarInstanciaDecision(String codigoDeOfertaHaya,
											short tipoPropuesta,
											char indicadorDeFinanciacionCliente) throws WIException;
	
	/**
	 * Servicio REM  UVEM para dar de alta la oferta en el sistema de Bankia,
	 * a partir del codigoDeOfertaHaya, tipoPropuesta(1Venta/3Contraoferta),
	 * indicadorDeFinanciacionCliente(S/N) y el vector numeroDeOcurrencias (importe,moneda,impuesto...).
	 */
	public 	void altaInstanciaDecision(String codigoDeOfertaHaya,
			short tipoPropuesta,
			char indicadorDeFinanciacionCliente,
			VectorGMPDJB13_INS_NumeroDeOcurrenciasnumocu numeroDeOcurrencias) throws WIException;
	
	/**
	 * 
	 */
	public GMPDJB13_INS resultadoConsultarInstanciaDecision();

	/**
	 * 
	 */
	public GMPDJB13_INS resultadoAltaInstanciaDecision();

}
