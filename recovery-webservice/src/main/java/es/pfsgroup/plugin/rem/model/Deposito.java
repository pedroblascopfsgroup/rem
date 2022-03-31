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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDeposito;

@Entity
@Table(name = "DEP_DEPOSITO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Deposito implements Serializable, Auditable {

    private static final long serialVersionUID = -83911589408025818L;

    @Id
    @Column(name = "DEP_ID", updatable = false, nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "DepositoGenerator")
    @SequenceGenerator(name = "DepositoGenerator", sequenceName = "S_DEP_DEPOSITO", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EDP_ID")
	private DDEstadoDeposito estadoDeposito;
    
	@Column(name="DEP_IMPORTE")
	private Double importe;
    
	@Column(name="DEP_FECHA_INGRESO")
	private Date fechaIngreso;
	
	@Column(name="DEP_FECHA_DEVOLUCION")
	private Date fechaDevolucion;
	
	@Column(name="DEP_IBAN_DEVOLUCION")
	private String ibanDevolucion;
	
    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}


	public DDEstadoDeposito getEstadoDeposito() {
		return estadoDeposito;
	}

	public void setEstadoDeposito(DDEstadoDeposito estadoDeposito) {
		this.estadoDeposito = estadoDeposito;
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

	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}

	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}

	public String getIbanDevolucion() {
		return ibanDevolucion;
	}

	public void setIbanDevolucion(String ibanDevolucion) {
		this.ibanDevolucion = ibanDevolucion;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

    
}
