package es.capgemini.pfs.metrica;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.metrica.dao.FicheroMetricaDao;
import es.capgemini.pfs.metrica.dao.MetricaDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.dto.DtoMetricaGrid;
import es.capgemini.pfs.metrica.model.FicheroMetrica;
import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.segmento.model.DDSegmento;
import es.capgemini.pfs.upload.dto.DtoFileUpload;

/**
 * Manager de la parte de métricas.
 * @author Andrés Esteban
 *
 */
@Service
public class MetricaManager {

    public static final String PARAM_COD_TIPO_PER = "codTipoPer";
    public static final String PARAM_COD_SEGMENTO = "codSegmento";
	@Autowired
    private Executor executor;
	@Autowired
    private MetricaValidator validator;
    @Autowired
    private MetricaCSVManager metricaCSVManager;
    @Autowired
    private MetricaDao metricaDao;
    @Autowired
    private FicheroMetricaDao ficheroMetricaDao;

    private static final long TAM_MAX_ARCHIVO_METRICA = 5 * 1024L * 1024L;

    /**
     * Carga una nueva métrica.
     * @param uploadForm WebFileItem
     * @return DtoFileUpload
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_CARGA_METRICA)
    @Transactional(readOnly = false)
    public DtoFileUpload cargarMetrica(WebFileItem uploadForm) {
        DtoMetrica dto = crearDto(uploadForm);
        DtoFileUpload dtoFileUpload = new DtoFileUpload();
        dtoFileUpload.setSize(uploadForm.getFileItem().getLength());
        if (dtoFileUpload.getSize() > TAM_MAX_ARCHIVO_METRICA || !validator.sePuedeCargar(dto)) {
            dtoFileUpload.setValido(false);
        } else {
            borrarMetricaCargadaPreviamente(dto);
            FicheroMetrica ficheroMetrica = ficheroMetricaDao.guardarFichero(dto);
            metricaCSVManager.cargar(dto, ficheroMetrica);
            dtoFileUpload.setValido(true);
        }
        return dtoFileUpload;
    }

    /**
     * En el caso que el usuario quiere cargar 2 o mas fichero consecutivos
     * se borra el anterior.
     */
    private void borrarMetricaCargadaPreviamente(DtoMetrica dto) {
        Metrica metricaInactiva = metricaDao.getMetrica(dto, false);
        if (metricaInactiva == null) {
            return;
        }
        FicheroMetrica ficheroInactivo = metricaInactiva.getFichero();
        metricaDao.borrarMetricaFisicamente(metricaInactiva);
        ficheroMetricaDao.borrarFisicamente(ficheroInactivo);
    }

    /**
     * Descarga de una métrica.
     * @param dto parámetros
     * @return File
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_DESCARGA_METRICA)
    public FileItem descargarMetrica(DtoMetrica dto) {
        Metrica metrica = metricaDao.getMetrica(dto, true);
        if (metrica == null) {
            // Si no tiene una métrica activa buscamos una no activa
            metrica = metricaDao.getMetrica(dto, false);
            if (metrica == null) {
                throw new BusinessOperationException("metricas.error.noArchivo");
            }
        }
        FileItem fileItem = new FileItem(metricaCSVManager.descargar(metrica));
        fileItem.setFileName(metrica.getNombreFichero());
        fileItem.setContentType("application/vnd.ms-excel");
        return fileItem;
    }

    /**
     * Activación de una métrica.
     * @param dto parámetros
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_ACTIVA_METRICA)
    @Transactional(readOnly = false)
    public void activarMetrica(DtoMetrica dto) {
        Metrica metricaActiva = metricaDao.getMetrica(dto, true);
        Metrica metricaInactiva = metricaDao.getMetrica(dto, false);
        if (metricaInactiva == null) {
            throw new BusinessOperationException("metricas.error.metricaInactivaNula");
        }
        if (metricaActiva != null) {
            //La primera vez no existe
            metricaDao.borrarMetricaFisicamente(metricaActiva);
        }
        metricaInactiva.setActivo(true);
        metricaInactiva.setFechaActivacion(new Date());
        metricaDao.saveOrUpdate(metricaInactiva);
    }

    /**
     * Borrado de una métrica.
     * @param dto parámetros
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_BORRAR_METRICA_ACTIVA)
    @Transactional(readOnly = false)
    public void borrarMetricaActiva(DtoMetrica dto) {
        if (!validator.sePuedeBorrar(dto)) {
            throw new BusinessOperationException("metricas.error.borrar");
        }
        Metrica metricaActiva = metricaDao.getMetrica(dto, true);
        if (metricaActiva == null) {
            throw new BusinessOperationException("metricas.error.borrar.vacio");
        }
        metricaDao.borrarMetricaFisicamente(metricaActiva);
    }

    /**
     * Transforma el objeto de devon a un dto conocido.
     * @param uploadForm
     * @return DtoMetrica
      */
    private DtoMetrica crearDto(WebFileItem uploadForm) {
        DtoMetrica dto = new DtoMetrica();
        dto.setCodigoTipoPersona(uploadForm.getParameter(PARAM_COD_TIPO_PER));
        dto.setCodigoSegmento(uploadForm.getParameter(PARAM_COD_SEGMENTO));
        dto.setFileItem(uploadForm.getFileItem());
        return dto;
    }

