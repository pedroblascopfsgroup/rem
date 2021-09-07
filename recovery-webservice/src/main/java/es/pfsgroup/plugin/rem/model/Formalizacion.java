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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRiesgoClase;


/**
 * Modelo que gestiona la informacion de la formalización de un expediente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "FOR_FORMALIZACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Formalizacion implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "FOR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FormalizacionGenerator")
    @SequenceGenerator(name = "FormalizacionGenerator", sequenceName = "S_FOR_FORMALIZACION")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@Column(name="FOR_NOMBRE_NOTARIO")
	private String nombreNotario;
	
	@Column(name="FOR_DIRECCION_NOTARIO")
	private String direccionNotario;
	
	@Column(name="FOR_CONTACTO_NOTARIO")
	private String contactoNotario;
	
	@Column(name="FOR_CONTACTO_CARGO")
	private String contactoNotarioCargo;	
	
	@Column(name="FOR_CONTACTO_EMAIL")
	private String contactoNotarioEmail;
	
	@Column(name="FOR_CONTACTO_TELEFONO")
	private String contactoNotarioTelefono;	
	
	@Column(name="FOR_PETICIONARIO")
	private String peticionario;
	
	@Column(name="FOR_FECHA_PETICION")
	private Date fechaPeticion;
	
	@Column(name="FOR_FECHA_ESCRITURA")
	private Date fechaEscritura;
	
	@Column(name="FOR_FECHA_CONTABILIZACION")
	private Date fechaContabilizacion;
	
	@Column(name="FOR_FECHA_RESOLUCION")
	private Date fechaResolucion;
	
	@Column(name="FOR_FECHA_PAGO")
	private Date fechaPago;
	
	@Column(name="FOR_FORMA_PAGO")
	private String formaPago;
	
	@Column(name="FOR_GASTOS_CARGO")
	private String gastosCargo;
	
	@Column(name="FOR_MOTIVO_RESOLUCION")
	private String motivoResolucion;
	
	@Column(name="FOR_IMPORTE")
	private Double importe;

	@ManyToOne
	@JoinColumn(name = "DD_TRC_ID")
    private DDTipoRiesgoClase tipoRiesgoClase;
    
    @Column(name = "FOR_NUMEXPEDIENTE")
    private String numExpediente;
    
    @Column(name = "FOR_CAPITALCONCEDIDO")
    private Double capitalConcedido;	
	
    @Column(name="FOR_VENTA_PLAZOS")
	private Boolean ventaPlazos;
    
    @Column(name="FOR_VENTA_COND_SUPENSIVA")
	private Boolean ventaCondicionSupensiva;
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public String getNombreNotario() {
		return nombreNotario;
	}

	public void setNombreNotario(String nombreNotario) {
		this.nombreNotario = nombreNotario;
	}

	public String getDireccionNotario() {
		return direccionNotario;
	}

	public void setDireccionNotario(String direccionNotario) {
		this.direccionNotario = direccionNotario;
	}

	public String getContactoNotario() {
		return contactoNotario;
	}

	public void setContactoNotario(String contactoNotario) {
		this.contactoNotario = contactoNotario;
	}

	public String getContactoNotarioCargo() {
		return contactoNotarioCargo;
	}

	public void setContactoNotarioCargo(String contactoNotarioCargo) {
		this.contactoNotarioCargo = contactoNotarioCargo;
	}

	public String getContactoNotarioEmail() {
		return contactoNotarioEmail;
	}

	public void setContactoNotarioEmail(String contactoNotarioEmail) {
		this.contactoNotarioEmail = contactoNotarioEmail;
	}

	public String getContactoNotarioTelefono() {
		return contactoNotarioTelefono;
	}

	public void setContactoNotarioTelefono(String contactoNotarioTelefono) {
		this.contactoNotarioTelefono = contactoNotarioTelefono;
	}

	public String getPeticionario() {
		return peticionario;
	}

	public void setPeticionario(String peticionario) {
		this.peticionario = peticionario;
	}

	public Date getFechaPeticion() {
		return fechaPeticion;
	}

	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}

	public Date getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public String getFormaPago() {
		return formaPago;
	}

	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}

	public String getGastosCargo() {
		return gastosCargo;
	}

	public void setGastosCargo(String gastosCargo) {
		this.gastosCargo = gastosCargo;
	}

	public String getMotivoResolucion() {
		return motivoResolucion;
	}

	public void setMotivoResolucion(String motivoResolucion) {
		this.motivoResolucion = motivoResolucion;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
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

	public Date getFechaEscritura() {
		return fechaEscritura;
	}

	public void setFechaEscritura(Date fechaEscritura) {
		this.fechaEscritura = fechaEscritura;
	}

	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}

	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}
    
    public DDTipoRiesgoClase getTipoRiesgoClase() {
		return tipoRiesgoClase;
	}

	public void setTipoRiesgoClase(DDTipoRiesgoClase tipoRiesgoClase) {
		this.tipoRiesgoClase = tipoRiesgoClase;
	}

	public String getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}

	public Double getCapitalConcedido() {
		return capitalConcedido;
	}

	public void setCapitalConcedido(Double capitalConcedido) {
		this.capitalConcedido = capitalConcedido;
	}

	public Boolean getVentaPlazos() {
		return ventaPlazos;
	}

	public void setVentaPlazos(Boolean ventaPlazos) {
		this.ventaPlazos = ventaPlazos;
	}

	public Boolean getVentaCondicionSupensiva() {
		return ventaCondicionSupensiva;
	}

	public void setVentaCondicionSupensiva(Boolean ventaCondicionSupensiva) {
		this.ventaCondicionSupensiva = ventaCondicionSupensiva;
	}
    
    
   
}
