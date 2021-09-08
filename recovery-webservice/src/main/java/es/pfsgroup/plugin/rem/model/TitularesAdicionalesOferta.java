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
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;


/**
 * Modelo que gestiona la información de los titulares adicionales de una oferta
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "OFR_TIA_TITULARES_ADICIONALES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)	
public class TitularesAdicionalesOferta  implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "TIA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TitularesAdicionalesOfertaGenerator")
    @SequenceGenerator(name = "TitularesAdicionalesOfertaGenerator", sequenceName = "S_OFR_TIA_TIT_ADICIONALES")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;
	
	@Column(name="TIA_NOMBRE")
    private String nombre;
	
	@Column(name="TIA_APELLIDOS")
	private String apellidos;
	
	@Column(name="TIA_DIRECCION")
	private String direccion;
	
	@Column(name="TIA_RECHAZAR_PUBLI")
	private Boolean rechazarCesionDatosPublicidad;
	 
	@Column(name="TIA_RECHAZAR_PROPI")
	private Boolean rechazarCesionDatosPropietario;
	
	@Column(name="TIA_RECHAZAR_PROVE")
	private Boolean rechazarCesionDatosProveedores;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;
	
	@Column(name="TIA_CODPOSTAL")
	private String codPostal;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ECV_ID")
	private DDEstadosCiviles estadoCivil;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_REM_ID")
	private DDRegimenesMatrimoniales regimenMatrimonial;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
    
    @Column(name = "TIA_DOCUMENTO")
    private String documento;
    
    //REMVIP-3846
    @Column(name = "TIA_RAZON_SOCIAL")
    private String razonSocial;
    
    @Column(name = "TIA_TELEFONO1")
    private String telefono1;
    
    @Column(name = "TIA_TELEFONO2")
    private String telefono2;
    
    @Column(name = "TIA_EMAIL")
    private String email;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVI_ID")
	private DDTipoVia tipoVia;
    
    @Column(name = "TIA_OBSERVACIONES")
    private String observaciones;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_CONYUGE")
	private DDTipoDocumento tipoDocumentoConyuge;
    
    @Column(name="TIA_DOCUMENTO_CONYUGE")
    private String documentoConyuge;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPE_ID")
	private DDTiposPersona tipoPersona;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_ID")
    private DDPaises pais;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDI_ID_RTE")
	private DDTipoDocumento tipoDocumentoRepresentante;
    
    @Column(name = "TIA_DOCUMENTO_RTE")
    private String documentoRepresentante;
    
    @Column(name="TIA_DIRECCION_RTE")
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
    
    @Column(name = "TIA_CODPOSTAL_RTE")
    private String codPostalRepresentante;

	@Column(name = "TIA_C4C_ID")
	private Long idC4c;

	@Column(name = "TIA_ID_PERSONA_HAYA")
	private String idPersonaHaya;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IAP_ID")
	private InfoAdicionalPersona infoAdicionalPersona;
    
    @Column(name = "TIA_FECHA_NACIMIENTO")
    private Date fechaNacimiento;
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_NAC_ID")
	private Localidad localidadNacimiento;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_NAC_ID")
    private DDPaises paisNacimiento;
    
    @Column(name = "TIA_FECHA_NACIMIENTO_REP")
    private Date fechaNacimientoRep;
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_NAC_ID_REP")
	private Localidad localidadNacimientoRep;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PAI_NAC_ID_REP")
    private DDPaises paisNacimientoRep;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "IAP_ID_REP")
	private InfoAdicionalPersona infoAdicionalPersonaRep;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_NAC_ID")
	private DDProvincia provinciaNacimiento;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_NAC_ID_REP")
	private DDProvincia provinciaNacimientoRep;
    
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
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
	
	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
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

	public Boolean getRechazarCesionDatosPublicidad() {
		return rechazarCesionDatosPublicidad;
	}

	public void setRechazarCesionDatosPublicidad(Boolean rechazarCesionDatosPublicidad) {
		this.rechazarCesionDatosPublicidad = rechazarCesionDatosPublicidad;
	}

	public Boolean getRechazarCesionDatosPropietario() {
		return rechazarCesionDatosPropietario;
	}

	public void setRechazarCesionDatosPropietario(Boolean rechazarCesionDatosPropietario) {
		this.rechazarCesionDatosPropietario = rechazarCesionDatosPropietario;
	}

	public Boolean getRechazarCesionDatosProveedores() {
		return rechazarCesionDatosProveedores;
	}

	public void setRechazarCesionDatosProveedores(Boolean rechazarCesionDatosProveedores) {
		this.rechazarCesionDatosProveedores = rechazarCesionDatosProveedores;
	}

	public String getRazonSocial() {
		return razonSocial;
	}

	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
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

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public DDTiposPersona getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(DDTiposPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public DDPaises getPais() {
		return pais;
	}

	public void setPais(DDPaises pais) {
		this.pais = pais;
	}

	public DDTipoDocumento getTipoDocumentoRepresentante() {
		return tipoDocumentoRepresentante;
	}

	public void setTipoDocumentoRepresentante(DDTipoDocumento tipoDocumentoRepresentante) {
		this.tipoDocumentoRepresentante = tipoDocumentoRepresentante;
	}

	public String getDocumentoRepresentante() {
		return documentoRepresentante;
	}

	public void setDocumentoRepresentante(String documentoRepresentante) {
		this.documentoRepresentante = documentoRepresentante;
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

	public String getCodPostalRepresentante() {
		return codPostalRepresentante;
	}

	public void setCodPostalRepresentante(String codPostalRepresentante) {
		this.codPostalRepresentante = codPostalRepresentante;
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

	public Long getVersion() {
		return version;
	}

	public Long getIdC4c() {
		return idC4c;
	}

	public void setIdC4c(Long idC4c) {
		this.idC4c = idC4c;
	}

	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}

	public InfoAdicionalPersona getInfoAdicionalPersona() {
		return infoAdicionalPersona;
	}

	public void setInfoAdicionalPersona(InfoAdicionalPersona infoAdicionalPersona) {
		this.infoAdicionalPersona = infoAdicionalPersona;
	}

	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public Localidad getLocalidadNacimiento() {
		return localidadNacimiento;
	}

	public void setLocalidadNacimiento(Localidad localidadNacimiento) {
		this.localidadNacimiento = localidadNacimiento;
	}

	public DDPaises getPaisNacimiento() {
		return paisNacimiento;
	}

	public void setPaisNacimiento(DDPaises paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}

	public Date getFechaNacimientoRep() {
		return fechaNacimientoRep;
	}

	public void setFechaNacimientoRep(Date fechaNacimientoRep) {
		this.fechaNacimientoRep = fechaNacimientoRep;
	}

	public Localidad getLocalidadNacimientoRep() {
		return localidadNacimientoRep;
	}

	public void setLocalidadNacimientoRep(Localidad localidadNacimientoRep) {
		this.localidadNacimientoRep = localidadNacimientoRep;
	}

	public DDPaises getPaisNacimientoRep() {
		return paisNacimientoRep;
	}

	public void setPaisNacimientoRep(DDPaises paisNacimientoRep) {
		this.paisNacimientoRep = paisNacimientoRep;
	}

	public InfoAdicionalPersona getInfoAdicionalPersonaRep() {
		return infoAdicionalPersonaRep;
	}

	public void setInfoAdicionalPersonaRep(InfoAdicionalPersona infoAdicionalPersonaRep) {
		this.infoAdicionalPersonaRep = infoAdicionalPersonaRep;
	}

	public DDProvincia getProvinciaNacimiento() {
		return provinciaNacimiento;
	}

	public void setProvinciaNacimiento(DDProvincia provinciaNacimiento) {
		this.provinciaNacimiento = provinciaNacimiento;
	}

	public DDProvincia getProvinciaNacimientoRep() {
		return provinciaNacimientoRep;
	}

	public void setProvinciaNacimientoRep(DDProvincia provinciaNacimientoRep) {
		this.provinciaNacimientoRep = provinciaNacimientoRep;
	}


	
}
