package es.pfsgroup.plugin.gestorDocumental.api;

import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadCompradorDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearExpedienteComercialDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;

public interface GestorDocumentalExpedientesApi {

	/**
	 * Permite crear un expediente de gastos en función de la clase expediente
	 * @param crearGasto
	 * @return
	 * @throws GestorDocumentalException
	 */
	
	RespuestaCrearExpediente crearGasto(CrearGastoDto crearGasto) throws GestorDocumentalException;

	RespuestaCrearExpediente crearExpedienteComercial(CrearExpedienteComercialDto crearExpedienteComercialDto) throws GestorDocumentalException;

	RespuestaCrearExpediente crearActivoOferta(CrearEntidadCompradorDto crearActivoOferta) throws GestorDocumentalException;

}
