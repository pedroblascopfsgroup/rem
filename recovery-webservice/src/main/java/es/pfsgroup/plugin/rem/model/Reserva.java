package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
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
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;


/**
 * Modelo que gestiona la informacion de una reserva
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "RES_RESERVAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Reserva implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "RES_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ReservaGenerator")
    @SequenceGenerator(name = "ReservaGenerator", sequenceName = "S_RES_RESERVA")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
    @Column(name = "RES_NUM_RESERVA")
    private Long numReserva;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAR_ID")
	private DDTiposArras tipoArras;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ERE_ID")
	private DDEstadosReserva estadoReserva;
    
    @Column(name="RES_FECHA_ENVIO")
    private Date fechaEnvio;
    
    @Column(name="RES_FECHA_FIRMA")
    private Date fechaFirma;
    
    @Column(name="RES_FECHA_VENCIMIENTO")
    private Date fechaVencimiento;
    
    @Column(name="RES_FECHA_ANULACION")
    private Date fechaAnulacion;
    
    @Column(name="RES_MOTIVO_ANULACION")
    private String motivoAnulacion;
    
    @OneToMany(mappedBy = "reserva", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "RES_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<EntregaReserva> entregas;
    
    
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


	public Long getNumReserva() {
		return numReserva;
	}

	public void setNumReserva(Long numReserva) {
		this.numReserva = numReserva;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaFirma() {
		return fechaFirma;
	}

	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	}

	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public String getMotivoAnulacion() {
		return motivoAnulacion;
	}

	public void setMotivoAnulacion(String motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public DDTiposArras getTipoArras() {
		return tipoArras;
	}

	public void setTipoArras(DDTiposArras tipoArras) {
		this.tipoArras = tipoArras;
	}

	public DDEstadosReserva getEstadoReserva() {
		return estadoReserva;
	}

	public void setEstadoReserva(DDEstadosReserva estadoReserva) {
		this.estadoReserva = estadoReserva;
	}

	public List<EntregaReserva> getEntregas() {
		return entregas;
	}

	public void setEntregas(List<EntregaReserva> entregas) {
		this.entregas = entregas;
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
