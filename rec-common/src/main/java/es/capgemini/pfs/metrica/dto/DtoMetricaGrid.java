package es.capgemini.pfs.metrica.dto;

import java.io.Serializable;

import es.capgemini.pfs.metrica.model.Metrica;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * DTO para pasar los datos a los grids del tab de Scoring y Alertas.
 * @author marruiz
 */
public class DtoMetricaGrid implements Serializable {

    private static final long serialVersionUID = 3799553057278323893L;

    private DDTipoPersona tipoPersona;
    private DDSegmento segmento;
    private Metrica metricaDefault;
    private Metrica metricaNueva;


    /**
     * @return the tipoPersona
     */
    public DDTipoPersona getTipoPersona() {
        return tipoPersona;
    }
    /**
     * @param tipoPersona the tipoPersona to set
     */
    public void setTipoPersona(DDTipoPersona tipoPersona) {
        this.tipoPersona = tipoPersona;
    }
    /**
     * @return the segmento
     */
    public DDSegmento getSegmento() {
        return segmento;
    }
    /**
     * @param segmento the segmento to set
     */
    public void setSegmento(DDSegmento segmento) {
        this.segmento = segmento;
    }
    /**
     * @return the metricaDefault
     */
    public Metrica getMetricaDefault() {
        return metricaDefault;
    }
    /**
     * @param metricaDefault the metricaDefault to set
     */
    public void setMetricaDefault(Metrica metricaDefault) {
        this.metricaDefault = metricaDefault;
    }
    /**
     * @return the metricaNueva
     */
    public Metrica getMetricaNueva() {
        return metricaNueva;
    }
    /**
     * @param metricaNueva the metricaNueva to set
     */
    public void setMetricaNueva(Metrica metricaNueva) {
        this.metricaNueva = metricaNueva;
    }
}
