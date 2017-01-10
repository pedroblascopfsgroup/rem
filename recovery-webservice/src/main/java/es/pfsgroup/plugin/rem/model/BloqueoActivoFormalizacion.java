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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDAreaBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueo;

/**
 * Modelo que gestiona la informacion del bloqueo de expedientes en su formalización.
 */
@Entity
@Table(name = "ACT_BEX_BLOQ_EXP_FORMALIZAR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BloqueoActivoFormalizacion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ACT_BEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "BloqueoActivoFormalizacionGenerator")
    @SequenceGenerator(name = "BloqueoActivoFormalizacionGenerator", sequenceName = "S_ACT_BEX_BLOQ_EXP_FORMALIZAR")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_ABL_ID")
    private DDAreaBloqueo area; 

    @ManyToOne
    @JoinColumn(name = "DD_TBL_ID")
    private DDTipoBloqueo tipo;

    @ManyToOne
    @JoinColumn(name = "ACT_BEX_ECO_ID")
    private ExpedienteComercial expediente;

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
	
	public DDAreaBloqueo getArea() {
		return area;
	}

	public void setArea(DDAreaBloqueo area) {
		this.area = area;
	}

	public DDTipoBloqueo getTipo() {
		return tipo;
	}

	public void setTipo(DDTipoBloqueo tipo) {
		this.tipo = tipo;
	}

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
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