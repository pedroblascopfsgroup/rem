package es.capgemini.pfs.metrica;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import au.com.bytecode.opencsv.CSVWriter;
import es.capgemini.pfs.metrica.dto.DtoMetricaPorAlerta;

/**
 * Clase encargada de saber como manejar el archivo CSV de métricas.
 * @author aesteban
 *
 */
public class MetricaFileWriter {

    private static final String CABECERA = "Alerta#Descripción#Nivel de preocupación";
    private static final String NIVEL_GRAVEDAD = "#Nivel Gravedad ";
    private List<DtoMetricaPorAlerta> dtos;

    /**
     * Constructor vacio para que funcione el contexto de los tests.
     */
    @Deprecated
    public MetricaFileWriter() {
        super();
    }

    /**
     * @param dtos Lista de DtoMetricaPorAlerta a escribir.
     */
    public MetricaFileWriter(List<DtoMetricaPorAlerta> dtos) {
        super();
        this.dtos = dtos;

    }

    /**
     * Crea el archivo CSV.
     * @param fileName String
     * @return File
     * @throws IOException error de escritura
     */
    public File write(String fileName) throws IOException {
        CSVWriter writer = new CSVWriter(new FileWriter(fileName), ';');
        //Encabezado
        writer.writeNext(getCabecera().split("#"));
        //Body
        for (DtoMetricaPorAlerta dto : dtos) {
            List<String> datos = new ArrayList<String>();
            datos.add(dto.getCodigoAlerta());
            datos.add(dto.getDescripcionAlerta());
            datos.add(dto.getNivelPreocupacion().toString());
            for (Integer nivel : dto.getNivelesGravedad()) {
                if(nivel == null) {
                    datos.add("");
                } else {
                    datos.add(nivel.toString());
                }
            }
            String[] arrayDatos = new String[datos.size()];
            datos.toArray(arrayDatos);
            writer.writeNext(arrayDatos);
        }

        writer.close();
        return new File(fileName);
    }

    private String getCabecera() {
        String cabecera = CABECERA;
        int size = dtos.get(0).getNivelesGravedad().size();
        for (int i = 1; i <= size; i++) {
            cabecera += NIVEL_GRAVEDAD + i;
        }
        return cabecera;
    }

}
