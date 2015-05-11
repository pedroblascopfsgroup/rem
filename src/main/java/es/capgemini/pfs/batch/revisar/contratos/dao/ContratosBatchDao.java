package es.capgemini.pfs.batch.revisar.contratos.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Required;

/**
 * Clase que contiene los métodos de acceso a bbdd para la entidad Contratos.
 *
 * @author mtorrado
 *
 */

public interface ContratosBatchDao {

    /**
     * De los contratos indicado retorna la menor fecha de posición vendida, es
     * decir, la primera en el tiempo.
     *
     * @param contratosId lista
     * @return Date mayor fecha de posición vencida
     */
    Date buscarFechaPosVencida(List<Long> contratosId);

    /**
     * Busca los titulares de contratos vencidos para la fecha indicada.
     * @return List
     */
    List<Long> buscarFuturosClientes();

    /**
     * registrarRecuperacion.
     *
     * @param cntId Long
     * @param cliId Long
     * @param expId Long
     * @param asuId Long
     * @param importeRecuperado Double
     */
    void registrarRecuperacion(Long cntId, Long cliId, Long expId, Long asuId, Double importeRecuperado);

    /**
     * Retorna el Id de la recuperacion para un contrato.
     *
     * @param cntId Long: id del contrato
     * @param fecha Date: de extraccion
     * @return Long: id de la recuperacion
     */
    Long buscarIdRecuperacion(Long cntId, Date fecha);

    /**
     * Retorna la recuperacion para un contrato.
     *
     * @param cntId Long: id del contrato
     * @param fecha Date: fecha de extraccion
     * @return Map con el siguiente contenido.
     *         <ul>
     *         <li>id Long: Id recuperación</li>
     *         <li>contratoId Long: Id del contrato</li>
     *         <li>asuntoId Long: Id del asunto</li>
     *         <li>expId Long: Id del expediente</li>
     *         <li>clienteId Long: Id del cliente</li>
     *         <li>fechaEntrega Date: fecha de entrega</li>
     *         <li>importeEntregado BigDecimal: Importe entregado</li>
     *         <li>importeRecuperado BigDecimal: Importe recuperado</li>
     *         </ul>
     */
    Map<String, Object> buscarRecuperacion(Long cntId, Date fecha);

    /**
     * Obtiene el saldo original del asunto pasado, de la tabla
     * prc_procedimientos.
     *
     * @param asuntoId Long
     * @param contratoId Long
     * @return Double: Saldo original
     */
    Double buscarSaldoProcedimientoAsunto(Long asuntoId, Long contratoId);

    /*------------------------------
     * Setters
     *------------------------------*/

    /**
     * @param dataSource
     *            Base de datos
     */
    @Required
    void setDataSource(DataSource dataSource);

    /**
     * @param registrarRecuperacionQuery
     *            the registrarRecuperacionQuery to set
     */
    void setRegistrarRecuperacionQuery(String registrarRecuperacionQuery);

    /**
     * @param buscarFechaPosVencidaParaContratosQuery
     *            the buscarFechaPosVencidaParaContratosQuery to set
     */
    void setBuscarFechaPosVencidaParaContratosQuery(String buscarFechaPosVencidaParaContratosQuery);

    /**
     * @param buscarSaldoProcedimientoAsuntoQuery
     *            the buscarSaldoProcedimientoAsuntoQuery to set
     */
    void setBuscarSaldoProcedimientoAsuntoQuery(String buscarSaldoProcedimientoAsuntoQuery);

    /**
     * @param buscarRecuperacionesQuery
     *            the buscarRecuperacionesQuery to set
     */
    void setBuscarRecuperacionesQuery(String buscarRecuperacionesQuery);

    /**
     * @param buscarIdRecuperacionesQuery
     *            the buscarIdRecuperacionesQuery to set
     */
    void setBuscarIdRecuperacionesQuery(String buscarIdRecuperacionesQuery);

    /**
     * @param buscarFuturosClientesQuery
     *            the buscarFuturosClientesQuery to set
     */
    void setBuscarFuturosClientesQuery(String buscarFuturosClientesQuery);
}
