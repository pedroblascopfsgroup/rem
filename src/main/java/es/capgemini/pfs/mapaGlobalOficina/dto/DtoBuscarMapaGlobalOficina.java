package es.capgemini.pfs.mapaGlobalOficina.dto;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Dto para ingresar los criterios de Búsqueda de MapaGlobalOficina.
 */
public class DtoBuscarMapaGlobalOficina {

    private String fecha;
    private Set<String> codigoSegmentos;
    private Set<String> tiposContratos;
    private String codigoFase;
    private Set<String> codigoSubfases;
    private String jerarquia;
    private Set<String> codigoZonas;
    private String criterioSalida;
    private String criterioSalidaJerarquico;

    /**
     * @return the fecha
     */
    public String getFecha() {
        return fecha;
    }

    /**
     * @param fecha the fecha to set
     */
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    /**
     * @return the segmentos
     */
    public Set<String> getCodigoSegmentos() {
        if (codigoSegmentos != null && codigoSegmentos.size() == 1) {
            List<String> list = Arrays.asList((codigoSegmentos.iterator().next().split(",")));
            return new HashSet<String>(list);
        }
        return codigoSegmentos;
    }

    /**
     * @param segmentos the segmentos to set
     */
    public void setCodigoSegmentos(Set<String> segmentos) {
        this.codigoSegmentos = segmentos;
    }

    /**
     * @return the tiposContratos
     */
    public Set<String> getTiposContratos() {
        if (tiposContratos != null && tiposContratos.size() == 1) {
            List<String> list = Arrays.asList((tiposContratos.iterator().next().split(",")));
            return new HashSet<String>(list);
        }
        return tiposContratos;
    }

    /**
     * @param tiposContratos the tiposContratos to set
     */
    public void setTiposContratos(Set<String> tiposContratos) {
        this.tiposContratos = tiposContratos;
    }

    /**
     * @return the codigoFase
     */
    public String getCodigoFase() {
        return codigoFase;
    }

    /**
     * @param codigoFase the codigoFase to set
     */
    public void setCodigoFase(String codigoFase) {
        this.codigoFase = codigoFase;
    }

    /**
     * @return the codigoSubfases
     */
    public Set<String> getCodigoSubfases() {
        if (codigoSubfases != null && codigoSubfases.size() == 1) {
            List<String> list = Arrays.asList((codigoSubfases.iterator().next().split(",")));
            return new HashSet<String>(list);
        }
        return codigoSubfases;
    }

    /**
     * @param codigoSubfases the codigoSubfases to set
     */
    public void setCodigoSubfases(Set<String> codigoSubfases) {
        this.codigoSubfases = codigoSubfases;
    }

    /**
     * @return the jerarquia
     */
    public String getJerarquia() {
        return jerarquia;
    }

    /**
     * @param jerarquia the jerarquia to set
     */
    public void setJerarquia(String jerarquia) {
        this.jerarquia = jerarquia;
    }

    /**
     * @return the codigoZonas
     */
    public Set<String> getCodigoZonas() {
        if (codigoZonas != null && codigoZonas.size() == 1) {
            List<String> list = Arrays.asList((codigoZonas.iterator().next().split(",")));
            return new HashSet<String>(list);
        }
        return codigoZonas;
    }

    /**
     * @param codigoZonas the codigoZonas to set
     */
    public void setCodigoZonas(Set<String> codigoZonas) {
        this.codigoZonas = codigoZonas;
    }

    /**
     * @return the criterioSalida
     */
    public String getCriterioSalida() {
        return criterioSalida;
    }

    /**
     * @param criterioSalida the criterioSalida to set
     */
    public void setCriterioSalida(String criterioSalida) {
        this.criterioSalida = criterioSalida;
    }

    /**
     * @return the criterioSalidaJerarquico
     */
    public String getCriterioSalidaJerarquico() {
        return criterioSalidaJerarquico;
    }

    /**
     * @param criterioSalidaJerarquico the criterioSalidaJerarquico to set
     */
    public void setCriterioSalidaJerarquico(String criterioSalidaJerarquico) {
        this.criterioSalidaJerarquico = criterioSalidaJerarquico;
    }

}
