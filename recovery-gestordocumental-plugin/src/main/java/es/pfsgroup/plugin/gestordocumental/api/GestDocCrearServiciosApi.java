package es.pfsgroup.plugin.gestordocumental.api;

import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGarantiaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearLoanDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearOperacionDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPropuestaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearRelacionDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearReoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.ModificarExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;

public interface GestDocCrearServiciosApi {

	RespuestaGeneral crearRelacion(CrearRelacionDto crearRelacion) throws GestorDocumentalException;

	RespuestaCrearExpediente crearReo(CrearReoDto crearReo) throws GestorDocumentalException;

	RespuestaCrearExpediente crearLoan(CrearLoanDto crearLoan) throws GestorDocumentalException;

	RespuestaCrearExpediente crearGarantia(CrearGarantiaDto crearGarantia) throws GestorDocumentalException;

	RespuestaCrearExpediente crearEntidad(CrearEntidadDto crearEntidad) throws GestorDocumentalException;

	RespuestaCrearExpediente crearPropuesta(CrearPropuestaDto crearPropuesta) throws GestorDocumentalException;

	RespuestaCrearExpediente crearOperacion(CrearOperacionDto crearOperacion) throws GestorDocumentalException;

	RespuestaCrearExpediente modificarExpediente(ModificarExpedienteDto modificarExpediente) throws GestorDocumentalException;

}