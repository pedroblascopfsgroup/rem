package es.pfsgroup.plugin.precontencioso.burofax.manager;

import java.util.List;

import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;

public interface BurofaxCMApi {

	/**
	 * Configura el estado y el tipo de burofax de un envio (particularizado para Cajamar)
	 * 
	 * @param idTipoBurofax
	 * @param arrayIdDirecciones
	 * @param arrayIdBurofax
	 * @param arrayIdEnvios
	 * @param manual
	 * @return
	 */
	List<EnvioBurofaxPCO> configurarTipoBurofax(Long idTipoBurofax,String[] arrayIdDirecciones,String[] arrayIdBurofax,String[] arrayIdEnvios, 
			Boolean manual);


	/**
	 * Guarda toda la información cuando se realiza el envio de un burofax (particularizado para Cajamar)
	 * 
	 * @param certificado
	 * @param listaEnvioBurofaxPCO
	 * @param codigoPropietaria
	 * @param localidadFirma
	 * @param notario
	 */
	void guardarEnvioBurofax(Boolean certificado, List<EnvioBurofaxPCO> listaEnvioBurofaxPCO, 
			String codigoPropietaria, String localidadFirma, String notario);

}
