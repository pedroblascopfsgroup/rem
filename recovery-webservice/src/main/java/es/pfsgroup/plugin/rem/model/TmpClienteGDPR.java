package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.springframework.transaction.annotation.Transactional;

/**
 * 
 * Modelo que gestiona la informacion temporal GDPR de un cliente
 *  
 */
@Entity
@Table(name = "TMP_CLIENTE_GDPR", schema = "${entity.schema}")
public class TmpClienteGDPR implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID_PERSONA_HAYA")
    private Long idPersonaHaya;
	
    @Column(name = "NUM_DOCUMENTO")
    private String numDocumento;
    
    @Column(name = "ADCOM_ID")
    private Long idAdjunto;

	public Long getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(Long idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}

	public String getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}

	public Long getIdAdjunto() {
		return idAdjunto;
	}

	public void setIdAdjunto(Long idAdjunto) {
		this.idAdjunto = idAdjunto;
	}
}
