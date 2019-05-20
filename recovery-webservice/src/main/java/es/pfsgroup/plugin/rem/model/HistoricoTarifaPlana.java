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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

@Entity
@Table(name = "HIST_TP_TARIFA_PLANA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoTarifaPlana implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6888318348494911601L;

	@Id
    @Column(name = "HIST_TP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoTarifaPlanaGenerator")
    @SequenceGenerator(name = "HistoricoTarifaPlanaGenerator", sequenceName = "S_HIST_TP_TARIFA_PLANA")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STR_ID")
	DDSubtipoTrabajo subtipoTrabajo;
	
	@Column(name = "STR_TARIFA_PLANA")
	Boolean esTarifaPlana;
	
	@Column(name = "STR_FECHA_INI_TP")
	Date fechaInicioTarifaPlana;
	
	@Column(name = "STR_FECHA_FIN_TP")
	Date fechaFinTarifaPlana;
	
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
	DDCartera carteraTP;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public Boolean getEsTarifaPlana() {
		return esTarifaPlana;
	}

	public void setEsTarifaPlana(Boolean esTarifaPlana) {
		this.esTarifaPlana = esTarifaPlana;
	}

	public Date getFechaInicioTarifaPlana() {
		return fechaInicioTarifaPlana;
	}

	public void setFechaInicioTarifaPlana(Date fechaInicioTarifaPlana) {
		this.fechaInicioTarifaPlana = fechaInicioTarifaPlana;
	}

	public Date getFechaFinTarifaPlana() {
		return fechaFinTarifaPlana;
	}

	public void setFechaFinTarifaPlana(Date fechaFinTarifaPlana) {
		this.fechaFinTarifaPlana = fechaFinTarifaPlana;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	public DDCartera getCarteraTP() {
		return carteraTP;
	}

	public void setCarteraTP(DDCartera carteraTP) {
		this.carteraTP = carteraTP;
	}
}
