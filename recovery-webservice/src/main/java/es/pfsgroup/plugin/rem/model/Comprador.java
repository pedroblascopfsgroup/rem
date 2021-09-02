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
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOcupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;


/**
 * Modelo que gestiona la informacion de un comprador
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "COM_COMPRADOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Comprador implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "COM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CompradorGenerator")
    @SequenceGenerator(name = "CompradorGenerator", sequenceName = "S_COM_COMPRADOR")
    private Long id;
	
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTiposPersona tipoPersona;
    
    @Column(name = "COM_NOMBRE")
    private String nombre;
    
    @Column(name = "COM_APELLIDOS")
    private String apellidos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
    
    @Column(name = "COM_DOCUMENTO")
    private String documento;
    
    @Column(name = "COM_TELEFONO1")
    private String telefono1;
    
    @Column(name = "COM_TELEFONO2")
    private String telefono2;
    
    @Column(name = "COM_EMAIL")
    private String email;
    
    @Column(name = "COM_DIRECCION")
    private String direccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;
    
    @Column(name = "COM_CODIGO_POSTAL")
    private String codigoPostal; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
    
    @OneToOne
    @JoinColumn(name = "CLC_ID")
    private ClienteComercial clienteComercial;
   
    @Column(name = "ID_COMPRADOR_URSUS")
    private Long idCompradorUrsus;
    
    @Column(name = "ID_COMPRADOR_URSUS_BH")
    private Long idCompradorUrsusBh;
    
    @Column(name = "COM_ENVIADO")
    private Date compradorEnviado;    
    
    @Column(name = "PROBLEMAS_URSUS")
    private Boolean problemasUrsus;
    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
    
	//Se añaden nuevos atributos. HREOS-4851
    @Column(name = "COM_CESION_DATOS")
    private Boolean cesionDatos;
    
    @Column(name = "COM_TRANSF_INTER")
    private Boolean transferenciasInternacionales;
    
    @Column(name = "COM_COMUNI_TERCEROS")
    private Boolean comunicacionTerceros;

    @Column(name = "ID_PERSONA_HAYA")
    private Long idPersonaHaya;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ADCOM_ID")
    private AdjuntoComprador adjunto;
    
    @Column(name = "DD_ECV_ID_URSUS")
    private Long estadoCivilURSUS;
	
    @Column (name = "N_URSUS_CONYUGE")
    private Integer numeroConyugeUrsus;
    
    @Column(name="DD_REM_ID_URSUS")
    private Long regimenMatrimonialUrsus;
    
    @Column(name="NOMBRE_CONYUGE_URSUS")
    private String nombreConyugeURSUS;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TOC_ID")
    private DDTipoOcupacion tipoOcupacion;
    
    @Column(name = "COM_NOMBRE_REPRESENTANTE")
    private String nombreRepresentante;
   
    @Column(name = "COM_APELLIDOS_REPRESENTANTE")
    private String apellidosRepresentante;
    
    @Column(name = "COM_TELEFONO_REPRESENTANTE")
    private String telefonoRepresentante;
    
    @Column(name = "COM_EMAIL_REPRESENTANTE")
    private String emailRepresentante;
    
    @Column(name = "COM_NOMBRE_CONTACTO")
    private String nombreContacto;
    
    @Column(name = "COM_APELLIDOS_CONTACTO")
    private String apellidosContacto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_CONTACTO")
	private DDTipoDocumento tipoDocumentoContacto;
    
    @Column(name = "COM_DOCUMENTO_CONTACTO")
    private String documentoContacto;

    @Column(name = "COM_TELEFONO_CONTACTO")
    private String telefonoContacto;
    
    @Column(name = "COM_EMAIL_CONTACTO")
    private String emailContacto;
    
    @Column(name = "ID_CLIENTE_REM_REPRESENTANTE")
    private Long idClienteRemRepresentante;
    
    @Column(name = "ID_CLIENTE_CONTACTO")
    private Long idClienteContacto;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTiposPersona getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(DDTiposPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
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

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
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

	public String getFullName() {
		
		String fullName = "";
		
		if(!Checks.esNulo(this.getNombre())) {
			fullName = fullName + this.getNombre();
		}
		
		if(!Checks.esNulo(this.getApellidos())) {
			fullName = fullName + " " + this.getApellidos();
		}

		return fullName;
	}

	public ClienteComercial getClienteComercial() {
		return clienteComercial;
	}

	public void setClienteComercial(ClienteComercial clienteComercial) {
		this.clienteComercial = clienteComercial;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}
	
	public Long getIdCompradorUrsus() {
		return idCompradorUrsus;
	}

	public void setIdCompradorUrsus(Long idCompradorUrsus) {
		this.idCompradorUrsus = idCompradorUrsus;
	}    
    
	public Long getIdCompradorUrsusBh() {
		return idCompradorUrsusBh;
	}

	public void setIdCompradorUrsusBh(Long idCompradorUrsusBh) {
		this.idCompradorUrsusBh = idCompradorUrsusBh;
	}

	public Date getCompradorEnviado() {
		return compradorEnviado;
	}

	public void setCompradorEnviado(Date compradorEnviado) {
		this.compradorEnviado = compradorEnviado;
	}

	public Boolean getCesionDatos() {
		return cesionDatos;
	}

	public void setCesionDatos(Boolean cesionDatos) {
		this.cesionDatos = cesionDatos;
	}

	public Boolean getComunicacionTerceros() {
		return comunicacionTerceros;
	}

	public void setComunicacionTerceros(Boolean comunicacionTerceros) {
		this.comunicacionTerceros = comunicacionTerceros;
	}

	public Boolean getTransferenciasInternacionales() {
		return transferenciasInternacionales;
	}

	public void setTransferenciasInternacionales(Boolean transferenciasInternacionales) {
		this.transferenciasInternacionales = transferenciasInternacionales;
	}

	public Long getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(Long idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}
	public AdjuntoComprador getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(AdjuntoComprador adjunto) {
		this.adjunto = adjunto;
	}

	public Boolean getProblemasUrsus() {
		return problemasUrsus;
	}

	public void setProblemasUrsus(Boolean problemasUrsus) {
		this.problemasUrsus = problemasUrsus;
	}

	public Integer getNumeroConyugeUrsus() {
		return numeroConyugeUrsus;
	}

	public void setNumeroConyugeUrsus(Integer numeroConyugeUrsus) {
		this.numeroConyugeUrsus = numeroConyugeUrsus;
	}

	public Long getRegimenMatrimonialUrsus() {
		return regimenMatrimonialUrsus;
	}

	public void setRegimenMatrimonialUrsus(Long regimenMatrimonialUrsus) {
		this.regimenMatrimonialUrsus = regimenMatrimonialUrsus;
	}

	public Long getEstadoCivilURSUS() {
		return estadoCivilURSUS;
	}

	public void setEstadoCivilURSUS(Long estadoCivilURSUS) {
		this.estadoCivilURSUS = estadoCivilURSUS;
	}

	public String getNombreConyugeURSUS() {
		return nombreConyugeURSUS;
	}

	public void setNombreConyugeURSUS(String nombreConyugeURSUS) {
		this.nombreConyugeURSUS = nombreConyugeURSUS;
	}

	public DDTipoOcupacion getTipoOcupacion() {
		return tipoOcupacion;
	}

	public void setTipoOcupacion(DDTipoOcupacion tipoOcupacion) {
		this.tipoOcupacion = tipoOcupacion;
	}

	public String getNombreRepresentante() {
		return nombreRepresentante;
	}

	public void setNombreRepresentante(String nombreRepresentante) {
		this.nombreRepresentante = nombreRepresentante;
	}

	public String getApellidosRepresentante() {
		return apellidosRepresentante;
	}

	public void setApellidosRepresentante(String apellidosRepresentante) {
		this.apellidosRepresentante = apellidosRepresentante;
	}

	public String getTelefonoRepresentante() {
		return telefonoRepresentante;
	}

	public void setTelefonoRepresentante(String telefonoRepresentante) {
		this.telefonoRepresentante = telefonoRepresentante;
	}

	public String getEmailRepresentante() {
		return emailRepresentante;
	}

	public void setEmailRepresentante(String emailRepresentante) {
		this.emailRepresentante = emailRepresentante;
	}

	public String getNombreContacto() {
		return nombreContacto;
	}

	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}

	public String getApellidosContacto() {
		return apellidosContacto;
	}

	public void setApellidosContacto(String apellidosContacto) {
		this.apellidosContacto = apellidosContacto;
	}

	public DDTipoDocumento getTipoDocumentoContacto() {
		return tipoDocumentoContacto;
	}

	public void setTipoDocumentoContacto(DDTipoDocumento tipoDocumentoContacto) {
		this.tipoDocumentoContacto = tipoDocumentoContacto;
	}

	public String getDocumentoContacto() {
		return documentoContacto;
	}

	public void setDocumentoContacto(String documentoContacto) {
		this.documentoContacto = documentoContacto;
	}

	public String getTelefonoContacto() {
		return telefonoContacto;
	}

	public void setTelefonoContacto(String telefonoContacto) {
		this.telefonoContacto = telefonoContacto;
	}

	public String getEmailContacto() {
		return emailContacto;
	}

	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}

	public Long getIdClienteRemRepresentante() {
		return idClienteRemRepresentante;
	}

	public void setIdClienteRemRepresentante(Long idClienteRemRepresentante) {
		this.idClienteRemRepresentante = idClienteRemRepresentante;
	}

	public Long getIdClienteContacto() {
		return idClienteContacto;
	}

	public void setIdClienteContacto(Long idClienteContacto) {
		this.idClienteContacto = idClienteContacto;
	}	
	
}
