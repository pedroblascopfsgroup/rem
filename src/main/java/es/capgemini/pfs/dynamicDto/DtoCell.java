package es.capgemini.pfs.dynamicDto;

import java.util.HashMap;

/**
 * Celda de un DTO dinámico.
 * @author marruiz
 */
public class DtoCell {

    private String name;
    private String value;
    private HashMap<String, Object> params;

    private Long puntuacionTotal = 0L;
    private Long puntuacionAlerta = 0L;
    private String gravedadAlerta;

    private Boolean isMultiplesAlertas = false;
    private Boolean isVisible = true;
    private Boolean isAlerta = false;

    /**
     * @return the params
     */
    public HashMap<String, Object> getParams() {
        return params;
    }

    /**
     * @param params the params to set
     */
    public void setParams(HashMap<String, Object> params) {
        this.params = params;
    }

    /**
     * Devuelve el valor procesado según si tiene múltiples alertas
     * @return
     */
    public String getProcessedValue() {
        if (!isAlerta) return value;

        if (puntuacionTotal > 0 && isMultiplesAlertas) {
            return gravedadAlerta + " (" + puntuacionAlerta.toString() + " / " + puntuacionTotal.toString() + ")";
        } else {
            return gravedadAlerta + " (" + puntuacionAlerta.toString() + ")";
        }
    }

    /**
     * Recupera el nombre procesado por su visibilidad
     * @return
     */
    public String getProcessedName() {
        if (!isAlerta || (isAlerta && isVisible))
            return name;
        else
            return "No visible";
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the value
     */
    public String getValue() {
        return value;
    }

    /**
     * @param value the value to set
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * Recupera el valor en formato Long. Si no existe valor devuelve 0.
     * @return
     */
    public Long getLongValue() {
        try {
            return Long.valueOf(value);
        } catch (Exception e) {
            return 0L;
        }
    }

    /**
     * Suma al valor actual el valor que se le pasa por parámetro.
     * @param value
     */
    public void addValue(Long value) {
        this.value = ((Long) (value + getLongValue())).toString();
    }

    /**
     * Acumulador de puntuación de alertas
     * @param puntuacion
     */
    public void addPuntuacionTotal(Long puntuacion) {
        if (this.puntuacionTotal > 0) isMultiplesAlertas = true;
        this.puntuacionTotal += puntuacionTotal;
    }

    /**
     * Crea información de una alerta
     * @param gravedadAlerta
     * @param puntuacionAlerta
     */
    public void setValue(String gravedadAlerta, Long puntuacionAlerta) {
        this.gravedadAlerta = gravedadAlerta;
        this.puntuacionAlerta = puntuacionAlerta;
        this.puntuacionTotal = puntuacionAlerta;
        this.isAlerta = true;
    }

    /**
     * Setea si la alerta es o no visible
     * @param visible
     */
    public void setVisible(Boolean visible) {
        this.isVisible = visible;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        String valor = getProcessedValue();
        String nombre = getProcessedName();

        return "name:" + nombre + " ,value:" + valor;
    }
}
