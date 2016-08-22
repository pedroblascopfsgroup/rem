package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * Modelo que gestiona la informacion de las infraestructuras de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_INF_INFRAESTRUCTURA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoInfraestructura implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "INF_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInfraestructuraGenerator")
    @SequenceGenerator(name = "ActivoInfraestructuraGenerator", sequenceName = "S_ACT_INF_INFRAESTRUCTURA")
    private Long id;

	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@Column(name = "INF_OCIO")
    private Integer ocio;   
	
	@Column(name = "INF_HOTELES")
	private Integer hoteles;
	 
	@Column(name = "INF_HOTELES_DESC")
	private String hotelesDesc;
	
	@Column(name = "INF_TEATROS")
	private Integer teatros;
	
	@Column(name = "INF_TEATROS_DESC")
	private String teatrosDesc;
	
	@Column(name = "INF_SALAS_CINE")
	private Integer salasCine;
	
	@Column(name = "INF_SALAS_CINE_DESC")
	private String salasCineDesc;
	
	@Column(name = "INF_INST_DEPORT")
	private Integer instDeportivas;

	@Column(name = "INF_INST_DEPORT_DESC")
	private String instDeportivasDesc;
	
	@Column(name = "INF_CENTROS_COMERC")
	private Integer centrosComerciales;
	
	@Column(name = "INF_CENTROS_COMERC_DESC")
	private String centrosComercialesDesc;
	
	@Column(name = "INF_OCIO_OTROS")
	private String ocioOtros;
	
	@Column(name = "INF_CENTROS_EDU")
	private Integer centrosEducativos;
	
	@Column(name = "INF_ESCUELAS_INF")
	private Integer escuelasInfantiles;
	
	@Column(name = "INF_ESCUELAS_INF_DESC")
	private String escuelasInfantilesDesc;
	
	@Column(name = "INF_COLEGIOS")
	private Integer colegios;
	
	@Column(name = "INF_COLEGIOS_DESC")
	private String colegiosDesc;
	
	@Column(name = "INF_INSTITUTOS")
	private Integer institutos;
	
	@Column(name = "INF_INSTITUTOS_DESC")
	private String institutosDesc;
	
	@Column(name = "INF_UNIVERSIDADES")
	private Integer universidades;
	
	@Column(name = "INF_UNIVERSIDADES_DESC")
	private String universidadesDesc;

	@Column(name = "INF_CENTROS_EDU_OTROS")
	private String centrosEducativosOtros;
	
	@Column(name = "INF_CENTROS_SANIT")
	private Integer centrosSanitarios;

	@Column(name = "INF_CENTROS_SALUD")
	private Integer centrosSalud;
	
	@Column(name = "INF_CENTROS_SALUD_DESC")
	private String centrosSaludDesc;

	@Column(name = "INF_CLINICAS")
	private Integer clinicas;
	
	@Column(name = "INF_CLINICAS_DESC")
	private String clinicasDesc;
	
	@Column(name = "INF_HOSPITALES")
	private Integer hospitales;
	
	@Column(name = "INF_HOSPITALES_DESC")
	private String hospitalesDesc;
	
	@Column(name = "INF_CENTROS_SANIT_OTROS")
	private String centrosSanitariosOtros;

	@Column(name = "INF_PARKING_SUP_SUF")
	private Integer parkingSuperSufi;

	@Column(name = "INF_COMUNICACIONES")
	private Integer comunicaciones;
	
	@Column(name = "INF_FACIL_ACCESO")
	private Integer facilAcceso;

	@Column(name = "INF_FACIL_ACCESO_DESC")
	private String facilAccesoDesc;
	
	@Column(name = "INF_LINEAS_BUS")
	private Integer lineasBus;

	@Column(name = "INF_LINEAS_BUS_DESC")
	private String lineasBusDesc;
	
	@Column(name = "INF_METRO")
	private Integer metro;

	@Column(name = "INF_METRO_DESC")
	private String metroDesc;
	
	@Column(name = "INF_EST_TREN")
	private Integer estacionTren;

	@Column(name = "INF_EST_TREN_DESC")
	private String estacionTrenDesc;

	@Column(name = "INF_COMUNICACIONES_OTRO")
	private String comunicacionesOtro;


	
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

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public Integer getOcio() {
		return ocio;
	}

	public void setOcio(Integer ocio) {
		this.ocio = ocio;
	}

	public Integer getHoteles() {
		return hoteles;
	}

	public void setHoteles(Integer hoteles) {
		this.hoteles = hoteles;
	}

	public String getHotelesDesc() {
		return hotelesDesc;
	}

	public void setHotelesDesc(String hotelesDesc) {
		this.hotelesDesc = hotelesDesc;
	}

	public Integer getTeatros() {
		return teatros;
	}

	public void setTeatros(Integer teatros) {
		this.teatros = teatros;
	}

	public String getTeatrosDesc() {
		return teatrosDesc;
	}

	public void setTeatrosDesc(String teatrosDesc) {
		this.teatrosDesc = teatrosDesc;
	}

	public Integer getSalasCine() {
		return salasCine;
	}

	public void setSalasCine(Integer salasCine) {
		this.salasCine = salasCine;
	}

	public String getSalasCineDesc() {
		return salasCineDesc;
	}

	public void setSalasCineDesc(String salasCineDesc) {
		this.salasCineDesc = salasCineDesc;
	}

	public Integer getInstDeportivas() {
		return instDeportivas;
	}

	public void setInstDeportivas(Integer instDeportivas) {
		this.instDeportivas = instDeportivas;
	}

	public String getInstDeportivasDesc() {
		return instDeportivasDesc;
	}

	public void setInstDeportivasDesc(String instDeportivasDesc) {
		this.instDeportivasDesc = instDeportivasDesc;
	}

	public Integer getCentrosComerciales() {
		return centrosComerciales;
	}

	public void setCentrosComerciales(Integer centrosComerciales) {
		this.centrosComerciales = centrosComerciales;
	}

	public String getCentrosComercialesDesc() {
		return centrosComercialesDesc;
	}

	public void setCentrosComercialesDesc(String centrosComercialesDesc) {
		this.centrosComercialesDesc = centrosComercialesDesc;
	}

	public String getOcioOtros() {
		return ocioOtros;
	}

	public void setOcioOtros(String ocioOtros) {
		this.ocioOtros = ocioOtros;
	}

	public Integer getCentrosEducativos() {
		return centrosEducativos;
	}

	public void setCentrosEducativos(Integer centrosEducativos) {
		this.centrosEducativos = centrosEducativos;
	}

	public Integer getEscuelasInfantiles() {
		return escuelasInfantiles;
	}

	public void setEscuelasInfantiles(Integer escuelasInfantiles) {
		this.escuelasInfantiles = escuelasInfantiles;
	}

	public String getEscuelasInfantilesDesc() {
		return escuelasInfantilesDesc;
	}

	public void setEscuelasInfantilesDesc(String escuelasInfantilesDesc) {
		this.escuelasInfantilesDesc = escuelasInfantilesDesc;
	}

	public Integer getColegios() {
		return colegios;
	}

	public void setColegios(Integer colegios) {
		this.colegios = colegios;
	}

	public String getColegiosDesc() {
		return colegiosDesc;
	}

	public void setColegiosDesc(String colegiosDesc) {
		this.colegiosDesc = colegiosDesc;
	}

	public Integer getInstitutos() {
		return institutos;
	}

	public void setInstitutos(Integer institutos) {
		this.institutos = institutos;
	}

	public String getInstitutosDesc() {
		return institutosDesc;
	}

	public void setInstitutosDesc(String institutosDesc) {
		this.institutosDesc = institutosDesc;
	}

	public Integer getUniversidades() {
		return universidades;
	}

	public void setUniversidades(Integer universidades) {
		this.universidades = universidades;
	}

	public String getUniversidadesDesc() {
		return universidadesDesc;
	}

	public void setUniversidadesDesc(String universidadesDesc) {
		this.universidadesDesc = universidadesDesc;
	}

	public String getCentrosEducativosOtros() {
		return centrosEducativosOtros;
	}

	public void setCentrosEducativosOtros(String centrosEducativosOtros) {
		this.centrosEducativosOtros = centrosEducativosOtros;
	}

	public Integer getCentrosSanitarios() {
		return centrosSanitarios;
	}

	public void setCentrosSanitarios(Integer centrosSanitarios) {
		this.centrosSanitarios = centrosSanitarios;
	}

	public Integer getCentrosSalud() {
		return centrosSalud;
	}

	public void setCentrosSalud(Integer centrosSalud) {
		this.centrosSalud = centrosSalud;
	}

	public String getCentrosSaludDesc() {
		return centrosSaludDesc;
	}

	public void setCentrosSaludDesc(String centrosSaludDesc) {
		this.centrosSaludDesc = centrosSaludDesc;
	}

	public Integer getClinicas() {
		return clinicas;
	}

	public void setClinicas(Integer clinicas) {
		this.clinicas = clinicas;
	}

	public String getClinicasDesc() {
		return clinicasDesc;
	}

	public void setClinicasDesc(String clinicasDesc) {
		this.clinicasDesc = clinicasDesc;
	}

	public Integer getHospitales() {
		return hospitales;
	}

	public void setHospitales(Integer hospitales) {
		this.hospitales = hospitales;
	}

	public String getHospitalesDesc() {
		return hospitalesDesc;
	}

	public void setHospitalesDesc(String hospitalesDesc) {
		this.hospitalesDesc = hospitalesDesc;
	}

	public String getCentrosSanitariosOtros() {
		return centrosSanitariosOtros;
	}

	public void setCentrosSanitariosOtros(String centrosSanitariosOtros) {
		this.centrosSanitariosOtros = centrosSanitariosOtros;
	}

	public Integer getParkingSuperSufi() {
		return parkingSuperSufi;
	}

	public void setParkingSuperSufi(Integer parkingSuperSufi) {
		this.parkingSuperSufi = parkingSuperSufi;
	}

	public Integer getComunicaciones() {
		return comunicaciones;
	}

	public void setComunicaciones(Integer comunicaciones) {
		this.comunicaciones = comunicaciones;
	}

	public Integer getFacilAcceso() {
		return facilAcceso;
	}

	public void setFacilAcceso(Integer facilAcceso) {
		this.facilAcceso = facilAcceso;
	}

	public String getFacilAccesoDesc() {
		return facilAccesoDesc;
	}

	public void setFacilAccesoDesc(String facilAccesoDesc) {
		this.facilAccesoDesc = facilAccesoDesc;
	}

	public Integer getLineasBus() {
		return lineasBus;
	}

	public void setLineasBus(Integer lineasBus) {
		this.lineasBus = lineasBus;
	}

	public String getLineasBusDesc() {
		return lineasBusDesc;
	}

	public void setLineasBusDesc(String lineasBusDesc) {
		this.lineasBusDesc = lineasBusDesc;
	}

	public Integer getMetro() {
		return metro;
	}

	public void setMetro(Integer metro) {
		this.metro = metro;
	}

	public String getMetroDesc() {
		return metroDesc;
	}

	public void setMetroDesc(String metroDesc) {
		this.metroDesc = metroDesc;
	}

	public Integer getEstacionTren() {
		return estacionTren;
	}

	public void setEstacionTren(Integer estacionTren) {
		this.estacionTren = estacionTren;
	}

	public String getEstacionTrenDesc() {
		return estacionTrenDesc;
	}

	public void setEstacionTrenDesc(String estacionTrenDesc) {
		this.estacionTrenDesc = estacionTrenDesc;
	}

	public String getComunicacionesOtro() {
		return comunicacionesOtro;
	}

	public void setComunicacionesOtro(String comunicacionesOtro) {
		this.comunicacionesOtro = comunicacionesOtro;
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
