package es.capgemini.pfs.batch.revisar.expedientes;

import java.util.List;

/**
 * Clase para modelar la busqueda de expedientes activos.
 * @author aesteban
 */
public class ExpedienteBatch implements Comparable<ExpedienteBatch> {

    private Long id;
    private Long idJbpm;
    private boolean automatico;
    private Long idContratoPase;
    private List<Long> idsContratosNoPase;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the idJbpm
     */
    public Long getIdJbpm() {
        return idJbpm;
    }

    /**
     * @param idJbpm the idJbpm to set
     */
    public void setIdJbpm(Long idJbpm) {
        this.idJbpm = idJbpm;
    }

    /**
     * @return the idContratoPase
     */
    public Long getIdContratoPase() {
        return idContratoPase;
    }

    /**
     * @param idContratoPase the idContratoPase to set
     */
    public void setIdContratoPase(Long idContratoPase) {
        this.idContratoPase = idContratoPase;
    }

    /**
     * @return the idsContratosNoPase
     */
    public List<Long> getIdsContratosNoPase() {
        return idsContratosNoPase;
    }

    /**
     * @param idsContratosNoPase the idsContratosNoPase to set
     */
    public void setIdsContratosNoPase(List<Long> idsContratosNoPase) {
        this.idsContratosNoPase = idsContratosNoPase;
    }

    /**
     * @return the automatico
     */
    public boolean isAutomatico() {
        return automatico;
    }

    /**
     * @param automatico the automatico to set
     */
    public void setAutomatico(boolean automatico) {
        this.automatico = automatico;
    }

    /**
     * @see java.lang.Object#equals(java.lang.Object).
     * @param obj o
     * @return boolean
     */
    @Override
    public boolean equals(Object obj) {
        return this.hashCode() == obj.hashCode();
    }

    /**
     * @see java.lang.Object#hashCode()
     * @return int
     */
    @Override
    public int hashCode() {
        return this.getId().hashCode();
    }

    /**
     * Compara expedientes por id.
     * @param o ExpedienteBatch
     * @return int
     */
    @Override
    public int compareTo(ExpedienteBatch o) {
        return this.getId().compareTo(o.getId());
    }

}
