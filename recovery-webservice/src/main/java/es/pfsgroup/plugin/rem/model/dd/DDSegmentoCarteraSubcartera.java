package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona el diccionario de los tipos de segmento de los activos
 * 
 * @author Joaquin Bahamonde
 *
 */
@Entity
@Table(name = "DD_SCS_SEGMENTO_CRA_SCR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSegmentoCarteraSubcartera implements Auditable, Serializable {

	 /**
	 * 
	 */
	private static final long serialVersionUID = -9198832839568757464L;
	
	@Id
	@Column(name = "DD_SCS_ID")
	private Long id;
	    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TS_ID")   
	private DDTipoSegmento tipoSegmento;
	 
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CRA_ID")   
	private DDCartera cartera;
	   
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SCR_ID")   
	private DDSubcartera subcartera;
	    		    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public DDTipoSegmento getTipoSegmento() {
		return tipoSegmento;
	}
	
	public void setTipoSegmento(DDTipoSegmento tipoSegmento) {
		this.tipoSegmento = tipoSegmento;
	}
	
	public DDCartera getCartera() {
		return cartera;
	}
	
	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}
	
	public DDSubcartera getSubcartera() {
		return subcartera;
	}
	
	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}
	
	public Long getVersion() {
		return version;
	}
	
	public void setVersion(Long version) {
		this.version = version;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}
	
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}



