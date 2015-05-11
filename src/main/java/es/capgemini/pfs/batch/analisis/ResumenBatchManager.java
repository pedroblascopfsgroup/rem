package es.capgemini.pfs.batch.analisis;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.analisisExterna.model.DDPlazoAceptacion;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.batch.analisis.dao.ResumenDao;
import es.capgemini.pfs.cobropago.model.DDTipoCobroPago;

/**
 * Clase manager de la entidad Mapa Global (resumen).
 *
 * @author lgiavedoni
 *
 */
public class ResumenBatchManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ResumenDao resumenDao;

    /**
     * Realiza el analisis de los datos según los argumentos indicados.
     * @param args Object[]
     * @return Long
     */
    public Long realizarAnalisis(Object[] args) {
        logger.debug("Ejecutando resumenDao.realizarAnalisis con los siguientes argumentos: " + args);
        Long result = resumenDao.realizarAnalisis(args);
        logger.info("Se ha realizado el analisis con los parametros [" + args + "] y se han insertado [" + result + "] registros");
        return result;

    }

    /**
     * Borra el analisis para la fecha indicada.
     * @param fechaExtraccion Date
     * @return Long
     */
    public Long borrarAnalisis(Date fechaExtraccion) {
        logger.debug("Ejecutando resumenDao.borrarAnalisis con la siguiente fecha: " + fechaExtraccion);
        Long result = resumenDao.borrarAnalisis(fechaExtraccion);
        logger.info("Se han borrado [" + result + "] registros de analisis para la fecha [" + fechaExtraccion + "]");
        return result;
    }

    @Transactional(readOnly = true)
    public void realizaAnalisisExterna() {
        Date fechaProcesado = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

        logger.debug("Ejecutando resumenDao.borrarAnalisisExterna con la siguiente fecha: " + fechaProcesado);
        Long result = resumenDao.borrarAnalisisExterna(fechaProcesado);
        logger.info("Se han borrado [" + result + "] registros de analisis externa para la fecha [" + fechaProcesado + "]");

        Object[] args = { df.format(fechaProcesado), DDTipoCobroPago.CODIGO_COBRO, DDPlazoAceptacion.CODIGO_PLAZO_MENOR_3_MESES,
                DDPlazoAceptacion.CODIGO_PLAZO_MENOR_6_MESES, DDPlazoAceptacion.CODIGO_PLAZO_MENOR_12_MESES,
                DDPlazoAceptacion.CODIGO_PLAZO_MENOR_24_MESES, DDPlazoAceptacion.CODIGO_PLAZO_MAYOR_24_MESES,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO,
                DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO };

        logger.debug("Ejecutando resumenDao.realizarAnalisisExterna con los siguientes argumentos: " + args);
        result = resumenDao.realizarAnalisisExterna(args);
        logger.info("Se ha realizado el analisis de externa con los parametros [" + args + "] y se han insertado [" + result + "] registros");
    }

}
