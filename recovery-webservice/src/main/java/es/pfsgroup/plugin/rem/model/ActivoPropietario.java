package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTSPTipoCorreo;

/**
 * Modelo que gestiona los propietarios de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_PRO_PROPIETARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ActivoPropietario implements Serializable, Auditable {

	public static final String CODIGO_GIVP ="73";
	public static final String CODIGO_GIVP_II ="74";
	public static final String CODIGO_FONDOS_TITULIZACION ="5";
	public static final String NIF_PROPIETARIO_LIVINGCENTER ="A58032244";
	public static final String NIF_PROPIETARIO_CAIXABANK ="A08663619";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	 @Id
	 @Column(name = "PRO_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoPropietarioGenerator")
	 @SequenceGenerator(name = "ActivoPropietarioGenerator", sequenceName = "S_ACT_PRO_PROPIETARIO")
	 private Long id;

	 @ManyToOne
	 @JoinColumn(name = "DD_LOC_ID")
	 private Localidad localidad;
	
	 @ManyToOne
     @JoinColumn(name = "DD_PRV_ID")
     private DDProvincia provincia;
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_LOC_ID_CONT")
	 private Localidad localidadContacto;
	
	 @ManyToOne
     @JoinColumn(name = "DD_PRV_ID_CONT")
     private DDProvincia provinciaContacto;
	 
	 @Column(name = "PRO_CODIGO_UVEM")   
	 private String codigo;
	 
	 @ManyToOne
     @JoinColumn(name = "DD_TPE_ID")
     private DDTipoPersona tipoPersona;
	 
	 @Column(name = "PRO_NOMBRE")   
	 private String nombre;
   
	 @Column(name = "PRO_APELLIDO1")   
	 private String apellido1;
	 
	 @Column(name = "PRO_APELLIDO2")   
	 private String apellido2;
	 
	 @ManyToOne
     @JoinColumn(name = "DD_TDI_ID")
     private DDTipoDocumento tipoDocIdentificativo; 
	 
	 @Column(name = "PRO_DOCIDENTIF")   
	 private String docIdentificativo;
	
	 @Column(name = "PRO_DIR")   
	 private String direccion;
	 
	 @Column(name = "PRO_TELF")   
	 private String telefono;
	 
	 @Column(name = "PRO_EMAIL")   
	 private String email;
	 
	 @Column(name = "PRO_CP")   
	 private Integer codigoPostal;
	 
	 @Column(name = "PRO_CONTACTO_NOM")
	 private String nombreContacto;
	 
	 @Column(name = "PRO_CONTACTO_TELF1")
	 private String telefono1Contacto;
	 
	 @Column(name = "PRO_CONTACTO_TELF2")
	 private String telefono2Contacto;
	 
	 @Column(name = "PRO_CONTACTO_EMAIL")
	 private String emailContacto;
	 
	 @Column(name = "PRO_CONTACTO_DIR")
	 private String direccionContacto;
	 
	 @Column(name = "PRO_CONTACTO_CP")
	 private Integer codigoPostalContacto;
	
	 @Column(name = "PRO_PAGA_EJECUTANTE")
	 private Boolean pageEjecutante;
	 
	 @Column(name = "PRO_OBSERVACIONES")
	 private String observaciones;
	 
	 @ManyToOne
     @JoinColumn(name = "DD_CRA_ID")
	 private DDCartera cartera;
	 
	 @ManyToOne
     @JoinColumn(name = "DD_TSP_ID")
	 private DDTSPTipoCorreo dDTSPTipoCorreo ;
	 
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

	public Localidad getLocalidadContacto() {
		return localidadContacto;
	}

	public void setLocalidadContacto(Localidad localidadContacto) {
		this.localidadContacto = localidadContacto;
	}

	public DDProvincia getProvinciaContacto() {
		return provinciaContacto;
	}

	public void setProvinciaContacto(DDProvincia provinciaContacto) {
		this.provinciaContacto = provinciaContacto;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	
	public DDTipoPersona getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(DDTipoPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido1() {
		return apellido1;
	}

	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	public String getApellido2() {
		return apellido2;
	}

	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	public String getFullName() {
		String fullname = "";
		if(getNombre() != null && !getNombre().equalsIgnoreCase("")){
			fullname = getNombre();
		}
		if(getApellido1() != null && !getApellido1().equalsIgnoreCase("")){
			if(fullname.length()>0){
				fullname = fullname.concat(" ").concat(getApellido1());
			}			
		}
		if(getApellido2() != null && !getApellido2().equalsIgnoreCase("")){
			if(fullname.length()>0){
				fullname = fullname.concat(" ").concat(getApellido2());
			}		
		}
		return fullname;
	}



	public DDTipoDocumento getTipoDocIdentificativo() {
		return tipoDocIdentificativo;
	}

	public void setTipoDocIdentificativo(DDTipoDocumento tipoDocIdentificativo) {
		this.tipoDocIdentificativo = tipoDocIdentificativo;
	}

	public String getDocIdentificativo() {
		return docIdentificativo;
	}

	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Integer getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getNombreContacto() {
		return nombreContacto;
	}

	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}

	public String getTelefono1Contacto() {
		return telefono1Contacto;
	}

	public void setTelefono1Contacto(String telefono1Contacto) {
		this.telefono1Contacto = telefono1Contacto;
	}

	public String getTelefono2Contacto() {
		return telefono2Contacto;
	}

	public void setTelefono2Contacto(String telefono2Contacto) {
		this.telefono2Contacto = telefono2Contacto;
	}

	public String getEmailContacto() {
		return emailContacto;
	}

	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}

	public String getDireccionContacto() {
		return direccionContacto;
	}

	public void setDireccionContacto(String direccionContacto) {
		this.direccionContacto = direccionContacto;
	}

	public Integer getCodigoPostalContacto() {
		return codigoPostalContacto;
	}

	public void setCodigoPostalContacto(Integer codigoPostalContacto) {
		this.codigoPostalContacto = codigoPostalContacto;
	}

	public Boolean getPageEjecutante() {
		return pageEjecutante;
	}

	public void setPageEjecutante(Boolean pageEjecutante) {
		this.pageEjecutante = pageEjecutante;
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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDTSPTipoCorreo getdDTSPTipoCorreo() {
		return dDTSPTipoCorreo;
	}

	public void setdDTSPTipoCorreo(DDTSPTipoCorreo dDTSPTipoCorreo) {
		this.dDTSPTipoCorreo = dDTSPTipoCorreo;
	}

	
	
}

