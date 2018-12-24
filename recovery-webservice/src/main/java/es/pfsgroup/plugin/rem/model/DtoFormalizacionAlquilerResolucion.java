package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Rasul Abdulaev
 *
 */
public class DtoFormalizacionAlquilerResolucion extends WebDto {
    /**
	 * 
	 */
    private static final long serialVersionUID = 1L;
    

	private String fechaFirma;
    private String lugarFirma;
    
    public String getFechaFirma() {
		return fechaFirma;
	}
	public void setFechaFirma(String fechaFirma) {
		this.fechaFirma = fechaFirma;
    }
    
    public String getLugarFirma() {
		return lugarFirma;
	}
	public void setLugarFirma(String lugarFirma) {
		this.lugarFirma = lugarFirma;
	}
}