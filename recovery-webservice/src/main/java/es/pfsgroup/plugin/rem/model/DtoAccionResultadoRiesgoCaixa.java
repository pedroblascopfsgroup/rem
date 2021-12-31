package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoAccionResultadoRiesgoCaixa extends WebDto {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long idExpediente;
    
    private Long idTarea;

    private Long numOferta;

    private String riesgoOperacion;

    public Long getIdExpediente() {
        return idExpediente;
    }

    public void setIdExpediente(Long idExpediente) {
        this.idExpediente = idExpediente;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

    public String getRiesgoOperacion() {
        return riesgoOperacion;
    }

    public void setRiesgoOperacion(String riesgoOperacion) {
        this.riesgoOperacion = riesgoOperacion;
    }

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
}
