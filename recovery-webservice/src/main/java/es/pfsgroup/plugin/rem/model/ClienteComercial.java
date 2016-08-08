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
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;


/**
 * Modelo que gestiona la informacion de un cliente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "CLI_CLIENTE_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ClienteComercial implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "CLC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ClienteComercialGenerator")
    @SequenceGenerator(name = "ClienteComercialGenerator", sequenceName = "S_CLC_CLIENTE_COMERCIAL")
    private Long id;
	
    @Column(name = "CLC_WEBCOM_ID")
    private Long idWebCom;
    
    @Column(name = "CLC_RAZON_SOCIAL")
    private String razonSocial;
    
    @Column(name = "CLC_NOMBRE")
    private String nombre;
    
    @Column(name = "CLC_APELLIDOS")
    private String apellidos;
    
    @Column(name = "CLC_FECHA_ACCION")
    private Date fechaAccion;
    
    @Column(name = "USU_ID")
    private Usuario usuarioAccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
    
    @Column(name = "CLC_DOCUMENTO")
    private String documento;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_REPRESENTANTE	")
	private DDTipoDocumento tipoDocumentoRepresentante;
    
    @Column(name = "CLC_DOCUMENTO_REPRESENTANTE")
    private String documentoRepresentante;
    
    @Column(name = "CLC_TELEFONO1")
    private String telefono1;
    
    @Column(name = "CLC_TELEFONO2")
    private String telefono2;
    
    @Column(name = "CLC_EMAIL")
    private String email;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID")
	private ActivoProveedor prescriptor;
    
    @Column(name = "CLC_API_RESPONSABLE")
    private String apiResponsable;
    
    @Column(name = "CLC_DIRECCION")
    private String direccion;
    
    @Column(name = "CLC_MUNICIPIO")
    private String municipio;
    
    @Column(name = "CLC_CODIGO_POSTAL")
    private String codigoPostal;
    
    @Column(name = "CLC_PROVINCIA")
    private String provincia;
    
    @Column(name = "CLC_OBSERVACIONES")
    private String observaciones;
    
   
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

	public Long getIdWebCom() {
		return idWebCom;
	}

	public void setIdWebCom(Long idWebCom) {
		this.idWebCom = idWebCom;
	}

	public String getRazonSocial() {
		return razonSocial;
	}

	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Usuario getUsuarioAccion() {
		return usuarioAccion;
	}

	public void setUsuarioAccion(Usuario usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}

	public DDTipoDocumento getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoDocumento tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getDocumento() {
		return documento;
	}

	public void setDocumento(String documento) {
		this.documento = documento;
	}

	public DDTipoDocumento getTipoDocumentoRepresentante() {
		return tipoDocumentoRepresentante;
	}

	public void setTipoDocumentoRepresentante(
			DDTipoDocumento tipoDocumentoRepresentante) {
		this.tipoDocumentoRepresentante = tipoDocumentoRepresentante;
	}

	public String getDocumentoRepresentante() {
		return documentoRepresentante;
	}

	public void setDocumentoRepresentante(String documentoRepresentante) {
		this.documentoRepresentante = documentoRepresentante;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	public String getTelefono2() {
		return telefono2;
	}

	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getApiResponsable() {
		return apiResponsable;
	}

	public void setApiResponsable(String apiResponsable) {
		this.apiResponsable = apiResponsable;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public ActivoProveedor getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(ActivoProveedor prescriptor) {
		this.prescriptor = prescriptor;
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
