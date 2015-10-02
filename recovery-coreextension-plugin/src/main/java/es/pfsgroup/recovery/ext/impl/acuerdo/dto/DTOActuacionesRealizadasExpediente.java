package es.pfsgroup.recovery.ext.impl.acuerdo.dto;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTActuacionesRealizadasExpediente;

/**
 * @author marruiz
 */
public class DTOActuacionesRealizadasExpediente extends WebDto {

	private static final long serialVersionUID = 1317814414788732154L;

	private EXTActuacionesRealizadasExpediente actuaciones;
	private Long idExpediente;

	public EXTActuacionesRealizadasExpediente getActuaciones() {
		return actuaciones;
	}

	public void setActuaciones(EXTActuacionesRealizadasExpediente actuaciones) {
		this.actuaciones = actuaciones;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

}
