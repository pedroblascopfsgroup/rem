package es.capgemini.pfs.persona.dao;

import java.util.List;

import es.capgemini.devon.files.CursorReadCallBack;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.ingreso.model.Ingreso;
import es.capgemini.pfs.persona.model.Persona;

/**
 * dao de persona.
 * @author jbosnjak
 *
 */
public interface PersonaDao extends AbstractDao<Persona, Long> {

    String BUSQUEDA_PRIMER_TITULAR = "PTIT";

    String BUSQUEDA_TITULARES = "TIT";

    String BUSQUEDA_AVALISTAS = "AVAL";

    String BUSQUEDA_RIESGO_DIRECTO = "riesgoDirecto";
    String BUSQUEDA_RIESGO_INDIRECTO = "riesgoIndirecto";
    String BUSQUEDA_RIESGO_TOTAL = "riesgoTotal";

    /**
     * getbienes.
     * @param id id
     * @return bien
     */
    List<Bien> getBienes(Long id);

    /**
     * get ingresos.
     * @param id id
     * @return ingreso
     */
    List<Ingreso> getIngresos(Long id);

    /**
     * Retorna los clientes que cumplan con los parámetros pasados.
     * @param clientes DtoBuscarClientes Campos con los que tiene que coincidir la búsqueda
     * @return lista de clientes
     */
    List<Persona> findClientes(DtoBuscarClientes clientes);

    /**
     * Retorna paginado los clientes que cumplan con los parï¿½metros pasados.
     * @param clientes DtoBuscarClientes Campos con los que tiene que coincidir la BÃºsqueda
     * @return Page página con los clientes
     */
    Page findClientesPaginated(DtoBuscarClientes clientes);

    /**
     * Devuelve un export de clientes.
     * @param clientes cliente
     * @param callback callback
     */
    void exportClientes(DtoBuscarClientes clientes, final CursorReadCallBack callback);

    /**
     * obtiene si tiene un expediente propuesto.
     * @param idPersona id de la persona
     * @return id del expediente
     */
    Long obtenerIdExpedientePropuestoPersona(Long idPersona);

    /**
     * obtiene si tiene un expediente propuesto.
     * @param idPersona id de la persona
     * @return Expediente
     */
    Expediente obtenerExpedientePropuestoPersona(Long idPersona);

    /**
     * obtenerCantidadDeVencidosUsuario.
     * @param clientes param
     * @return cantidad
     */
    Long obtenerCantidadDeVencidosUsuario(DtoBuscarClientes clientes);

    /**
     * Recupera la lista de contratos disponibles de la persona indicada para un futuro cliente.
     * El ultimo contrato es el contrato de pase.
     * @param personaId Long
     * @return lista de contratos.
     */
    List<Contrato> obtenerContratosParaFuturoCliente(Long personaId);

    /**
     * getByCodigo.
     * @param codigo codigo
     * @return persona
     */
    Persona getByCodigo(String codigo);

    /**
     * Obtiene si lo hubiere el expediente (no borrado) de la persona en la
     * que uno de sus contratos en los que es titular es el de pase.
     * @param idPersona Long
     * @return Expediente
     */
    Expediente getExpedienteConContratoPaseTitular(Long idPersona);

    /**
     * Retorna el cliente activo de la persona, refrezcando la sesión hibernate antes
     * para que tome el cliente recién creado en el flow.
     * @param idPersona Long
     * @return Cliente
     */
    Cliente getClienteActivo(Long idPersona);

    /**
     * Recupera el número de contratos que cumplen que pueden ser contratos de futuro cliente para la persona de pase
     * @param personaId
     * @return
     */
    Long getContratosParaFuturoCliente(Long personaId);

}
