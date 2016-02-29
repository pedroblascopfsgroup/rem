package es.capgemini.pfs.metrica;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.alerta.dao.NivelGravedadDao;
import es.capgemini.pfs.alerta.dao.TipoAlertaDao;
import es.capgemini.pfs.alerta.model.NivelGravedad;
import es.capgemini.pfs.alerta.model.TipoAlerta;
import es.capgemini.pfs.metrica.dao.MetricaDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.dto.DtoMetricaPorAlerta;
import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.metrica.model.MetricaTipoAlerta;
import es.capgemini.pfs.metrica.model.MetricaTipoAlertaGravedad;
import es.capgemini.pfs.segmento.dao.SegmentoDao;

/**
 * Esta clase sabe como validar el archivo CSV de métricas
 * y si se puede borrar una métrica.
 * @author aesteban
 */
@Service
public class MetricaValidator {

    @Autowired
    private TipoAlertaDao tipoAlertaDao;
    @Autowired
    private NivelGravedadDao nivelGravedadDao;
    @Autowired
    private MetricaDao metricaDao;
    @Autowired
    private SegmentoDao segmentoDao;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Valida si el archivo de métricas indicado en la construcción de la clase
     * tiene todos los datos necesarios para la carga.
     * @param dto DtoMetrica
     * @return true si el archivo es valido.
     */
    public boolean sePuedeCargar(DtoMetrica dto) {
        MetricaFileReader parser = new MetricaFileReader(dto.getFile());
        try {
            if (!validarCantidadFilas(parser)) {
            	return false;
            }
            if (!validarCodigoAlertas(parser)) {
                return false;
            }
            if (!validarCantidadNivelesGravedad(parser)) {
                return false;
            }
            if (!validarRangosNivelPreocupacion(parser)) {
                return false;
            }

            if (!validarRangosNivelesGravedad(parser)) {
                return false;
            }

            if (!todosLosRangosAlertasCubiertos(parser, dto)) {
                return false;
            }

            return true;
        } catch (IOException e) {
            throw new BusinessOperationException("metricas.archivo.error.lectura", dto.getFile().getAbsolutePath());
        }
    }

    /**
     * Valida que la cantidad de filas sea menor o igual a la cantidad de tipos de alertas.
     * @param parser
     * @return
     * @throws IOException
     */
    private boolean validarCantidadFilas(MetricaFileReader parser) throws IOException {
    	
    	int tamTabla = tipoAlertaDao.getList().size();
    	int tamFichero = parser.getRowCount();
    	boolean res = tamTabla >= tamFichero;
    	if(!res) {
    		logger.error("Método validarCantidadFilas. El número de filas de la tabla TAL_TIPO_ALERTA (" + tamTabla + ") es menor que el número de filas del fichero (" + tamFichero + ")");
    	}
    	
        return res;

    }

    /**
     * Valida los codigos de los tipos de alertas del archivo.
     * @param parser
     * @return
     * @throws IOException
     */
    private boolean validarCodigoAlertas(MetricaFileReader parser) throws IOException {
        List<DtoMetricaPorAlerta> dtos;
        try {
            dtos = parser.getAllRows();
        } catch (ValidationException e) {
            logger.warn("Error al obtener las filas.", e);
            return false;
        }
        for (DtoMetricaPorAlerta dto : dtos) {
            if (tipoAlertaDao.findByCodigo(dto.getCodigoAlerta()) == null) {            	
            	logger.error("Método validarCodigoAlertas. El tipo de alerta con código " + dto.getCodigoAlerta() + " no existe.");
                return false;
            }
        }
        return true;
    }

    /**
     * Valida que la cantidad de niveles de gravedad en el archivo sea igual a los existentes en el sistema.
     * @param parser
     * @return
     * @throws IOException
     */
    private boolean validarCantidadNivelesGravedad(MetricaFileReader parser) throws IOException {
    	
    	int nivelSistema = nivelGravedadDao.getList().size();
    	int nivelFichero = parser.getCantidadNivelesGravedad();
    	
    	boolean res = nivelSistema == nivelFichero;
    	if(!res) {
    		logger.error("Método validarCantidadNivelesGravedad. La cantidad de niveles de gravedad en el archivo (" + nivelFichero + ") no coincide con los existentes en el sistema (" + nivelSistema + ").");
    	}
    	
        return res;
    }

    /**
     * Valida que el valor de nivel de preocupacion este entre 0 y 10 incluidos.
     * @param parser
     * @return
     * @throws IOException
     */
    private boolean validarRangosNivelPreocupacion(MetricaFileReader parser) throws IOException {
        List<DtoMetricaPorAlerta> dtos;
        try {
            dtos = parser.getAllRows();
        } catch (ValidationException e) {
            logger.warn("Error al obtener las filas.", e);
            return false;
        }
        for (DtoMetricaPorAlerta dto : dtos) {
            if (dto.getNivelPreocupacion() < 0 || dto.getNivelPreocupacion() > 10) {
            	
            	logger.error("Método validarRangosNivelPreocupacion. El valor de nivel de preocupacion del tipo de alerta " + dto.getCodigoAlerta() + " no está entre 0 y 10 incluidos (" + dto.getNivelPreocupacion() + ").");
            	return false;
            }
        }
        return true;
    }

