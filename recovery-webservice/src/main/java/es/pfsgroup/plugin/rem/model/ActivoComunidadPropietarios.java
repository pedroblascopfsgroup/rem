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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCuota;



/**
 * Modelo que gestiona la informacion de las comunidades de propietarios de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CPR_COM_PROPIETARIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoComunidadPropietarios implements Serializable, Auditable {

	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CPR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoComunidadPropietariosGenerator")
    @SequenceGenerator(name = "ActivoComunidadPropietariosGenerator", sequenceName = "S_ACT_CPR_COM_PROPIETARIOS")
    private Long id;
	
	@Column(name = "CPR_COD_COM_PROP_UVEM")
	private String codigoComPropUvem;
	
	@Column(name = "CPR_CONSTITUIDA")
	private Integer constituida;

	@Column(name = "CPR_NOMBRE")
	private String nombre;
	 
	@Column(name = "CPR_NIF")
	private String nif;
	
	@Column(name = "CPR_DIRECCION")
	private String direccion;
	
	@Column(name = "CPR_NUM_CUENTA")
	private String numCuenta;
	
	@Column(name = "CPR_PRESIDENTE_NOMBRE")
	private String nomPresidente;
	
	@Column(name = "CPR_PRESIDENTE_TELF")
	private String telfPresidente;
	
	@Column(name = "CPR_PRESIDENTE_TELF2")
	private String telfPresidente2;
	
	@Column(name = "CPR_PRESIDENTE_EMAIL")
	private String emailPresidente;

	@Column(name = "CPR_PRESIDENTE_DIR")
	private String dirPresidente;
	
	@Column(name = "CPR_PRESIDENTE_FECHA_INI")
	private Date fechaInicioPresidente;
	
	@Column(name = "CPR_PRESIDENTE_FECHA_FIN")
	private Date fechaFinPresidente;
	
	@Column(name = "CPR_ADMINISTRADOR_NOMBRE")
	private String nomAdministrador;
	
	@Column(name = "CPR_ADMINISTRADOR_TELF")
	private String telfAdministrador;	
	
	@Column(name = "CPR_ADMINISTRADOR_TELF2")
	private String telfAdministrador2;	
	
	@Column(name = "CPR_ADMINISTRADOR_EMAIL")
	private String emailAdministrador;
	
	@Column(name = "CPR_ADMINISTRADOR_DIR")
	private String dirAdministrador;
	
	@Column(name = "CPR_IMPORTEMEDIO")
	private Float importeMedio;
	
	@Column(name = "CPR_ESTATUTOS")
	private boolean estatutos;
	
	@Column(name = "CPR_LIBRO_EDIFICIO")
	private boolean libroEdificio;
	
	@Column(name = "CPR_CERTIFICADO_ITE")
	private boolean certificadoIte;
	
	@Column(name = "CPR_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "CPR_FECHA_COMUNICACION")
	private Date fechaComunicacionComunidad;
	
	@Column(name = "CPR_ENVIO_CARTAS")
	private Integer envioCartas;
	
	@Column(name = "CPR_NUMERO_CARTAS")
	private Integer numCartas;
	
	@Column(name = "CPR_CONTACTO_TELF")
	private Integer contactoTel;
	
	@Column(name = "CPR_VISITA")
	private Integer visita;
	
	@Column(name = "CPR_BUROFAX")
	private Integer burofax;
	
    @OneToMany(mappedBy = "comunidadPropietarios", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "CPR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoCuotasComunidadPropietarios> cuotaComunidadPropietarios;
    
   // @Column(name = "DD_SACT_ID")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SACT_ID")
	private DDSituacionActivo situacion;
    
    @Column(name = "CPR_FECHA_ENVIO_CARTA")
   	private Date fechaEnvioCarta;
		
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

	public String getCodigoComPropUvem() {
		return codigoComPropUvem;
	}

	public void setCodigoComPropUvem(String codigoComPropUvem) {
		this.codigoComPropUvem = codigoComPropUvem;
	}

	public Integer getConstituida() {
		return constituida;
	}

	public void setConstituida(Integer constituida) {
		this.constituida = constituida;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getNumCuenta() {
		return numCuenta;
	}

	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}

	public String getNomPresidente() {
		return nomPresidente;
	}

	public void setNomPresidente(String nomPresidente) {
		this.nomPresidente = nomPresidente;
	}

	public String getTelfPresidente() {
		return telfPresidente;
	}

	public void setTelfPresidente(String telfPresidente) {
		this.telfPresidente = telfPresidente;
	}

	public String getTelfPresidente2() {
		return telfPresidente2;
	}

	public void setTelfPresidente2(String telfPresidente2) {
		this.telfPresidente2 = telfPresidente2;
	}

	public String getEmailPresidente() {
		return emailPresidente;
	}

	public void setEmailPresidente(String emailPresidente) {
		this.emailPresidente = emailPresidente;
	}

	public String getDirPresidente() {
		return dirPresidente;
	}

	public void setDirPresidente(String dirPresidente) {
		this.dirPresidente = dirPresidente;
	}

	public Date getFechaInicioPresidente() {
		return fechaInicioPresidente;
	}

	public void setFechaInicioPresidente(Date fechaInicioPresidente) {
		this.fechaInicioPresidente = fechaInicioPresidente;
	}

	public Date getFechaFinPresidente() {
		return fechaFinPresidente;
	}

	public void setFechaFinPresidente(Date fechaFinPresidente) {
		this.fechaFinPresidente = fechaFinPresidente;
	}

	public String getNomAdministrador() {
		return nomAdministrador;
	}

	public void setNomAdministrador(String nomAdministrador) {
		this.nomAdministrador = nomAdministrador;
	}

	public String getTelfAdministrador() {
		return telfAdministrador;
	}

	public void setTelfAdministrador(String telfAdministrador) {
		this.telfAdministrador = telfAdministrador;
	}

	public String getTelfAdministrador2() {
		return telfAdministrador2;
	}

	public void setTelfAdministrador2(String telfAdministrador2) {
		this.telfAdministrador2 = telfAdministrador2;
	}

	public String getEmailAdministrador() {
		return emailAdministrador;
	}

	public void setEmailAdministrador(String emailAdministrador) {
		this.emailAdministrador = emailAdministrador;
	}

	public String getDirAdministrador() {
		return dirAdministrador;
	}

	public void setDirAdministrador(String dirAdministrador) {
		this.dirAdministrador = dirAdministrador;
	}

	public Float getImporteMedio() {
		return importeMedio;
	}

	public void setImporteMedio(Float importeMedio) {
		this.importeMedio = importeMedio;
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

	public void setEstatutos(boolean estatutos) {
		this.estatutos = estatutos;
	}

	public void setLibroEdificio(boolean libroEdificio) {
		this.libroEdificio = libroEdificio;
	}

	public void setCertificadoIte(boolean certificadoIte) {
		this.certificadoIte = certificadoIte;
	}

	public boolean isEstatutos() {
		return estatutos;
	}

	public boolean isLibroEdificio() {
		return libroEdificio;
	}

	public boolean isCertificadoIte() {
		return certificadoIte;
	}
	
	public boolean getEstatutos() {
		return estatutos;
	}

	public boolean getLibroEdificio() {
		return libroEdificio;
	}

	public boolean getCertificadoIte() {
		return certificadoIte;
	}

	public List<ActivoCuotasComunidadPropietarios> getCuotaComunidadPropietarios() {
		return cuotaComunidadPropietarios;
	}

	public void setCuotaComunidadPropietarios(
			List<ActivoCuotasComunidadPropietarios> cuotaComunidadPropietarios) {
		this.cuotaComunidadPropietarios = cuotaComunidadPropietarios;
	}

	public Date getFechaComunicacionComunidad() {
		return fechaComunicacionComunidad;
	}

	public void setFechaComunicacionComunidad(Date fechaComunicacionComunidad) {
		this.fechaComunicacionComunidad = fechaComunicacionComunidad;
	}

	public Integer getEnvioCartas() {
		return envioCartas;
	}

	public void setEnvioCartas(Integer envioCartas) {
		this.envioCartas = envioCartas;
	}

	public Integer getNumCartas() {
		return numCartas;
	}

	public void setNumCartas(Integer numCartas) {
		this.numCartas = numCartas;
	}

	public Integer getContactoTel() {
		return contactoTel;
	}

	public void setContactoTel(Integer contactoTel) {
		this.contactoTel = contactoTel;
	}

	public Integer getVisita() {
		return visita;
	}

	public void setVisita(Integer visita) {
		this.visita = visita;
	}

	public Integer getBurofax() {
		return burofax;
	}

	public void setBurofax(Integer burofax) {
		this.burofax = burofax;
	}



	public Date getFechaEnvioCarta() {
		return fechaEnvioCarta;
	}

	public void setFechaEnvioCarta(Date fechaEnvioCarta) {
		this.fechaEnvioCarta = fechaEnvioCarta;
	}

	public DDSituacionActivo getSituacion() {
		return situacion;
	}

	public void setSituacion(DDSituacionActivo situacion) {
		this.situacion = situacion;
	}

	

}
