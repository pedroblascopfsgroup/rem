package es.capgemini.pfs.scoring.dto;

import java.util.Map;

/**
 * Dto para la simulacion.
 * @author aesteban
 *
 */
public class DtoSimulacion {
    private Double maxVRC;
    private Double minVRC;
    /**
     * Mapa cuyo key el nombre del intervalo y su valor es otro mapa con el numero de clientes y VRC total.
     */
    private Map<String, Map<String, Double>> intervalos;
    public static final String KEY_CANT_CLIENTES = "cantClientes";
    public static final String KEY_TOTAL_VRC = "totalVRC";
    /**
     * @return the maxVRC
     */
    public Double getMaxVRC() {
        return maxVRC;
    }
    /**
     * @param maxVRC the maxVRC to set
     */
    public void setMaxVRC(Double maxVRC) {
        this.maxVRC = maxVRC;
    }
    /**
     * @return the minVRC
     */
    public Double getMinVRC() {
        return minVRC;
    }
    /**
     * @param minVRC the minVRC to set
     */
    public void setMinVRC(Double minVRC) {
        this.minVRC = minVRC;
    }
    /**
     * @return the intervalos
     */
    public Map<String, Map<String, Double>> getIntervalos() {
        return intervalos;
    }
    /**
     * @param intervalos the intervalos to set
     */
    public void setIntervalos(Map<String, Map<String, Double>> intervalos) {
        this.intervalos = intervalos;
    }


}
