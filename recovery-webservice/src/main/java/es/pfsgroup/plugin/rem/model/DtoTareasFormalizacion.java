package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Rasul Abdulaev
 *
 */
public class DtoTareasFormalizacion {
    /**
	 * 
	 */
    private static final long serialVersionUID = 1L;
    

	private Boolean llamadaRealizada;
	private Boolean burofaxEnviado;
	private Date fechaLlamadaRealizada;
	private Date fechaBurofaxEnviado;
	
	public Boolean getLlamadaRealizada() {
		return llamadaRealizada;
	}
	public void setLlamadaRealizada(Boolean llamadaRealizada) {
		this.llamadaRealizada = llamadaRealizada;
	}
	public Boolean getBurofaxEnviado() {
		return burofaxEnviado;
	}
	public void setBurofaxEnviado(Boolean burofaxEnviado) {
		this.burofaxEnviado = burofaxEnviado;
	}
	public Date getFechaLlamadaRealizada() {
		return fechaLlamadaRealizada;
	}
	public void setFechaLlamadaRealizada(Date fechaLlamadaRealizada) {
		this.fechaLlamadaRealizada = fechaLlamadaRealizada;
	}
	public Date getFechaBurofaxEnviado() {
		return fechaBurofaxEnviado;
	}
	public void setFechaBurofaxEnviado(Date fechaBurofaxEnviado) {
		this.fechaBurofaxEnviado = fechaBurofaxEnviado;
	}
	
	
}