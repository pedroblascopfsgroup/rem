package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;


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

	
}
