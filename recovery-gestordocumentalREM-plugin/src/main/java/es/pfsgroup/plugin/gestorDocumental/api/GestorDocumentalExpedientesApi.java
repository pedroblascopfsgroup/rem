package es.pfsgroup.plugin.gestorDocumental.api;

import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadCompradorDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearActuacionTecnicaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearConductasInapropiadasDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearExpedienteComercialDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearJuntaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPlusvaliaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearProyectoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearTributoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearProveedorDto;
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

	RespuestaCrearExpediente crearActuacionTecnica(CrearActuacionTecnicaDto crearActuacionTecnicaDto) throws GestorDocumentalException;	
	
	RespuestaCrearExpediente crearJunta(CrearJuntaDto crearJuntaDto) throws GestorDocumentalException;

	RespuestaCrearExpediente crearPlusvalia(CrearPlusvaliaDto crearPlusvaliaDto) throws GestorDocumentalException;

	RespuestaCrearExpediente crearTributo(CrearTributoDto crearGasto) throws GestorDocumentalException;

	RespuestaCrearExpediente crearProyecto(CrearProyectoDto crearProyecto) throws GestorDocumentalException;	

	RespuestaCrearExpediente crearProveedor(CrearProveedorDto crearProveedorDto) throws GestorDocumentalException;	
	
	RespuestaCrearExpediente crearConductasInapropiadas(CrearConductasInapropiadasDto crearConductasInapropiadasDto) throws GestorDocumentalException;
}
