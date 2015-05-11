package es.capgemini.pfs.expediente.dao;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.dto.DtoListadoExpedientes;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que agrupa mï¿½todo para la creaciï¿½n y acceso de datos de los
 * expedientes.
 * @author mtorrado
 */

public interface ExpedienteDao extends AbstractDao<Expediente, Long> {

    /**
     * Verifica que no exista expedientes para ese contrato.
     * @param expediente DtoBuscarExpedientes
     * @return List
     */
    List<ExpedienteContrato> findExpedientesContrato(DtoBuscarExpedientes expediente);

    /**
     * Devuelve los ExpedienteContratos de un expediente para los contratos activos y pasivos vencidos.
     * @param idExpediente id del expediente
     * @return List
     */
    List<ExpedienteContrato> findContratosExpediente(Long idExpediente);
    /**
     * Devuelve los ExpedienteContratos de un expediente a partir de un riesgo
     * @param idExpediente id del expediente
     * @param riesgo riesgo mínimo. Si se pasa null, no se evalua el riesgo
     * @return List
     */
    List<ExpedienteContrato> findContratosExpediente(Long idExpediente, BigDecimal riesgo);
    /**
     * @param idExpediente Long
     * @return Todos los contratos relacionados del expediente,
     * con archivos adjuntos
     */
    List<Persona> findContratosConAdjuntos(Long idExpediente);

    /**
     * @param expediente DtoBuscarExpedientes
     * @return List
     */
    List<String> obtenerSupervisorGeneracionExpediente(DtoBuscarExpedientes expediente);

    /**
     * Realiza la Búsqueda paginada de expedientes a acuerdo a un filtro que se le pasa
     * como parámetro.
     * @param expediente DtoBuscarExpedientes
     * @return List lista de expedientes
     */
    Page buscarExpedientesPaginado(DtoBuscarExpedientes expediente);
    
    /**
     * Realiza la Búsqueda paginada de expedientes a acuerdo a un filtro dinámico que se le pasa
     * como parámetro.
     * @param dtoExpediente
     * @param usuarioLoguead
     * @param params
     * @return List lista de expedientes
     */
    Page buscarExpedientesPaginadoDinamico(DtoBuscarExpedientes dtoExpediente,Usuario usuarioLogueado,String params);

    /**
     * Obtiene los expedientes de una persona que no estÃ¡n borrados (pero si trae los que estÃ¡n cancelados).
     * @param idPersona id Persona
     * @return expedientes
     */
    List<Expediente> obtenerExpedientesDeUnaPersona(Long idPersona);

    /**
     * Obtiene los expedientes de una persona que no estÃ¡n borrados ni cancelados.
     * @param idPersona id Persona
     * @return expedientes
     */
    List<Long> obtenerExpedientesDeUnaPersonaNoCancelados(Long idPersona);

    /**
     * @param id Long: id del expediente
     * @return Todas las personas que tienen contratos relacionados del expediente
     */
    List<Persona> findPersonasContratosExpediente(Long id);

    /**
     * @param id Long: id del expediente
     * @return Todas las personas que tienen contratos relacionados del expediente,
     * con archivos adjuntos
     */
    List<Persona> findPersonasContratosConAdjuntos(Long id);

    /**
     * @param id Long: id del expediente
     * @return Todas las personas titulares de los contratos relacionados del expediente
     */
    List<Persona> findPersonasTitContratosExpediente(Long id);

    /**
     * Obtiene el expediente activo, congelado o bloqueado en que esta el contrato.
     * @param idContrato long
     * @return Expediente
     */
    Expediente buscarExpedientesParaContrato(Long idContrato);

    /**
     * Obtiene el expediente de seguimiento activo, congelado o bloqueado en que esta la persona.
     * @param idPersona long
     * @return Expediente
     */
    Expediente buscarExpedientesSeguimientoParaPersona(Long idPersona);

    /**
     * Devuelve los contratos relacionados con el grupo de personas del cliente de pase.
     * @param contratosExpediente la lista de contratos de expediente
     * @param idPersona Persona que generó el pase
     * @return la lista de contratos de grupo
     */
    List<Long> obtenerContratosRelacionadosExpedienteGrupo(List<Long> contratosExpediente, Long idPersona);

    /**
     * Devuelve los contratos relacionados con la primera generación.
     * @param contratosExpediente la lista de contratos de expediente
     * @return la lista de contratos de primera generación
     */
    List<Long> obtenerContratosRelacionadosExpedientePrimeraGeneracion(List<Long> contratosExpediente);

    /**
     * Devuelve los contratos relacionados con la segunda generación.
     * @param contratosExpediente la lista de contratos de expediente
     * @return la lista de contratos de primera generación
     */
    List<Long> obtenerContratosRelacionadosExpedienteSegundaGeneracion(List<Long> contratosExpediente);

    /**
     * Devuelve las personas relacionadas con el grupo de personas del cliente de pase.
     * @param idPersona Persona que generó el pase
     * @return la lista de personas de grupo
     */
    List<Long> obtenerPersonasRelacionadosExpedienteGrupo(Long idPersona);

    /**
     * Devuelve las personas relacionadas con la primera generación.
     * @param personasExpediente la lista de personas de expediente
     * @return la lista de personas de primera generación
     */
    List<Long> obtenerPersonasRelacionadosExpedientePrimeraGeneracion(List<Long> personasExpediente);

    /**
     * Devuelve las personas relacionadas con la segunda generación.
     * @param personasExpediente la lista de personas de expediente
     * @return la lista de personas de primera generación
     */
    List<Long> obtenerPersonasRelacionadosExpedienteSegundaGeneracion(List<Long> personasExpediente);

    /**
     * Devuelve el listado de las personas involucradas en los contratos (las personas serán titulares de contrato).
     * @param idPersona idPersona de Pase (no hay que incluirla en el vector)
     * @param idContrato idContrato de Pase
     * @param contratosAdicionales Listado de contratos de los que se desea extraer las personas
     * @param limitePersonas integer
     * @return Listado de personas
     */
    List<Long> obtenerPersonasDeContratos(Long idPersona, Long idContrato, List<Long> contratosAdicionales, Integer limitePersonas);

    /**
     * Devuelve el listado de los contratos involucradas en las personas (las personas serán titulares de contrato).
     * @param idContrato idContrato de Pase (no hay que incluirlo en el vector)
     * @param idPersona idPersona de Pase
     * @param personasAdicionales Listado de personas de los que se desea extraer los contratos
     * @param limiteContratos integer
     * @return Listado de personas
     */
    List<Long> obtenerContratosDePersonas(Long idContrato, Long idPersona, List<Long> personasAdicionales, Integer limiteContratos);

    /**
     * Devuelve un listado de las reglas que deben cumplirse en la elevación de un expediente dado un estado del itinerario.
     * @param estado Estado del itinerario donde se encuentra el expediente
     * @return Un listado de reglas
     */
    List<ReglasElevacion> getReglasElevacion(Estado estado);

    /**
     * Recupera el número de expedientes activos de recuperación o seguimiento
     * @param isRecuperacion
     * @return
     */
    Long getNumExpedientesActivos(Long idPersona, Boolean isRecuperacion);

    /**
     * Obtiene los expedientes de una persona paginados
     * @param dto
     * @return
     */
    Page obtenerExpedientesDeUnaPersonaPaginados(DtoListadoExpedientes dto);
}
