package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEspecialidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Lara
 *
 */
@Entity
@Table(name = "BAE_BLOQUEO_APIS_ESP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class BloqueoApisEspecialidad implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "BAE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "BloqueoApisEspecialidadGenerator")
    @SequenceGenerator(name = "BloqueoApisEspecialidadGenerator", sequenceName = "S_BAE_BLOQUEO_APIS_ESP")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BAP_ID")
    private BloqueoApis bloqueoApis; 
    
	@ManyToOne
    @JoinColumn(name = "DD_ESP_ID")
	private DDEspecialidad especialidad;
	
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

	public BloqueoApis getBloqueoApis() {
		return bloqueoApis;
	}

	public void setBloqueoApis(BloqueoApis bloqueoApis) {
		this.bloqueoApis = bloqueoApis;
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
