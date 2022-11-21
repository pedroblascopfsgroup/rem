package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

/**
 * Modelo que gestiona la informacion del historico de antiguos deudores
 *
 */

@Entity
@Table(name = "HAD_HIST_ANTIGUO_DEUDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoAntiguoDeudor implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "HAD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoAntiguoDeudorGenerator")
    @SequenceGenerator(name = "HistoricoAntiguoDeudorGenerator", sequenceName = "S_HAD_HIST_ANTIGUO_DEUDOR")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HAD_LOCALIZABLE")
	private DDSinSiNo localizable;
	
	@Column(name = "HAD_FECHA_ILOCALIZABLE")
	private Date fechaIlocalizable;
	
	@Column(name = "HAD_MOTIVO")
	private String motivo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEB_ID")
    private DDEstadoExpedienteBc estadoExpedienteBc;
	
	@Column(name = "HAD_FECHA_LOCALIZADO")
	private Date fechaLocalizado;
	
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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public DDSinSiNo getLocalizable() {
		return localizable;
	}

	public void setLocalizable(DDSinSiNo localizable) {
		this.localizable = localizable;
	}

	public Date getFechaIlocalizable() {
		return fechaIlocalizable;
	}

	public void setFechaIlocalizable(Date fechaIlocalizable) {
		this.fechaIlocalizable = fechaIlocalizable;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public DDEstadoExpedienteBc getEstadoExpedienteBc() {
		return estadoExpedienteBc;
	}

	public void setEstadoExpedienteBc(DDEstadoExpedienteBc estadoExpedienteBc) {
		this.estadoExpedienteBc = estadoExpedienteBc;
	}

	public Date getFechaLocalizado() {
		return fechaLocalizado;
	}

	public void setFechaLocalizado(Date fechaLocalizado) {
		this.fechaLocalizado = fechaLocalizado;
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