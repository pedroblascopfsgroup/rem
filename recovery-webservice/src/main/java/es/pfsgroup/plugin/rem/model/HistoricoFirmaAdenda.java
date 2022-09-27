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

/**
 * Modelo que gestiona el modelo de Albaranes para la gestión, 
 * flujo e información de los trabajos.
 * 
 * @author Alberto Flores
 */
@Entity
@Table(name = "HFA_HIST_FIRMA_ADENDA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoFirmaAdenda implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "HFA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoFirmaAdendaGenerator")
	@SequenceGenerator(name = "HistoricoFirmaAdendaGenerator", sequenceName = "S_HFA_HIST_FIRMA_ADENDA")
	private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

	@Column(name = "HFA_FIRMADO")
	private Boolean firmadoAdenda;
	
	@Column(name = "HFA_FECHA")
	private Date fechaAdenda;

	@Column(name = "HFA_MOTIVO")
	private String motivoAdenda;
	
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

	public Boolean getFirmadoAdenda() {
		return firmadoAdenda;
	}

	public void setFirmadoAdenda(Boolean firmadoAdenda) {
		this.firmadoAdenda = firmadoAdenda;
	}

	public Date getFechaAdenda() {
		return fechaAdenda;
	}

	public void setFechaAdenda(Date fechaAdenda) {
		this.fechaAdenda = fechaAdenda;
	}

	public String getMotivoAdenda() {
		return motivoAdenda;
	}

	public void setMotivoAdenda(String motivoAdenda) {
		this.motivoAdenda = motivoAdenda;
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
