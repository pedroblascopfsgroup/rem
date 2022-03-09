package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

public class AvanzarDatosPBCDto implements Serializable {
    private Long idTarea;
    private Long idExpediente;
    private String comboResultado;
    private DatosPBCDto datosPBCDto;
    
    
	public Long getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	public String getComboResultado() {
		return comboResultado;
	}
	public void setComboResultado(String comboResultado) {
		this.comboResultado = comboResultado;
	}
	public DatosPBCDto getDatosPBCDto() {
		return datosPBCDto;
	}
	public void setDatosPBCDto(DatosPBCDto datosPBCDto) {
		this.datosPBCDto = datosPBCDto;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
}