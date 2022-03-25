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
@Table(name = "ACT_HIC_EST_INF_COMER_HIST", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
/*@Where(clause = Auditoria.UNDELETED_RESTICTION)*/
public class ActivoEstadosInformeComercialHistorico implements Serializable , Auditable {
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "HIC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoEstadosInformeComercialHistoricoGenerator")
    @SequenceGenerator(name = "ActivoEstadosInformeComercialHistoricoGenerator", sequenceName = "S_ACT_HIC_EST_INF_COMER_HIST")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_AIC_ID")
    private DDEstadoInformeComercial estadoInformeComercial;

    @Column(name = "HIC_FECHA")
	private Date fecha;
    
    @Column(name = "HIC_MOTIVO")
	private String motivo;
    
    @Column(name = "HIC_RESPONSABLE_CAMBIO")
	private String responsableCambio;
	
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

	public DDEstadoInformeComercial getEstadoInformeComercial() {
		return estadoInformeComercial;
	}

	public void setEstadoInformeComercial(DDEstadoInformeComercial estadoInformeComercial) {
		this.estadoInformeComercial = estadoInformeComercial;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	
	public String getResponsableCambio() {
		return responsableCambio;
	}

	public void setResponsableCambio(String responsableCambio) {
		this.responsableCambio = responsableCambio;
	}
	
}
