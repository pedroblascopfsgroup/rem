package es.pfsgroup.plugin.rem.api;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIMetaServiceException;

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
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

}
