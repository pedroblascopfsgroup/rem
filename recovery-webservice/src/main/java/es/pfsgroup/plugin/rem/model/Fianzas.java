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
 * Modelo que gestiona la tabla de cuentas virtuales 
 * 
 * 
 * @author IRF
 */
@Entity
@Table(name = "FIA_FIANZAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Fianzas implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "FIA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "FianzasGenerator")
	@SequenceGenerator(name = "FianzasGenerator", sequenceName = "S_FIA_FIANZAS")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "OFR_ID")
	private Oferta oferta;
	
	@Column(name = "FIA_FECHA_AGENDACION_INGRESO")
	private Date fechaAgendacionIngreso;
	
	@Column(name = "FIA_IMPORTE")
	private Double importe;
	
	@Column(name = "FIA_FECHA_INGRESO")
	private Date fechaIngreso;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CVA_ID")
	private CuentasVirtualesAlquiler cuentaVirtualAlquiler;
	
	@Column(name = "FIA_IBAN_DEVOLUCION")
	private String ibanDevolucion;
	
	@Column(name = "ENTREGA_FIANZA_AAPP")
    private Boolean entregaFianzaAapp;
	
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

	public Date getFechaAgendacionIngreso() {
		return fechaAgendacionIngreso;
	}

	public void setFechaAgendacionIngreso(Date fechaAgendacionIngreso) {
		this.fechaAgendacionIngreso = fechaAgendacionIngreso;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFechaIngreso() {
		return fechaIngreso;
	}

	public void setFechaIngreso(Date fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}

	public CuentasVirtualesAlquiler getCuentaVirtualAlquiler() {
		return cuentaVirtualAlquiler;
	}

	public void setCuentaVirtualAlquiler(CuentasVirtualesAlquiler cuentaVirtualAlquiler) {
		this.cuentaVirtualAlquiler = cuentaVirtualAlquiler;
	}

	public String getIbanDevolucion() {
		return ibanDevolucion;
	}

	public void setIbanDevolucion(String ibanDevolucion) {
		this.ibanDevolucion = ibanDevolucion;
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

	public Boolean getEntregaFianzaAapp() {
		return entregaFianzaAapp;
	}

	public void setEntregaFianzaAapp(Boolean entregaFianzaAapp) {
		this.entregaFianzaAapp = entregaFianzaAapp;
	}
	
}
