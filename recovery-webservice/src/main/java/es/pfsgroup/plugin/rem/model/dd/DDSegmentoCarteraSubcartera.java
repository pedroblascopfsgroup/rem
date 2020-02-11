package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
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
@Table(name = "DD_SCS_SEGMENTO_CRA_SCS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSegmentoCarteraSubcartera implements Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	 @Id
	 @Column(name = "DD_SCS_ID")
	 private Long id;
	    
	 @Column(name = "DD_TS_ID")   
	 private Long idTipoSegmento;
	 
	 @Column(name = "DD_CRA_ID")   
	 private Long cartera;
	    
	 @Column(name = "DD_SCR_ID")   
	 private Long subcartera;
	    		    
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

	public Long getIdTipoSegmento() {
		return idTipoSegmento;
	}

	public void setIdTipoSegmento(Long idTipoSegmento) {
		this.idTipoSegmento = idTipoSegmento;
	}

	public Long getCartera() {
		return cartera;
	}

	public void setCartera(Long cartera) {
		this.cartera = cartera;
	}

	public Long getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(Long subcartera) {
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



