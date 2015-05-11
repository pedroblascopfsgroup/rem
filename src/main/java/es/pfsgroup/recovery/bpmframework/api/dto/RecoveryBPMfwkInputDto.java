package es.pfsgroup.recovery.bpmframework.api.dto;

import java.io.Serializable;
import java.util.Map;

import es.capgemini.devon.files.FileItem;

/**
 * DTO con toda la información relacionada con un INPUT
 * 
 * @author bruno
 * 
 */
public class RecoveryBPMfwkInputDto implements RecoveryBPMfwkInputInfo, Serializable {

    private static final long serialVersionUID = -1525421226928428216L;

    private Long idProcedimiento;

    private String codigoTipoInput;

    private Map<String, Object> datos;

    private FileItem adjunto;

    /**
     * Identifica un conjunto de INPUTS que deben ir juntos
     * 
     * @return
     */
    @Override
    public Long getIdProcedimiento() {
        return idProcedimiento;
    }

    /**
     * Identifica un conjunto de INPUTS que deben ir juntos
     * 
     * @param idProcedimiento
     */
    public void setIdProcedimiento(final Long idProcedimiento) {
        this.idProcedimiento = idProcedimiento;
    }

    /**
     * Identifica el tipo de input
     * 
     * @return
     */
    @Override
    public String getCodigoTipoInput() {
        return codigoTipoInput;
    }

    /**
     * Identifica el tipo de input
     * 
     * @return
     */
    public void setCodigoTipoInput(final String codigoTipoInput) {
        this.codigoTipoInput = codigoTipoInput;
    }

    /**
     * Datos que se introducen en el INPUT
     * 
     * @return
     */
    @Override
    public Map<String, Object> getDatos() {
        return datos;
    }

    /**
     * Datos que se introducen en el INPUT
     * 
     * @param datos
     */
    public void setDatos(final Map<String, Object> datos) {
        this.datos = datos;
    }

    /**
     * Fichero adjunto al INPUT
     * 
     * @return
     */
    @Override
    public FileItem getAdjunto() {
        return adjunto;
    }

    /**
     * Fichero adjunto al INPUT
     * 
     * @return
     */
    public void setAdjunto(final FileItem adjunto) {
        this.adjunto = adjunto;
    }

}
