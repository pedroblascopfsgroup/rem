package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;


/**
 * Modelo que gestiona la tabla Auxiliar de Cierre Oficinas Bankia 
 * 
 * @author Sergio Gomez
 */

@Entity
@Table(name = "AUX_CIERRE_OFICINAS_BANKIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AuxiliarCierreOficinasBankia implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ECO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AuxCierreOficinasBankiaGenerator")
    @SequenceGenerator(name = "AuxCierreOficinasBankiaGenerator", sequenceName = "S_AUX_CIERRE_OFICINAS_BANKIA")
	private Long idExpediente;
	
	
    @Column(name = "OFICINA_ANTERIOR")
	private String oficinaAnterior;
    
    @Column(name = "ENVIADO")
	private boolean enviado;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getOficinaAnterior() {
		return oficinaAnterior;
	}

	public void setOficinaAnterior(String oficinaAnterior) {
		this.oficinaAnterior = oficinaAnterior;
	}

	public boolean isEnviado() {
		return enviado;
	}

	public void setEnviado(boolean enviado) {
		this.enviado = enviado;
	}


    
	
	
	
	

}
