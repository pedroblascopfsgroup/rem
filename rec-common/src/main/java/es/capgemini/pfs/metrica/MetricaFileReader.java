package es.capgemini.pfs.metrica;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import au.com.bytecode.opencsv.CSVReader;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.metrica.dto.DtoMetricaPorAlerta;

/**
 * Clase encargada de saber como manejar el archivo CSV de métricas.
 * @author aesteban
 *
 */
public class MetricaFileReader {

    private static final int CAMPO_COD_ALERTA = 0;
    private static final int CAMPO_NVL_PREOCUPACION = 2;
    private static final int PRIMER_CAMPO_NVL_GRAVEDAD = 3;
    private File cvsFile;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Constructor vacio para que funcione el contexto de los tests.
     */
    @Deprecated
    public MetricaFileReader() {
        super();
    }

    /**
     * @param cvsFile archivo a validar
     */
    public MetricaFileReader(File cvsFile) {
        super();
        this.cvsFile = cvsFile;

    }

    /**
     * Calcula el numero de filas sin la cabecera.
     * No cuenta el encabezado.
     * @return int
     * @throws IOException problema de lectura
     */
    public int getRowCount() throws IOException {
        return getNewReader().readAll().size();
    }

    /**
     * Calcula el numero de columnas.
     * @return int
     * @throws IOException problema de lectura
     */
    public int getColumnCount() throws IOException {
        return getNewReader().readNext().length;
    }

    /**
     * Calcula el numero de niveles de gravedad.
     * @return int
     * @throws IOException problema de lectura
     */
    public int getCantidadNivelesGravedad() throws IOException {
        return getNewReader().readNext().length - PRIMER_CAMPO_NVL_GRAVEDAD;
    }

    /**
     * Retorna la fila indicada.
     * @param fila 1 o más
     * @return DtoMetricaPorAlerta
     * @throws IOException problema de lectura
     */
    public DtoMetricaPorAlerta getRow(int fila) throws IOException {
        CSVReader reader = getNewReader();
        for (int i = 1; i < fila; i++) {
            reader.readNext();
        }
        return crearDto(reader.readNext());
    }

    /**
     * Retorna una lista de dto de cada una de las filas sin el encabezado.
     * @return Lista de DtoMetricaPorAlerta
     * @throws IOException problema de lectura
     */
    @SuppressWarnings("unchecked")
    public List<DtoMetricaPorAlerta> getAllRows() throws IOException {
        List<DtoMetricaPorAlerta> dtos = new ArrayList<DtoMetricaPorAlerta>();
        CSVReader reader = getNewReader();
        Iterator<String[]> it = reader.readAll().iterator();
        while (it.hasNext()) {
            dtos.add(crearDto(it.next()));
        }
        return dtos;
    }

    /**
     * Crea el bean de la fila del archivo de métricas.
     * Si el dato es vacio inserta nulo.
     * @param fila String[]
     * @return DtoMetricaPorAlerta
     */
    private DtoMetricaPorAlerta crearDto(String[] fila) {
        if (fila == null || fila.length < 4) {
            //La fila no es valida
            logger.warn("La fila no es valida [" + fila + "]");
            throw new ValidationException();
            //return null;
        }
        DtoMetricaPorAlerta dto = new DtoMetricaPorAlerta();

        dto.setCodigoAlerta(fila[CAMPO_COD_ALERTA]);
        dto.setNivelPreocupacion(new Integer(fila[CAMPO_NVL_PREOCUPACION]));
        List<Integer> niveles = new ArrayList<Integer>();
        for (int i = PRIMER_CAMPO_NVL_GRAVEDAD; i < fila.length; i++) {
            if (fila[i].isEmpty()) {
                niveles.add(null);
            } else {
                niveles.add(new Integer(fila[i]));
            }
        }
        dto.setNivelesGravedad(niveles);
        return dto;
    }

    private CSVReader getNewReader() {
        try {
            return new CSVReader(new FileReader(cvsFile), ';', '\"', 1);
        } catch (FileNotFoundException e) {
            throw new BusinessOperationException("metricas.archivo.inexistente", cvsFile.getAbsolutePath());
        }
    }
}
