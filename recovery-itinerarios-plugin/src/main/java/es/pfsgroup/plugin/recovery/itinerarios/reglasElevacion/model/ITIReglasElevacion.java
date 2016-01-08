package es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;
import es.capgemini.pfs.itinerario.model.Estado;

/**
 * Reglas de elevación de estados.
 * @author Diana
 *
 */
@Entity
@Table(name = "REE_REGLAS_ELEVACION_ESTADO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ITIReglasElevacion implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2961661780025797513L;

	@Id
	@Column(name="REE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ReglasElevacionGenerator")
    @SequenceGenerator(name = "ReglasElevacionGenerator", sequenceName = "S_REE_REGLAS_ELEVACION_ESTADO")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name="DD_TRE_ID")
	private DDTipoReglasElevacion ddTipoReglasElevacion;
	
	@ManyToOne
	@JoinColumn(name="DD_AEX_ID")
	private DDAmbitoExpediente ambitoExpediente;
	
	@ManyToOne
	@JoinColumn(name="EST_ID")
	private Estado estado;
	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	
	@Override
	public Auditoria getAuditoria() {
		 return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		 this.auditoria = auditoria;
		
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setAmbitoExpediente(DDAmbitoExpediente ambitoExpediente) {
		this.ambitoExpediente = ambitoExpediente;
	}

	public DDAmbitoExpediente getAmbitoExpediente() {
		return ambitoExpediente;
	}

	public void setEstado(Estado estado) {
		this.estado = estado;
	}

	public Estado getEstado() {
		return estado;
	}

	public void setDdTipoReglasElevacion(DDTipoReglasElevacion ddTipoReglasElevacion) {
		this.ddTipoReglasElevacion = ddTipoReglasElevacion;
	}

	public DDTipoReglasElevacion getDdTipoReglasElevacion() {
		return ddTipoReglasElevacion;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

}
