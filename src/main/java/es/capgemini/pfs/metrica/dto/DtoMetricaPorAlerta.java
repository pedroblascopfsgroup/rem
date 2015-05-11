package es.capgemini.pfs.metrica.dto;

import java.util.List;

/**
 * Bean para leer o escribir los datos de una fila del fichero de métricas.
 * @author aesteban
 *
 */
public class DtoMetricaPorAlerta {
    private String codigoAlerta;
    private String descripcionAlerta;
    private Integer nivelPreocupacion;
    private List<Integer> nivelesGravedad;

    /**
     * @return the codigoAlerta
     */
    public String getCodigoAlerta() {
        return codigoAlerta;
    }

    /**
     * @param codigoAlerta the codigoAlerta to set
     */
    public void setCodigoAlerta(String codigoAlerta) {
        this.codigoAlerta = codigoAlerta;
    }

    /**
     * @return the nivelPreocupacion
     */
    public Integer getNivelPreocupacion() {
        return nivelPreocupacion;
    }

    /**
     * @param nivelPreocupacion the nivelPreocupacion to set
     */
    public void setNivelPreocupacion(Integer nivelPreocupacion) {
        this.nivelPreocupacion = nivelPreocupacion;
    }

    /**
     * @return the nivelesGravedad
     */
    public List<Integer> getNivelesGravedad() {
        return nivelesGravedad;
    }

    /**
     * @param nivelesGravedad the nivelesGravedad to set
     */
    public void setNivelesGravedad(List<Integer> nivelesGravedad) {
        this.nivelesGravedad = nivelesGravedad;
    }

    /**
     * @return the descripcionAlerta
     */
    public String getDescripcionAlerta() {
        return descripcionAlerta;
    }

    /**
     * @param descripcionAlerta the descripcionAlerta to set
     */
    public void setDescripcionAlerta(String descripcionAlerta) {
        this.descripcionAlerta = descripcionAlerta;
    }

}