    /**
     * Retorna una lista con todos los tipos de persona y sus métricas
     * por default y nueva.
     * @param dto DtoFileUpload
     * @return List DtoMetricaGrid
     */
    @SuppressWarnings("unchecked")
	@BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICAS_TIPOS_PERSONA)
    public List<DtoMetricaGrid> getMetricasTiposPersona(DtoFileUpload dto) {
        if (!dto.isValido()) {
            if (dto.getSize() > TAM_MAX_ARCHIVO_METRICA) {
                throw new BusinessOperationException("upload.error.tamMax", new Long(TAM_MAX_ARCHIVO_METRICA / 1024L));
            }
            throw new BusinessOperationException("metricas.error.invalido");
        }
        List<DtoMetricaGrid> lista = new ArrayList<DtoMetricaGrid>();
        List<DDTipoPersona> tiposPersona = (List<DDTipoPersona>)executor.execute(
        		ComunBusinessOperation.BO_DICTIONARY_GET_LIST,
        		DDTipoPersona.class.getName());
        for (DDTipoPersona tipoPersona : tiposPersona) {
            DtoMetrica dtoMetrica = new DtoMetrica();
            dtoMetrica.setCodigoTipoPersona(tipoPersona.getCodigo());
            Metrica metricaDefault = metricaDao.getMetrica(dtoMetrica, true);
            Metrica metricaNueva = metricaDao.getMetrica(dtoMetrica, false);
            DtoMetricaGrid dtoMetricaGrid = new DtoMetricaGrid();
            dtoMetricaGrid.setTipoPersona(tipoPersona);
            dtoMetricaGrid.setMetricaDefault(metricaDefault);
            dtoMetricaGrid.setMetricaNueva(metricaNueva);
            lista.add(dtoMetricaGrid);
        }
        return lista;
    }

    /**
     * Retorna una lista con todos los segmentos,
     * y sus métricas por default y nueva.
     * @param dto DtoFileUpload
     * @return List DtoMetricaGrid
     */
    @SuppressWarnings("unchecked")
	@BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICAS_SEGMENTOS)
    public List<DtoMetricaGrid> getMetricasSegmentos(DtoFileUpload dto) {
        if (!dto.isValido()) {
            if (dto.getSize() > TAM_MAX_ARCHIVO_METRICA) {
                throw new BusinessOperationException("upload.error.tamMax", new Long(TAM_MAX_ARCHIVO_METRICA / 1024L / 1024L));
            }
            throw new BusinessOperationException("metricas.error.invalido");
        }
        List<DtoMetricaGrid> lista = new ArrayList<DtoMetricaGrid>();
        List<DDSegmento> segmentos = (List<DDSegmento>)executor.execute(
        		PrimariaBusinessOperation.BO_SEGMENTO_MGR_GET_SEGMENTOS);

        for (DDSegmento segmento : segmentos) {
            DtoMetrica dtoMetrica = new DtoMetrica();
            dtoMetrica.setCodigoSegmento(segmento.getCodigo());
            Metrica metricaDefault = metricaDao.getMetrica(dtoMetrica, true);
            Metrica metricaNueva = metricaDao.getMetrica(dtoMetrica, false);
            DtoMetricaGrid dtoMetricaGrid = new DtoMetricaGrid();
            dtoMetricaGrid.setSegmento(segmento);
            dtoMetricaGrid.setMetricaDefault(metricaDefault);
            dtoMetricaGrid.setMetricaNueva(metricaNueva);
            lista.add(dtoMetricaGrid);
        }
        return lista;
    }

    /**
     * Busca la métrica que corresponde al tipo de persona y/o segmento definidos en el dto.
     * @param dto parámetros
     * @param metricaActiva boolean
     * @return Metrica
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_MGR_GET_METRICA)
    public Metrica getMetrica(DtoMetrica dto, Boolean metricaActiva){
    	return metricaDao.getMetrica(dto, metricaActiva);
    }
}
