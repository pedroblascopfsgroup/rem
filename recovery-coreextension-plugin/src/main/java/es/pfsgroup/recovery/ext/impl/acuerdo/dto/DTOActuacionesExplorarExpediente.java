package es.pfsgroup.recovery.ext.impl.acuerdo.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author mmejias
 */
public class DTOActuacionesExplorarExpediente extends WebDto {

	private static final long serialVersionUID = -2514074231854057733L;

	private Long idExpediente;
	private Long idActuacion;
	private String ddSubtipoSolucionAmistosaAcuerdo;
	private String ddTipoSolucionAmistosa;
	private String ddValoracionActuacionAmistosa;
	private String observaciones;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getIdActuacion() {
		return idActuacion;
	}

	public void setIdActuacion(Long idActuacion) {
		this.idActuacion = idActuacion;
	}

	public String getDdSubtipoSolucionAmistosaAcuerdo() {
		return ddSubtipoSolucionAmistosaAcuerdo;
	}

	public void setDdSubtipoSolucionAmistosaAcuerdo(
			String ddSubtipoSolucionAmistosaAcuerdo) {
		this.ddSubtipoSolucionAmistosaAcuerdo = ddSubtipoSolucionAmistosaAcuerdo;
	}

	public String getDdValoracionActuacionAmistosa() {
		return ddValoracionActuacionAmistosa;
	}

	public void setDdValoracionActuacionAmistosa(
			String ddValoracionActuacionAmistosa) {
		this.ddValoracionActuacionAmistosa = ddValoracionActuacionAmistosa;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getDdTipoSolucionAmistosa() {
		return ddTipoSolucionAmistosa;
	}

	public void setDdTipoSolucionAmistosa(String ddTipoSolucionAmistosa) {
		this.ddTipoSolucionAmistosa = ddTipoSolucionAmistosa;
	}

}
