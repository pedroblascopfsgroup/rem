package es.capgemini.pfs.contrato.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * contratos.
 * @author mtorrado
 *
 */

public interface ContratoDao extends AbstractDao<Contrato, Long> {

    /**
     * Devuelve la última fecha de carga.
     * Es la que se muestra arriba a la derecha en la pantalla principal.
     * @return la última fecha de carga
     */
    Date getUltimaFechaCarga();

    /**
     * Busca el contrato de un expediente.
     * @param dto dto de busqueda
     * @return una lista que contiene el contrato de pase.
     */
    Page buscarContratosExpediente(DtoBuscarContrato dto);

    /**
     * Busca el contrato de un cliente.
     * @param dto dto de busqueda
     * @return una lista que contiene el contrato de pase.
     */
    Page buscarContratosCliente(DtoBuscarContrato dto);

    /**
     * Busca el contrato de un cliente.
     * @param dto dto de busqueda
     * @return una lista que contiene el contrato de pase.
     */
    HashMap<String, Object> buscarTotalContratosCliente(DtoBuscarContrato dto);

    /**
     * obtiene todos los contratos para la generaracion de expediente manual.
     * @param idPersona idPersona
     * @return contratos
     */
    List<Contrato> obtenerContratosPersonaParaGeneracionExpManual(Long idPersona);

    /**
     * Devuelve los clientes que están relacionados con alguno de los contratos de la lista.
     * @param contratos la lista de contratos
     * @return List Persona: el listado de clientes.
     */
    List<Persona> buscarClientesDeContratos(String[] contratos);

    /**
     * Hace la búsqueda de contratos de acuerdo a los filtros.
     * @param dto los filtros
     * @return la lista de contrtos que cumplen los filtros.
     */
    Page buscarContratosPaginados(BusquedaContratosDto dto);

    /**
     * Cántidad de contratos retornado por la búsqueda.
     * @param dto BusquedaContratosDto: con los parámetros de búsqueda
     * @return int
     */
    int buscarContratosPaginadosCount(BusquedaContratosDto dto);

    /**
     * Busca el ExpedienteContrato a partir del contrato.
     * @param idContrato el id del contrato
     * @return el ExpedienteContrato
     */
    ExpedienteContrato buscarExpedienteContrato(Long idContrato);

    /**
     * Busca el ExpedienteContrato a partir del contrato y el expediente.
     * @param idContrato el id del contrato
     * @param idExpediente el id del expediente
     * @return el ExpedienteContrato
     */
    ExpedienteContrato buscarExpedienteContratoByContratoExpediente(Long idContrato, Long idExpediente);

    /**
     * @param ids String: ids separados por coma
     * @return List Contrato: contratos con los ids pasados
     */
    List<Contrato> getContratosById(String ids);

    /**
     * Devuelve los títulos de un contrato paginados.
     * @param dto el id del contrato
     * @return los títulos del contrato.
     */
    Page getTitulosContratoPaginado(DtoBuscarContrato dto);

    /**
     * busca los expedientes en los que esté o haya estado el contrato.
     * @param idContrato el id del contrato.
     * @return la lista de expedientes.
     */
    List<Expediente> buscarExpedientesHistoricosContrato(Long idContrato);

    /**
     * busca los contratos expedientes en los que esté o haya estado el contrato.
     * @param idContrato el id del contrato.
     * @return la lista de expedientes.
     */
    List<ExpedienteContrato> buscarContratosExpedientesHistoricosContrato(Long idContrato);
    
    
    /**
     * devuelve el contador de reincidencias de un contrato.
     * @param idContrato el id del contrato.
     * @return la lista de expedientes.
     */
    Integer contadorReincidencias(Long idContrato);
    
}
