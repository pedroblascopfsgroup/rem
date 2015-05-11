package es.capgemini.pfs.batch.revisar.contratos;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;

import es.capgemini.pfs.batch.revisar.contratos.dao.ContratosBatchDao;

/**
 * Clase manager para la entidad contratos.
 * @author mtorrado
 *
 */
public class ContratosBatchManager {

    @Autowired
    private ContratosBatchDao contratosDao;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Guarda un registro de la última recuperación de un contrato con su saldo
     * (ver BATCH-41).
     *
     * @param cntId Long
     * @param cliId Long
     * @param expId Long
     * @param asuId Long
     * @param diff Double: diferencia de importes
     */
    public void registrarRecuperacion(Long cntId, Long cliId, Long expId, Long asuId, Double diff) {
        logger.debug("Iniciando recuperación del contrato con id: " + cntId);
        contratosDao.registrarRecuperacion(cntId, cliId, expId, asuId, diff);
    }

    /**
     * existeRecuperacion.
     * @param cntId Long
     * @param fecha Date
     * @return boolean
     */
    public boolean existeRecuperacion(Long cntId, Date fecha) {
        try {
            contratosDao.buscarIdRecuperacion(cntId, fecha);
        } catch (EmptyResultDataAccessException e) {
            return false;
        }
        return true;
    }

    /**
     * De los contratos indicado retorna la menor fecha de posición vendida, es
     * decir, la primera en el tiempo.
     *
     * @param contratosId lista
     * @return Date mayor fecha de posición vencida
     */
    public Date buscarFechaPosVencida(List<Long> contratosId) {
        return contratosDao.buscarFechaPosVencida(contratosId);
    }

    /**
     * Busca los titulares de contratos vencidos para la fecha indicada.
     *
     * @return List
     */
    public List<Long> buscarFuturosClientes() {
        return contratosDao.buscarFuturosClientes();
    }

    /**
     * Retorna el Id de la recuperacion para un contrato.
     *
     * @param cntId
     *            Long: id del contrato
     * @param fecha
     *            Date: de extraccion
     * @return Long: id de la recuperacion
     */
    public Long buscarIdRecuperacion(Long cntId, Date fecha) {
        return contratosDao.buscarIdRecuperacion(cntId, fecha);
    }

    /**
     * Retorna la recuperacion para un contrato.
     *
     * @param cntId
     *            Long: id del contrato
     * @param fecha
     *            Date: fecha de extraccion
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
    public Map<String, Object> buscarRecuperacion(Long cntId, Date fecha) {
        return contratosDao.buscarRecuperacion(cntId, fecha);
    }

    /**
     * Obtiene el saldo original del asunto pasado, de la tabla
     * prc_procedimientos.
     *
     * @param asuntoId Long
     * @param contratoId Long
     * @return Double: Saldo original
     */
    public Double buscarSaldoProcedimientoAsunto(Long asuntoId, Long contratoId) {
        return contratosDao.buscarSaldoProcedimientoAsunto(asuntoId, contratoId);
    }
}
