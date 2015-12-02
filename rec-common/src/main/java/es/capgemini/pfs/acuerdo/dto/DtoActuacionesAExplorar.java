package es.capgemini.pfs.acuerdo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author marruiz
 */
public class DtoActuacionesAExplorar extends WebDto {

    private static final long serialVersionUID = -1103845402356400808L;

    private Long idAcuerdo;
    private Long idActuacion;
    private String ddSubtipoSolucionAmistosaAcuerdo;
    private String ddValoracionActuacionAmistosa;
    private String observaciones;
    private String guid;

    /**
     * @return the idActuacion
     */
    public Long getIdActuacion() {
        return idActuacion;
    }
    /**
     * @param idActuacion the idActuacion to set
     */
    public void setIdActuacion(Long idActuacion) {
        this.idActuacion = idActuacion;
    }
    /**
     * @return the idAcuerdo
     */
    public Long getIdAcuerdo() {
        return idAcuerdo;
    }
    /**
     * @param idAcuerdo the idAcuerdo to set
     */
    public void setIdAcuerdo(Long idAcuerdo) {
        this.idAcuerdo = idAcuerdo;
    }
    /**
     * @return the ddSubtipoSolucionAmistosaAcuerdo
     */
    public String getDdSubtipoSolucionAmistosaAcuerdo() {
        return ddSubtipoSolucionAmistosaAcuerdo;
    }
    /**
     * @param ddSubtipoSolucionAmistosaAcuerdo the ddSubtipoSolucionAmistosaAcuerdo to set
     */
    public void setDdSubtipoSolucionAmistosaAcuerdo(String ddSubtipoSolucionAmistosaAcuerdo) {
        this.ddSubtipoSolucionAmistosaAcuerdo = ddSubtipoSolucionAmistosaAcuerdo;
    }
    /**
     * @return the ddValoracionActuacionAmistosa
     */
    public String getDdValoracionActuacionAmistosa() {
        return ddValoracionActuacionAmistosa;
    }
    /**
     * @param ddValoracionActuacionAmistosa the ddValoracionActuacionAmistosa to set
     */
    public void setDdValoracionActuacionAmistosa(String ddValoracionActuacionAmistosa) {
        this.ddValoracionActuacionAmistosa = ddValoracionActuacionAmistosa;
    }
    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }
    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
	public String getGuid() {
		return guid;
	}
	public void setGuid(String guid) {
		this.guid = guid;
	}
}
