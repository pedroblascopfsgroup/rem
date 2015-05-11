package es.pfsgroup.recovery.recobroCommon.esquema.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que mapea la entidad esquema de recobro
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_ESQ_ESQUEMA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroEsquema implements Auditable, Serializable  {
	
	private static final long serialVersionUID = -4807464097772185758L;

	@Id
    @Column(name = "RCF_ESQ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EsquemaGenerator")
	@SequenceGenerator(name = "EsquemaGenerator", sequenceName = "S_RCF_ESQ_ESQUEMA")
    private Long id;

    @Column(name = "RCF_ESQ_NOMBRE")
    private String nombre;

    @Column(name = "RCF_ESQ_DESCRIPCION")
    private String descripcion;
   
	@ManyToOne
	@JoinColumn(name = "RCF_DD_EES_ID", nullable = true)	    
    private RecobroDDEstadoEsquema estadoEsquema;

    @Column(name = "RCF_ESQ_FECHA_ALTA")
    private Date fechaAlta;

    @Column(name = "RCF_ESQ_FECHA_LIB")
    private Date fechaLiberacion;
    
    @Column(name = "RCF_ESQ_FECHA_FIN_TRANSICION")
    private Date fechaFinTransicion;

    @Column(name = "RCF_FECHA_DESACT")
    private Date fechaDesactivacion;
    
    @ManyToOne
	@JoinColumn(name = "RCF_ESQ_ID_ANTERIOR", nullable = true)
    private RecobroEsquema esquemaAnterior;
    
    @ManyToOne
	@JoinColumn(name = "RCF_ESQ_ID_SIGUIENTE", nullable = true)
    private RecobroEsquema esquemaSiguiente;
    
    
    @Column(name = "RCF_ESQ_PLAZO")
    private Integer plazo;
 
	@ManyToOne
	@JoinColumn(name = "RCF_DD_MTR_ID", nullable = true)    
    private RecobroDDModeloTransicion modeloTransicion;
    
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_ESQ_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	@OrderBy("prioridad ASC")
	private List<RecobroCarteraEsquema> carterasEsquema;

	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario propietario;

    @Column(name = "RCF_ID_GRUPO_VERSION")
    private Long idGrupoVersion;
    
    @Column(name = "RCF_VERSION")
    private Integer versionrelease;
    
    @Column(name = "RCF_MAJOR_RELEASE")
    private Integer majorRelease;
    
    @Column(name = "RCF_MINOR_RELEASE")
    private Integer minorRelease;
    
    @Embedded
    private Auditoria auditoria;

	@Version
	private Integer version;
	 
	public RecobroDDEstadoEsquema getEstadoEsquema() {
		return estadoEsquema;
	}

	public void setEstadoEsquema(RecobroDDEstadoEsquema estadoEsquema) {
		this.estadoEsquema = estadoEsquema;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaLiberacion() {
		return fechaLiberacion;
	}

	public void setFechaLiberacion(Date fechaLiberacion) {
		this.fechaLiberacion = fechaLiberacion;
	}

	public Date getFechaFinTransicion() {
		return fechaFinTransicion;
	}

	public void setFechaFinTransicion(Date fechaFinTransicion) {
		this.fechaFinTransicion = fechaFinTransicion;
	}

	public Date getFechaDesactivacion() {
		return fechaDesactivacion;
	}

	public void setFechaDesactivacion(Date fechaDesactivacion) {
		this.fechaDesactivacion = fechaDesactivacion;
	}

	public RecobroEsquema getEsquemaAnterior() {
		return esquemaAnterior;
	}

	public void setEsquemaAnterior(RecobroEsquema esquemaAnterior) {
		this.esquemaAnterior = esquemaAnterior;
	}

	public RecobroEsquema getEsquemaSiguiente() {
		return esquemaSiguiente;
	}

	public void setEsquemaSiguiente(RecobroEsquema esquemaSiguiente) {
		this.esquemaSiguiente = esquemaSiguiente;
	}

	public RecobroDDModeloTransicion getModeloTransicion() {
		return modeloTransicion;
	}

	public void setModeloTransicion(RecobroDDModeloTransicion modeloTransicion) {
		this.modeloTransicion = modeloTransicion;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public List<RecobroCarteraEsquema> getCarterasEsquema() {
		return carterasEsquema;
	}

	public void setCarterasEsquema(List<RecobroCarteraEsquema> carterasEsquema) {
		this.carterasEsquema = carterasEsquema;
	}

	public Integer getPlazo() {
		return plazo;
	}

	public void setPlazo(Integer plazo) {
		this.plazo = plazo;
	}

	public Usuario getPropietario() {
		return propietario;
	}

	public void setPropietario(Usuario propietario) {
		this.propietario = propietario;
	}

	public Integer getVersionrelease() {
		return versionrelease;
	}

	public void setVersionrelease(Integer versionrelease) {
		this.versionrelease = versionrelease;
	}

	public Integer getMajorRelease() {
		return majorRelease;
	}

	public void setMajorRelease(Integer majorRelease) {
		this.majorRelease = majorRelease;
	}

	public Integer getMinorRelease() {
		return minorRelease;
	}

	public void setMinorRelease(Integer minorRelease) {
		this.minorRelease = minorRelease;
	}

	public Long getIdGrupoVersion() {
		return idGrupoVersion;
	}

	public void setIdGrupoVersion(Long idGrupoVersion) {
		this.idGrupoVersion = idGrupoVersion;
	}
	
	public String getNombreVersion(){
		return  nombre+"-"+versionrelease+"-"+majorRelease+"-"+minorRelease ;
	}
}
