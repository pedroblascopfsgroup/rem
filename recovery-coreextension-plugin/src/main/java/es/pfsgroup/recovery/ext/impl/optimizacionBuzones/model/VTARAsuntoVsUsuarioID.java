package es.pfsgroup.recovery.ext.impl.optimizacionBuzones.model;

import java.io.Serializable;

import javax.persistence.Column;

public class VTARAsuntoVsUsuarioID implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7616811463555846179L;
	@Column(name = "USU_id")
	private Long usuario;
	@Column(name = "DD_TGE_ID")
	private Long tipoGestor;
	@Column(name = "asu_id")
	private Long asunto;

	public Long getUsuario() {
		return usuario;
	}

	public void setUsuario(Long usuario) {
		this.usuario = usuario;
	}

	public Long getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(Long tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public Long getAsunto() {
		return asunto;
	}

	public void setAsunto(Long asunto) {
		this.asunto = asunto;
	}

	public boolean equals(Object other) { 
        
		if(other instanceof VTARAsuntoVsUsuarioID){
			VTARAsuntoVsUsuarioID otra = (VTARAsuntoVsUsuarioID)other;
			return (this.usuario.equals(otra.usuario))
					&& (this.tipoGestor.equals(otra.tipoGestor))
					&& (this.asunto.equals(otra.asunto));
		}else
			return false;
    }

    public int hashCode() { 
        return this.usuario.hashCode() + this.tipoGestor.hashCode() + this.asunto.hashCode(); 
    }
	

}
