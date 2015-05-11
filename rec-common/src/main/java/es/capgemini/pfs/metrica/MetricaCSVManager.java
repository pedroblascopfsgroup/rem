package es.capgemini.pfs.metrica;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.alerta.dao.NivelGravedadDao;
import es.capgemini.pfs.alerta.dao.TipoAlertaDao;
import es.capgemini.pfs.alerta.model.NivelGravedad;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.metrica.dao.MetricaDao;
import es.capgemini.pfs.metrica.dao.MetricaTipoAlertaDao;
import es.capgemini.pfs.metrica.dao.MetricaTipoAlertaGravedadDao;
import es.capgemini.pfs.metrica.dto.DtoMetrica;
import es.capgemini.pfs.metrica.dto.DtoMetricaPorAlerta;
import es.capgemini.pfs.metrica.model.FicheroMetrica;
import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.metrica.model.MetricaTipoAlerta;
import es.capgemini.pfs.metrica.model.MetricaTipoAlertaGravedad;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.segmento.dao.SegmentoDao;

/**
 * Clase que sabe como manejar el archivo de métricas con formato CSV.
 * La misma sabe como guardarlo en la BBDD y recuperalo de la misma.
 * @author aesteban
 *
 */
@Service
public class MetricaCSVManager {

	@Autowired
    private Executor executor;
    @Autowired
    private MetricaDao metricaDao;
    @Autowired
    private MetricaTipoAlertaDao metricaTipoAlertaDao;
    @Autowired
    private MetricaTipoAlertaGravedadDao metricaTipoAlertaGravedadDao;
    @Autowired
    private TipoAlertaDao tipoAlertaDao;
    @Autowired
    private SegmentoDao segmentoDao;
    @Autowired
    private NivelGravedadDao nivelGravedadDao;

    /**
     * Carga el archivo de métricas indicado en la construcción de la clase.
     * @param dtoMetrica DtoMetrica
     * @param ficheroMetrica archivo ya cargado en la BBDD
     */
    @Transactional(readOnly = false)
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_CSV_MGR_CARGAR)
    public void cargar(DtoMetrica dtoMetrica, FicheroMetrica ficheroMetrica) {
        try {
            Metrica metrica = new Metrica();
            String sTipoSegmento = dtoMetrica.getCodigoSegmento();
            if (sTipoSegmento != null) {
                metrica.setSegmento(segmentoDao.findByCodigo(sTipoSegmento));
            } else {
                String sTipoPersona = dtoMetrica.getCodigoTipoPersona();
                DDTipoPersona tipoPersona = (DDTipoPersona)executor.execute(
                		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                		DDTipoPersona.class,
                		sTipoPersona);

                metrica.setTipoPersona(tipoPersona);
            }

            metrica.setFichero(ficheroMetrica);
            metrica.setNombreFichero(dtoMetrica.getFileItem().getFileName());
            metricaDao.save(metrica);
            MetricaFileReader parser = new MetricaFileReader(dtoMetrica.getFile());
            List<MetricaTipoAlerta> mTTs = new ArrayList<MetricaTipoAlerta>();
            List<DtoMetricaPorAlerta> dtos = parser.getAllRows();
            for (DtoMetricaPorAlerta dto : dtos) {
                MetricaTipoAlerta metricaTipoAlerta = new MetricaTipoAlerta();
                metricaTipoAlerta.setMetrica(metrica);
                metricaTipoAlerta.setTipoAlerta(tipoAlertaDao.findByCodigo(dto.getCodigoAlerta()));
                metricaTipoAlerta.setPreocupacion(dto.getNivelPreocupacion());
                metricaTipoAlertaDao.save(metricaTipoAlerta);

                List<MetricaTipoAlertaGravedad> mTGs = new ArrayList<MetricaTipoAlertaGravedad>();
                List<Integer> pesos = dto.getNivelesGravedad();
                int size = pesos.size();
                for (int i = 1; i <= size; i++) {
                    NivelGravedad nivelGravedad = nivelGravedadDao.buscarPorOrden(i);
                    MetricaTipoAlertaGravedad metricaTipoAlertaGravedad = new MetricaTipoAlertaGravedad();
                    metricaTipoAlertaGravedad.setMetricaTipoAlerta(metricaTipoAlerta);
                    metricaTipoAlertaGravedad.setNivelGravedad(nivelGravedad);
                    metricaTipoAlertaGravedad.setPeso(pesos.get(i - 1));
                    metricaTipoAlertaGravedadDao.saveOrUpdate(metricaTipoAlertaGravedad);
                    mTGs.add(metricaTipoAlertaGravedad);
                }
                metricaTipoAlerta.setMetricasTipoAlertaGravedad(mTGs);
                metricaTipoAlertaDao.save(metricaTipoAlerta);
                mTTs.add(metricaTipoAlerta);
            }
            metrica.setMetricasTipoAlerta(mTTs);
            metricaDao.save(metrica);
        } catch (IOException e) {
            throw new BusinessOperationException("metricas.archivo.error.lectura", dtoMetrica.getFile().getAbsolutePath());
        }

    }

    /**
     * Descarga el archivo de métricas indicado en la construcción de la clase y
     * completa los campos vacios con '0'.
     * @param metrica Metrica
     * @return File csv
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_METRICA_CSV_MGR_DESCARGAR)
    public File descargar(Metrica metrica) {
        try {
            List<DtoMetricaPorAlerta> dtos = new ArrayList<DtoMetricaPorAlerta>();

            for (MetricaTipoAlerta mTA : metrica.getMetricasTipoAlerta()) {
                DtoMetricaPorAlerta dto = new DtoMetricaPorAlerta();
                dto.setCodigoAlerta(mTA.getTipoAlerta().getCodigo());
                dto.setDescripcionAlerta(mTA.getTipoAlerta().getDescripcion());
                dto.setNivelPreocupacion(mTA.getPreocupacion());
                int size = mTA.getMetricasTipoAlertaGravedad().size();
                List<Integer> niveles = new ArrayList<Integer>(size);
                for (MetricaTipoAlertaGravedad mTG : mTA.getMetricasTipoAlertaGravedad()) {
                    int index = mTG.getNivelGravedad().getOrden() - 1;
                    niveles.add(index, mTG.getPeso());
                }
                dto.setNivelesGravedad(niveles);
                dtos.add(dto);
            }
            MetricaFileWriter mFileWriter = new MetricaFileWriter(dtos);
            return mFileWriter.write(metrica.getNombreFichero());
        } catch (IOException e) {
            throw new BusinessOperationException("metricas.archivo.error.crear", metrica.getNombreFichero());
        }
    }
}
