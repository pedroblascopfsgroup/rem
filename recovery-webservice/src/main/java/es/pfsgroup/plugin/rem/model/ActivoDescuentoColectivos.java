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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDDescuentosColectivos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;

@Entity
@Table(name = "ACT_DCC_DESCUENTO_COLECTIVOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoDescuentoColectivos implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ADC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoDescuentoColectivosGenerator")
    @SequenceGenerator(name = "ActivoDescuentoColectivosGenerator", sequenceName = "S_ACT_DCC_DESCUENTO_COLECTIVOS")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DCC_ID")
	private DDDescuentosColectivos descuentosColectivos;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID")
	private DDTipoPrecio tipoPrecio;	
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDDescuentosColectivos getDescuentosColectivos() {
		return descuentosColectivos;
	}

	public void setDescuentosColectivos(DDDescuentosColectivos descuentosColectivos) {
		this.descuentosColectivos = descuentosColectivos;
	}

	public DDTipoPrecio getTipoPrecio() {
		return tipoPrecio;
	}

	public void setTipoPrecio(DDTipoPrecio tipoPrecio) {
		this.tipoPrecio = tipoPrecio;
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
