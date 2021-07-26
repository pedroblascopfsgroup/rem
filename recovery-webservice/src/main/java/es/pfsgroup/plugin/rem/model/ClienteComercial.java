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
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTiposColaborador;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;


/**
 * Modelo que gestiona la informacion de un cliente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "CLC_CLIENTE_COMERCIAL", schema = "${entity.schema}")
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
    private Long idClienteWebcom;
    
    @Column(name = "CLC_REM_ID")
    private Long idClienteRem;
    
    @Column(name = "CLC_RAZON_SOCIAL")
    private String razonSocial;
    
    @Column(name = "CLC_NOMBRE")
    private String nombre;
    
    @Column(name = "CLC_APELLIDOS")
    private String apellidos;
    
    @Column(name = "CLC_FECHA_ALTA")
    private Date fechaAlta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioAccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
    
    @Column(name = "CLC_DOCUMENTO")
    private String documento;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_REPRESENTANTE")
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
    @JoinColumn(name = "DD_TPC_ID")
	private DDTiposColaborador tipoColaborador;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_PRESCRIPTOR")
	private ActivoProveedor provPrescriptor;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_RESPONSABLE")
	private ActivoProveedor provApiResponsable;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVI_ID")
	private DDTipoVia tipoVia;
    
    @Column(name = "CLC_DIRECCION")
    private String direccion;
    
    @Column(name = "CLC_NUMEROCALLE")
    private String numeroCalle;
    
    @Column(name = "CLC_ESCALERA")
    private String escalera;
    
    @Column(name = "CLC_PLANTA")
    private String planta;
    
    @Column(name = "CLC_PUERTA")
    private String puerta;
    
    @Column(name = "CLC_CODIGO_POSTAL")
    private String codigoPostal;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad municipio;
      
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_UPO_ID")
	private DDUnidadPoblacional unidadPoblacional;
    
    @Column(name = "CLC_OBSERVACIONES")
    private String observaciones;
    
    
    //Se añaden nuevos atributos petición HREOS-1395
    @Column(name = "CLC_RECHAZA_PUBLI")
    private Boolean rechazaPublicidad;
    
    @Column(name = "CLC_ID_SALESFORCE")
    private String idClienteSalesforce;
    
    @Column(name = "CLC_TELF_CONTACTO_VIS")
    private String telefonoContactoVisitas;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPE_ID")
	private DDTiposPersona tipoPersona;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ECV_ID")
	private DDEstadosCiviles estadoCivil;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_REM_ID")
	private DDRegimenesMatrimoniales regimenMatrimonial;
    
	//Se añaden nuevos atributos. HREOS-4851
    @Column(name = "CLC_CESION_DATOS")
    private Boolean cesionDatos;
    
    @Column(name = "CLC_COMUNI_TERCEROS")
    private Boolean comunicacionTerceros;
    
    @Column(name = "CLC_TRANSF_INTER")
    private Boolean transferenciasInternacionales;
	
    @Column(name = "CLC_ID_PERSONA_HAYA")
    private String idPersonaHaya;

    //REMVIP-3846
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_CONYUGE")
	private DDTipoDocumento tipoDocumentoConyuge;
    
    @Column(name="CLC_DOCUMENTO_CONYUGE")
    private String documentoConyuge;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_ID")
    private DDPaises pais;
    
    @Column(name = "CLC_DIRECCION_RTE")
    private String direccionRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID_RTE")
    private DDProvincia provinciaRepresentante;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID_RTE")
    private Localidad municipioRepresentante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_ID_RTE")
    private DDPaises paisRepresentante;
    
    @Column(name = "CLC_CODIGO_POSTAL_RTE")
    private String codigoPostalRepresentante;

	@Column(name = "CLC_C4C_ID")
	private Long idC4c;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IAP_ID")
	private InfoAdicionalPersona infoAdicionalPersona;
    
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

	public Long getIdClienteWebcom() {
		return idClienteWebcom;
	}

	public void setIdClienteWebcom(Long idClienteWebcom) {
		this.idClienteWebcom = idClienteWebcom;
	}

	public Long getIdClienteRem() {
		return idClienteRem;
	}

	public void setIdClienteRem(Long idClienteRem) {
		this.idClienteRem = idClienteRem;
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

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
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

	public DDTiposColaborador getTipoColaborador() {
		return tipoColaborador;
	}

	public void setTipoColaborador(DDTiposColaborador tipoColaborador) {
		this.tipoColaborador = tipoColaborador;
	}

	public ActivoProveedor getProvPrescriptor() {
		return provPrescriptor;
	}

	public void setProvPrescriptor(ActivoProveedor provPrescriptor) {
		this.provPrescriptor = provPrescriptor;
	}

	public ActivoProveedor getProvApiResponsable() {
		return provApiResponsable;
	}

	public void setProvApiResponsable(ActivoProveedor provApiResponsable) {
		this.provApiResponsable = provApiResponsable;
	}

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getNumeroCalle() {
		return numeroCalle;
	}

	public void setNumeroCalle(String numeroCalle) {
		this.numeroCalle = numeroCalle;
	}

	public String getEscalera() {
		return escalera;
	}

	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}

	public String getPlanta() {
		return planta;
	}

	public void setPlanta(String planta) {
		this.planta = planta;
	}

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}
	
	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}
	
	public Localidad getMunicipio() {
		return municipio;
	}

	public void setMunicipio(Localidad municipio) {
		this.municipio = municipio;
	}

	public DDUnidadPoblacional getUnidadPoblacional() {
		return unidadPoblacional;
	}

	public void setUnidadPoblacional(DDUnidadPoblacional unidadPoblacional) {
		this.unidadPoblacional = unidadPoblacional;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
	
	public String getNombreCompleto(){
		String nombre= "";
		if(!Checks.esNulo(this.razonSocial)){
			nombre= this.razonSocial;
		}
		else if(!Checks.esNulo(this.nombre)){
			if(!Checks.esNulo(this.apellidos)){
				nombre= this.nombre + " " + this.apellidos;
			}
			else{
				nombre= this.nombre;
			}
		}
		else if(!Checks.esNulo(this.apellidos)){
				nombre= this.apellidos;
		}
		
		return nombre;
	}

	public Boolean getRechazaPublicidad() {
		return rechazaPublicidad;
	}

	public void setRechazaPublicidad(Boolean rechazaPublicidad) {
		this.rechazaPublicidad = rechazaPublicidad;
	}

	public String getIdClienteSalesforce() {
		return idClienteSalesforce;
	}

	public void setIdClienteSalesforce(String idClienteSalesforce) {
		this.idClienteSalesforce = idClienteSalesforce;
	}

	public String getTelefonoContactoVisitas() {
		return telefonoContactoVisitas;
	}

	public void setTelefonoContactoVisitas(String telefonoContactoVisitas) {
		this.telefonoContactoVisitas = telefonoContactoVisitas;
	}

	public DDTiposPersona getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(DDTiposPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public DDEstadosCiviles getEstadoCivil() {
		return estadoCivil;
	}

	public void setEstadoCivil(DDEstadosCiviles estadoCivil) {
		this.estadoCivil = estadoCivil;
	}

	public DDRegimenesMatrimoniales getRegimenMatrimonial() {
		return regimenMatrimonial;
	}

	public void setRegimenMatrimonial(DDRegimenesMatrimoniales regimenMatrimonial) {
		this.regimenMatrimonial = regimenMatrimonial;
	}
	
	public Boolean getCesionDatos() {
		return cesionDatos;
	}
//Get and Set de los objetos creados en HREOS-4851
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
	
	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}

	public DDPaises getPais() {
		return pais;
	}

	public void setPais(DDPaises pais) {
		this.pais = pais;
	}

	public String getDireccionRepresentante() {
		return direccionRepresentante;
	}

	public void setDireccionRepresentante(String direccionRepresentante) {
		this.direccionRepresentante = direccionRepresentante;
	}

	public DDProvincia getProvinciaRepresentante() {
		return provinciaRepresentante;
	}

	public void setProvinciaRepresentante(DDProvincia provinciaRepresentante) {
		this.provinciaRepresentante = provinciaRepresentante;
	}

	public Localidad getMunicipioRepresentante() {
		return municipioRepresentante;
	}

	public void setMunicipioRepresentante(Localidad municipioRepresentante) {
		this.municipioRepresentante = municipioRepresentante;
	}

	public DDPaises getPaisRepresentante() {
		return paisRepresentante;
	}

	public void setPaisRepresentante(DDPaises paisRepresentante) {
		this.paisRepresentante = paisRepresentante;
	}

	public String getCodigoPostalRepresentante() {
		return codigoPostalRepresentante;
	}

	public void setCodigoPostalRepresentante(String codigoPostalRepresentante) {
		this.codigoPostalRepresentante = codigoPostalRepresentante;
	}

	public DDTipoDocumento getTipoDocumentoConyuge() {
		return tipoDocumentoConyuge;
	}

	public void setTipoDocumentoConyuge(DDTipoDocumento tipoDocumentoConyuge) {
		this.tipoDocumentoConyuge = tipoDocumentoConyuge;
	}

	public String getDocumentoConyuge() {
		return documentoConyuge;
	}

	public void setDocumentoConyuge(String documentoConyuge) {
		this.documentoConyuge = documentoConyuge;
	}

	public Long getIdC4c() {
		return idC4c;
	}

	public void setIdC4c(Long idC4c) {
		this.idC4c = idC4c;
	}

	public InfoAdicionalPersona getInfoAdicionalPersona() {
		return infoAdicionalPersona;
	}

	public void setInfoAdicionalPersona(InfoAdicionalPersona infoAdicionalPersona) {
		this.infoAdicionalPersona = infoAdicionalPersona;
	}

}
