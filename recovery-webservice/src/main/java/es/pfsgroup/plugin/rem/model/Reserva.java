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
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAmpliacionArras;
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
    @SequenceGenerator(name = "ReservaGenerator", sequenceName = "S_RES_RESERVAS")
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
    
    @Column(name="RES_FECHA_SOLICITUD")
    private Date fechaSolicitud;
    
    @Column(name="RES_FECHA_RESOLUCION")
    private Date fechaResolucion;
    
    @Column(name="RES_IND_IMP_ANULACION")
    private Integer indicadorDevolucionReserva;
    
    @Column(name="RES_IMPORTE_DEVUELTO")
    private Double importeDevuelto;
    
    @Column(name="RES_FECHA_CONTABILIZACION")
    private Date fechaContabilizacionReserva; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EDE_ID")
	private DDEstadoDevolucion estadoDevolucion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DER_ID")
	private DDDevolucionReserva devolucionReserva;
    
    @Column(name="RES_FECHA_VIGENCIA_ARRAS")
    private Date fechaVigenciaArras;
    
    @Column(name="RES_FECHA_AMPLIACION_ARRAS")
    private Date fechaAmpliacionArras;
    
    @Column(name="RES_SOLICITUD_AMPLIACION_ARRAS")
    private String solicitudAmpliacionArras;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MAA_ID")
	private DDMotivoAmpliacionArras motivoAmpliacionArras;

	@Column(name="RES_FECHA_CONT_ARRAS")
	private Date fechaContArras;
    
    @Column(name="RES_FECHA_PROR_PROP_ARRAS")
    private Date fechaPropuestaProrrogaArras;
    
    @Column(name="RES_FECHA_COM_CLIENTE")
    private Date fechaComunicacionCliente;
    
    @Column(name="RES_FECHA_COM_CLIENTE_RESC")
    private Date fechaComunicacionClienteRescision;
    
    @Column(name="RES_FECHA_RESCISION")
    private Date fechaFirmaRescision;
    
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

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

	public Integer getIndicadorDevolucionReserva() {
		return indicadorDevolucionReserva;
	}

	public void setIndicadorDevolucionReserva(Integer indicadorDevolucionReserva) {
		this.indicadorDevolucionReserva = indicadorDevolucionReserva;
	}

	public Double getImporteDevuelto() {
		return importeDevuelto;
	}

	public void setImporteDevuelto(Double importeDevuelto) {
		this.importeDevuelto = importeDevuelto;
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

	public DDEstadoDevolucion getEstadoDevolucion() {
		return estadoDevolucion;
	}

	public void setEstadoDevolucion(DDEstadoDevolucion estadoDevolucion) {
		this.estadoDevolucion = estadoDevolucion;
	}

	public DDDevolucionReserva getDevolucionReserva() {
		return devolucionReserva;
	}

	public void setDevolucionReserva(DDDevolucionReserva devolucionReserva) {
		this.devolucionReserva = devolucionReserva;
	}

	public Date getFechaContabilizacionReserva() {
		return fechaContabilizacionReserva;
	}

	public void setFechaContabilizacionReserva(Date fechaContabilizacionReserva) {
		this.fechaContabilizacionReserva = fechaContabilizacionReserva;
	}

	public Date getFechaVigenciaArras() {
		return fechaVigenciaArras;
	}

	public void setFechaVigenciaArras(Date fechaVigenciaArras) {
		this.fechaVigenciaArras = fechaVigenciaArras;
	}

	public Date getFechaAmpliacionArras() {
		return fechaAmpliacionArras;
	}

	public void setFechaAmpliacionArras(Date fechaAmpliacionArras) {
		this.fechaAmpliacionArras = fechaAmpliacionArras;
	}

	public String getSolicitudAmpliacionArras() {
		return solicitudAmpliacionArras;
	}

	public void setSolicitudAmpliacionArras(String solicitudAmpliacionArras) {
		this.solicitudAmpliacionArras = solicitudAmpliacionArras;
	}

	public DDMotivoAmpliacionArras getMotivoAmpliacionArras() {
		return motivoAmpliacionArras;
	}

	public void setMotivoAmpliacionArras(DDMotivoAmpliacionArras motivoAmpliacionArras) {
		this.motivoAmpliacionArras = motivoAmpliacionArras;
	}

	public Date getFechaContArras() {
		return fechaContArras;
	}

	public void setFechaContArras(Date fechaContArras) {
		this.fechaContArras = fechaContArras;
	}
	public Date getFechaPropuestaProrrogaArras() {
		return fechaPropuestaProrrogaArras;
	}

	public void setFechaPropuestaProrrogaArras(Date fechaPropuestaProrrogaArras) {
		this.fechaPropuestaProrrogaArras = fechaPropuestaProrrogaArras;
	}

	public Date getFechaComunicacionCliente() {
		return fechaComunicacionCliente;
	}

	public void setFechaComunicacionCliente(Date fechaComunicacionCliente) {
		this.fechaComunicacionCliente = fechaComunicacionCliente;
	}

	public Date getFechaComunicacionClienteRescision() {
		return fechaComunicacionClienteRescision;
	}

	public void setFechaComunicacionClienteRescision(Date fechaComunicacionClienteRescision) {
		this.fechaComunicacionClienteRescision = fechaComunicacionClienteRescision;
	}

	public Date getFechaFirmaRescision() {
		return fechaFirmaRescision;
	}

	public void setFechaFirmaRescision(Date fechaFirmaRescision) {
		this.fechaFirmaRescision = fechaFirmaRescision;
	} 

}