    /**
     * Valida que el valor de los niveles de gravedad esten entre 1 y 100 incluidos.
     * Si es nulo no valida.
     * @param parser
     * @return
     * @throws IOException
     */
    private boolean validarRangosNivelesGravedad(MetricaFileReader parser) throws IOException {
        List<DtoMetricaPorAlerta> dtos;
        try {
            dtos = parser.getAllRows();
        } catch (ValidationException e) {
            logger.warn("Método validarRangosNivelesGravedad. Error al obtener las filas.", e);
            return false;
        }
        for (DtoMetricaPorAlerta dto : dtos) {
            List<Integer> niveles = dto.getNivelesGravedad();
            for (Integer nivel : niveles) {
                if (nivel == null) {
                    continue;
                }

                if (nivel.intValue() < 1 || nivel.intValue() > 100) {
                	logger.error("Método validarRangosNivelesGravedad. El valor de nivel de gravedad del tipo de alerta " + dto.getCodigoAlerta() + " no está entre 0 y 100 incluidos (" + dto.getNivelesGravedad() + ").");
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Verifica que para todos los rangos existe en el archivo o en la metrica una definición.
     * @param parser
     * @param metrica
     * @return
     * @throws IOException
     */
    private boolean todosLosRangosAlertasCubiertos(MetricaFileReader parser, DtoMetrica dto) throws IOException {
        boolean mDefecto = dto.getCodigoSegmento() == null;
        List<Metrica> metricasDefecto = null;
        if (!mDefecto) {
            metricasDefecto = metricaDao.getMetricasPorDefecto();
        }

        List<DtoMetricaPorAlerta> dtos = parser.getAllRows();
        List<TipoAlerta> tiposAlertas = tipoAlertaDao.getList();
        List<NivelGravedad> nivelesGravedad = nivelGravedadDao.getList();
        for (Iterator<TipoAlerta> itTipoAlerta = tiposAlertas.iterator(); itTipoAlerta.hasNext();) {
            TipoAlerta tipoAlerta = itTipoAlerta.next();
            for (Iterator<NivelGravedad> itNivelGravedad = nivelesGravedad.iterator(); itNivelGravedad.hasNext();) {
                NivelGravedad nivelGravedad = itNivelGravedad.next();
                if (!existeDefinicionEnFichero(dtos, tipoAlerta, nivelGravedad)) {

                    //Metrica para tipo de persona
                    if (mDefecto) {
                        //Si es una metrica por default me tengo que fijar si esta en todos los segmentos
                        List<Metrica> metricasPorSegmento = metricaDao.buscarMetricasPorSegmentos();
                        if (!validarCantidadMetricasSegmento(metricasPorSegmento)) {
                            return false;
                        }
                        if (!existeDefinicionEnMetricas(metricasPorSegmento, tipoAlerta, nivelGravedad)) {
                            return false;
                        }
                    } else {
                        //Metrica para un segmento
                        //Si no esta cubierto el agujero por todas las metrica por defecto falla.
                        if (!existeDefinicionEnMetricas(metricasDefecto, tipoAlerta, nivelGravedad)) {
                            return false;
                        }
                    }
                }
            }
        }

        return true;
    }

    /**
     * Verifica si en los datos del archivo existe una definición para el tipo de alerta y nivel de gravedad.
     * @param dtos
     * @param tipoAlerta
     * @param nivelGravedad
     * @return
     */
    private boolean existeDefinicionEnFichero(List<DtoMetricaPorAlerta> dtos, TipoAlerta tipoAlerta, NivelGravedad nivelGravedad) {
        for (DtoMetricaPorAlerta dto : dtos) {
            if (dto.getCodigoAlerta().equalsIgnoreCase(tipoAlerta.getCodigo())) {
                //Si ya encontró una definición para una alerta, debe haber para todos los
                // niveles porque valida la cantida de niveles antes, no?
                try {
                    Integer nivel = dto.getNivelesGravedad().get(nivelGravedad.getOrden() - 1);
                    return nivel != null;
                } catch (IndexOutOfBoundsException e) {
                    //No existe en el archivo uan definición para el nivel de gravedad
                	logger.warn("Método existeDefinicionEnFichero. No existe en el archivo una definición para el nivel de gravedad");
                    return false;
                }

            }
        }
        return false;
    }

    /**
     * Valida si el archivo de métricas indicado en la construcción de la clase
     * tiene todos los datos necesarios para la carga.
     * @param dto DtoMetrica
     * @return true si el archivo es valido.
     */
    public boolean sePuedeBorrar(DtoMetrica dto) {
        if (dto.getCodigoSegmento() != null) {
            return sePuedeBorrarMetricaParaSegmento(dto);
        }
        //A borrar una metrica por defualt
        return sePuedeBorrarMetricaPorDefecto();
    }

    /**
     * Todas las metricas por defecto cubren los valores cubierto por la metrica del segmento.
     * @return boolean
     */
    private boolean sePuedeBorrarMetricaParaSegmento(DtoMetrica dto) {
        List<Metrica> metricasDefecto = metricaDao.getMetricasPorDefecto();
        Metrica metricaSeg = metricaDao.getMetrica(dto, true);

        for (MetricaTipoAlerta mtt : metricaSeg.getMetricasTipoAlerta()) {
            for (MetricaTipoAlertaGravedad mtg : mtt.getMetricasTipoAlertaGravedad()) {
                if(!existeDefinicionEnMetricas(metricasDefecto, mtt.getTipoAlerta(), mtg.getNivelGravedad())) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Las metricas para todos los segmentos cubren el rango actual.
     * @return boolean
     */
    private boolean sePuedeBorrarMetricaPorDefecto() {
        List<Metrica> metricasPorSegmento = metricaDao.buscarMetricasPorSegmentos();
        if (validarCantidadMetricasSegmento(metricasPorSegmento)) {
            return todosLosRangosAlertasCubiertos(metricasPorSegmento);
        }
        return false;
    }

    private boolean validarCantidadMetricasSegmento(List<Metrica> metricasPorSegmento) {
        if (metricasPorSegmento.isEmpty()) {
        	logger.error("Método validarCantidadMetricasSegmento. No existen métricas por segmento en el sistema.");
            return false;
        }
        if (segmentoDao.getList().size() > metricasPorSegmento.size()) {
            // Tengo mas segmentos que metricas
        	logger.error("Método validarCantidadMetricasSegmento. Existen más segmentos que métricas.");
            return false;
        }
        return true;
    }

    private boolean todosLosRangosAlertasCubiertos(List<Metrica> metricas) {
        List<TipoAlerta> tiposAlertas = tipoAlertaDao.getList();
        List<NivelGravedad> nivelesGravedad = nivelGravedadDao.getList();
        for (Iterator<TipoAlerta> itTipoAlerta = tiposAlertas.iterator(); itTipoAlerta.hasNext();) {
            TipoAlerta tipoAlerta = itTipoAlerta.next();
            for (Iterator<NivelGravedad> itNivelGravedad = nivelesGravedad.iterator(); itNivelGravedad.hasNext();) {
                NivelGravedad nivelGravedad = itNivelGravedad.next();
                if (!existeDefinicionEnMetricas(metricas, tipoAlerta, nivelGravedad)) {
                    return false;
                }
            }
        }
        return true;
    }

    private boolean existeDefinicionEnMetricas(List<Metrica> metricas, TipoAlerta tipoAlerta, NivelGravedad nivelGravedad) {
        if (metricas.isEmpty()) {
        	logger.error("Método existeDefinicionEnMetricas. No existen métricas en el sistema.");
            return false;
        }
        for (Metrica metrica : metricas) {
            if (!existeDefinicionEnMetrica(metrica, tipoAlerta, nivelGravedad)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Verifica que exista un peso no nulo para los parámetros indicados.
     * @param metrica
     * @param tipoAlerta
     * @param nivelGravedad
     * @return
     */
    private boolean existeDefinicionEnMetrica(Metrica metrica, TipoAlerta tipoAlerta, NivelGravedad nivelGravedad) {
        if (metrica == null) {
        	logger.error("Método existeDefinicionEnMetrica. No existe la métrica pasada como parámetro.");
            return false;
        }
        for (MetricaTipoAlerta metricaTipoAlerta : metrica.getMetricasTipoAlerta()) {
            if (metricaTipoAlerta.getTipoAlerta().getCodigo().equalsIgnoreCase(tipoAlerta.getCodigo())) {
                for (MetricaTipoAlertaGravedad metricaTipoAlertaGravedad : metricaTipoAlerta.getMetricasTipoAlertaGravedad()) {
                    if (metricaTipoAlertaGravedad.getNivelGravedad().getCodigo().equalsIgnoreCase(nivelGravedad.getCodigo())) {
                    	Integer peso = metricaTipoAlertaGravedad.getPeso(); 
                    	boolean res = peso != null;
                    	
                    	if(!res) {
                    		logger.error("Método existeDefinicionEnMetrica. No existe un peso no nulo para la métrica " + metrica.getId() + ".");
                    	}
                    	
                        return res;
                    }
                }
            }
        }
        
        logger.error("Método existeDefinicionEnMetrica. No existe un peso no nulo para la métrica " + metrica.getId() + ".");
        return false;
    }

}
