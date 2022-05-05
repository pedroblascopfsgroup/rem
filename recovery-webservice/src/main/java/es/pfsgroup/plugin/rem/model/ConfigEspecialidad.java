package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEspecialidad;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;



/**
 * @author Lara
 *
 */
@Entity
@Table(name = "ESP_SAC_CONFIG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfigEspecialidad implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	@Id
	@Column(name = "DD_EAC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfigEspecialidadGenerator")
	@SequenceGenerator(name = "ConfigEspecialidadGenerator", sequenceName = "S_ESP_SAC_CONFIG")
	private Long id;
	    
	  
	@JoinColumn(name = "DD_SAC_ID")  
	@ManyToOne(fetch = FetchType.LAZY)
	private DDSubtipoActivo subtipoActivo;
	
	@JoinColumn(name = "DD_ESP_ID")  
	@ManyToOne(fetch = FetchType.LAZY)
	private DDEspecialidad especialidad;
	
	@JoinColumn(name = "DD_TPA_ID")  
	@ManyToOne(fetch = FetchType.LAZY)
	private DDTipoActivo tipoActivo;
	
	
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

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public DDEspecialidad getEspecialidad() {
		return especialidad;
	}

	public void setEspecialidad(DDEspecialidad especialidad) {
		this.especialidad = especialidad;
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
