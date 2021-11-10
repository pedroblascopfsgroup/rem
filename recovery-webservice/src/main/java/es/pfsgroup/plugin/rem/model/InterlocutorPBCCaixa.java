package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import org.hibernate.annotations.*;

import javax.persistence.*;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;


/**
 * Modelo que gestiona la informacion de los interlocutores Caixa BC
 *  
 * @author David Gonzalez
 *
 */
@Entity
@Table(name = "IOC_INTERLOCUTOR_PBC_CAIXA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class InterlocutorPBCCaixa implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "IOC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "InterlocutorPBCCaixa")
    @SequenceGenerator(name = "InterlocutorPBCCaixa", sequenceName = "S_IOC_INTERLOCUTOR_PBC_CAIXA")
    private Long id;
    
    @Column(name = "IOC_ID_PERSONA_HAYA_CAIXA")
    private String idPersonaHaya;

	@ManyToOne
	@JoinColumn(name = "IAP_ID")
	@NotFound(action = NotFoundAction.IGNORE)
	private InfoAdicionalPersona infoAdicionalPersona;

	@Column(name = "IOC_DOC_IDENTIFICATIVO")
	private String documento;

	@Column(name = "IOC_NOMBRE")
	private String nombre;

	@Column(name = "IOC_APELLIDOS")
	private String apellidos;

	@Column(name = "IOC_PERSONA_FISICA")
	private Boolean personaFisica;

	@ManyToOne
	@JoinColumn(name = "DD_PAI_ID")
	private DDPaises pais;

	@ManyToOne
	@JoinColumn(name = "DD_ECV_ID")
	private DDEstadosCiviles estadoCivil;

	@Column(name = "IOC_DIRECCION")
	private String direccion;

	@Column(name = "IOC_CODIGO_POSTAL")
	private String codPostal;

	@ManyToOne
	@JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;

	@ManyToOne
	@JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;

	@ManyToOne
	@JoinColumn(name = "DD_PAI_NAC_ID")
	private DDPaises paisNacimiento;

	@ManyToOne
	@JoinColumn(name = "DD_LOC_NAC_ID")
	private Localidad localidadNacimiento;

	@Column(name = "IAP_FECHA_NACIMIENTO")
	private Date fechaNacimiento;

	@Column(name = "IOC_TELEFONO1")
	private String telefono1;

	@Column(name = "IOC_TELEFONO2")
	private String telefono2;

	@Column(name = "IOC_EMAIL")
	private String email;

	@ManyToOne
	@JoinColumn(name = "DD_PRV_NAC_ID")
	private DDProvincia provinciaNacimiento;

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

	public String getDocumento() {
		return documento;
	}

	public void setDocumento(String documento) {
		this.documento = documento;
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

	public Boolean getPersonaFisica() {
		return personaFisica;
	}

	public void setPersonaFisica(Boolean personaFisica) {
		this.personaFisica = personaFisica;
	}

	public DDPaises getPais() {
		return pais;
	}

	public void setPais(DDPaises pais) {
		this.pais = pais;
	}

	public DDEstadosCiviles getEstadoCivil() {
		return estadoCivil;
	}

	public void setEstadoCivil(DDEstadosCiviles estadoCivil) {
		this.estadoCivil = estadoCivil;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
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

	public DDPaises getPaisNacimiento() {
		return paisNacimiento;
	}

	public void setPaisNacimiento(DDPaises paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}

	public Localidad getLocalidadNacimiento() {
		return localidadNacimiento;
	}

	public void setLocalidadNacimiento(Localidad localidadNacimiento) {
		this.localidadNacimiento = localidadNacimiento;
	}

	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
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

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDProvincia getProvinciaNacimiento() {
		return provinciaNacimiento;
	}

	public void setProvinciaNacimiento(DDProvincia provinciaNacimiento) {
		this.provinciaNacimiento = provinciaNacimiento;
	}
}
