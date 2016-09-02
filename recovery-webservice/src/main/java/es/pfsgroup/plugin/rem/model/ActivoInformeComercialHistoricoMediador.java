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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;

/**
 * Modelo que gestiona el historico de estados del Informe Comercial del activo.
 */
@Entity
@Table(name = "ACT_ICM_INF_COMER_HIST_MEDI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
/*@Where(clause = Auditoria.UNDELETED_RESTICTION)*/
public class ActivoInformeComercialHistoricoMediador implements Serializable , Auditable {
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ICM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInformeComercialHistoricoMediadorGenerator")
    @SequenceGenerator(name = "ActivoInformeComercialHistoricoMediadorGenerator", sequenceName = "S_ACT_ICM_INF_COMER_HIST_MEDI")
    private Long id;

    @Column(name = "ICM_FECHA_DESDE")
	private Date fechaDesde;
    
    @Column(name = "ICM_FECHA_HASTA")
	private Date fechaHasta;
    
	@ManyToOne
    @JoinColumn(name = "ICO_MEDIADOR_ID")
    private ActivoProveedor mediadorInforme;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public Date getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public ActivoProveedor getMediadorInforme() {
		return mediadorInforme;
	}

	public void setMediadorInforme(ActivoProveedor mediadorInforme) {
		this.mediadorInforme = mediadorInforme;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}
	
}
