package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;



/**
 * clase modelo de ActivoDatosDq.
 *
 * @author Javier Esbri
 */
@Entity
@Table(name = "ACT_DDQ_DATOS_DQ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoDatosDq implements Serializable, Auditable {
	
    private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "DDQ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoDatosDqGenerator")
    @SequenceGenerator(name = "ActivoDatosDqGenerator", sequenceName = "S_ACT_DDQ_DATOS_DQ")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoActivo tipoActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STA_ID")
    private DDSubtipoTituloActivo subtipoTitulo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TUD_ID")
    private DDTipoUsoDestino tipoUsoDestino;
    
    @Column(name = "DDQ_IDUFIR")
	private String idufirDdq;
    
    @Column(name = "DDQ_NUM_FINCA")
	private String numFincaDdq;
    
    @Column(name = "DDQ_TOMO")
	private String tomoDdq;
    
    @Column(name = "DDQ_LIBRO")
   	private String libroDdq;
    
    @Column(name = "DDQ_FOLIO")
   	private String folioDdq;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID_REG")
    private Localidad localidadReg;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID_REG")
    private DDProvincia provinciaReg;
    
    @Column(name = "DDQ_NUM_REGISTRO")
   	private String numRegistroDdq;
    
    @Column(name = "VPO")
   	private Boolean vpo;
    
    @Column(name = "CARGAS")
   	private Boolean cargas;
    
    @Column(name = "DESCRIPCION_CARGAS")
   	private String descripcionCargas;
    
    @Column(name = "INSCRIPCION")
   	private Boolean inscripcion;
    
    @Column(name = "ANYO_CONSTRUCCION")
   	private Long anyoConstruccion;
    
    @Column(name = "DDQ_REFERENCIA_CATASTRAL")
   	private String referenciaCatastralDdq;
    
    @Column(name = "DDQ_PORC_PROPIEDAD")
   	private Float propiedadDdq;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TVI_ID")
    private DDTipoVia tipoVia;
    
    @Column(name = "DDQ_NOMBRE_VIA")
   	private String nombreViaDdq;
    
    @Column(name = "PROB_CALLE_CORRECTA")
   	private Long calleCorrectaProb;
    
    @Column(name = "DDQ_COD_POST")
   	private String codigoPostalDdq;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @Column(name = "DDQ_LATITUD")
   	private Long latitudDdq;
    
    @Column(name = "DDQ_LONGITUD")
   	private Long longitudDdq;
    
    @Column(name = "GEODISTANCIA")
   	private Long geodistancia;
    
    @Column(name = "DDQ_SUPERFICIE_CONSTRUIDA")
   	private Long superficieConstruidaDdq;
    
    @Column(name = "DDQ_SUPERFICIE_UTIL")
   	private Long superficieUtilDdq;
    
    @Column(name = "NUM_IMAGENES")
   	private Long numImagenes;
    
    @Column(name = "NUM_IMAGENES_EXT")
   	private Long numImagenesExt;
    
    @Column(name = "NUM_IMAGENES_INT")
   	private Long numImagenesInt;
    
    @Column(name = "NUM_IMAGENES_OBRA")
   	private Long numImagenesObra;
    
    @Column(name = "NUM_IMAGENES_MIN_RES")
   	private Long numImagenesMinRes;
    
    @Column(name = "NUM_IMAGENES_MIN_RES_X")
   	private Long numImagenesMinResX;
    
    @Column(name = "NUM_IMAGENES_MIN_RES_Y")
   	private Long numImagenesMinResY;
    
    @Column(name = "EST_IMAGENES")
   	private String imagenesEst;
    
    @Column(name = "MENSAJE_IMAGENES")
   	private String imagenesMensaje;
    
    @Column(name = "DESCRIPCION")
   	private String descripcion;
    
    @Column(name = "ETI_CEE_A")
   	private String etiCeeA;
    
    @Column(name = "ETI_CEE_B")
   	private String etiCeeB;
    
    @Column(name = "ETI_CEE_C")
   	private String etiCeeC;
    
    @Column(name = "ETI_CEE_D")
   	private String etiCeeD;
    
    @Column(name = "ETI_CEE_E")
   	private String etiCeeE;
    
    @Column(name = "ETI_CEE_F")
   	private String etiCeeF;
    
    @Column(name = "ETI_CEE_G")
   	private String etiCeeG;
    
    @Column(name = "EST_CEE")
   	private String estCee;
    
    @Column(name = "MENSAJE_CEE")
   	private String mensajeCee;
	
	@Version
    private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoTituloActivo getSubtipoTitulo() {
		return subtipoTitulo;
	}

	public void setSubtipoTitulo(DDSubtipoTituloActivo subtipoTitulo) {
		this.subtipoTitulo = subtipoTitulo;
	}

	public DDTipoUsoDestino getTipoUsoDestino() {
		return tipoUsoDestino;
	}

	public void setTipoUsoDestino(DDTipoUsoDestino tipoUsoDestino) {
		this.tipoUsoDestino = tipoUsoDestino;
	}

	public String getIdufirDdq() {
		return idufirDdq;
	}

	public void setIdufirDdq(String idufirDdq) {
		this.idufirDdq = idufirDdq;
	}

	public String getNumFincaDdq() {
		return numFincaDdq;
	}

	public void setNumFincaDdq(String numFincaDdq) {
		this.numFincaDdq = numFincaDdq;
	}

	public String getTomoDdq() {
		return tomoDdq;
	}

	public void setTomoDdq(String tomoDdq) {
		this.tomoDdq = tomoDdq;
	}

	public String getLibroDdq() {
		return libroDdq;
	}

	public void setLibroDdq(String libroDdq) {
		this.libroDdq = libroDdq;
	}

	public String getFolioDdq() {
		return folioDdq;
	}

	public void setFolioDdq(String folioDdq) {
		this.folioDdq = folioDdq;
	}

	public Localidad getLocalidadReg() {
		return localidadReg;
	}

	public void setLocalidadReg(Localidad localidadReg) {
		this.localidadReg = localidadReg;
	}

	public DDProvincia getProvinciaReg() {
		return provinciaReg;
	}

	public void setProvinciaReg(DDProvincia provinciaReg) {
		this.provinciaReg = provinciaReg;
	}

	public String getNumRegistroDdq() {
		return numRegistroDdq;
	}

	public void setNumRegistroDdq(String numRegistroDdq) {
		this.numRegistroDdq = numRegistroDdq;
	}

	public Boolean getVpo() {
		return vpo;
	}

	public void setVpo(Boolean vpo) {
		this.vpo = vpo;
	}

	public Boolean getCargas() {
		return cargas;
	}

	public void setCargas(Boolean cargas) {
		this.cargas = cargas;
	}

	public String getDescripcionCargas() {
		return descripcionCargas;
	}

	public void setDescripcionCargas(String descripcionCargas) {
		this.descripcionCargas = descripcionCargas;
	}

	public Boolean getInscripcion() {
		return inscripcion;
	}

	public void setInscripcion(Boolean inscripcion) {
		this.inscripcion = inscripcion;
	}

	public Long getAnyoConstruccion() {
		return anyoConstruccion;
	}

	public void setAnyoConstruccion(Long anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}

	public String getReferenciaCatastralDdq() {
		return referenciaCatastralDdq;
	}

	public void setReferenciaCatastralDdq(String referenciaCatastralDdq) {
		this.referenciaCatastralDdq = referenciaCatastralDdq;
	}

	public Float getPropiedadDdq() {
		return propiedadDdq;
	}

	public void setPropiedadDdq(Float propiedadDdq) {
		this.propiedadDdq = propiedadDdq;
	}

	public DDTipoVia getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(DDTipoVia tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getNombreViaDdq() {
		return nombreViaDdq;
	}

	public void setNombreViaDdq(String nombreViaDdq) {
		this.nombreViaDdq = nombreViaDdq;
	}

	public Long getCalleCorrectaProb() {
		return calleCorrectaProb;
	}

	public void setCalleCorrectaProb(Long calleCorrectaProb) {
		this.calleCorrectaProb = calleCorrectaProb;
	}

	public String getCodigoPostalDdq() {
		return codigoPostalDdq;
	}

	public void setCodigoPostalDdq(String codigoPostalDdq) {
		this.codigoPostalDdq = codigoPostalDdq;
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

	public Long getLatitudDdq() {
		return latitudDdq;
	}

	public void setLatitudDdq(Long latitudDdq) {
		this.latitudDdq = latitudDdq;
	}

	public Long getLongitudDdq() {
		return longitudDdq;
	}

	public void setLongitudDdq(Long longitudDdq) {
		this.longitudDdq = longitudDdq;
	}

	public Long getGeodistancia() {
		return geodistancia;
	}

	public void setGeodistancia(Long geodistancia) {
		this.geodistancia = geodistancia;
	}

	public Long getSuperficieConstruidaDdq() {
		return superficieConstruidaDdq;
	}

	public void setSuperficieConstruidaDdq(Long superficieConstruidaDdq) {
		this.superficieConstruidaDdq = superficieConstruidaDdq;
	}

	public Long getSuperficieUtilDdq() {
		return superficieUtilDdq;
	}

	public void setSuperficieUtilDdq(Long superficieUtilDdq) {
		this.superficieUtilDdq = superficieUtilDdq;
	}

	public Long getNumImagenes() {
		return numImagenes;
	}

	public void setNumImagenes(Long numImagenes) {
		this.numImagenes = numImagenes;
	}

	public Long getNumImagenesExt() {
		return numImagenesExt;
	}

	public void setNumImagenesExt(Long numImagenesExt) {
		this.numImagenesExt = numImagenesExt;
	}

	public Long getNumImagenesInt() {
		return numImagenesInt;
	}

	public void setNumImagenesInt(Long numImagenesInt) {
		this.numImagenesInt = numImagenesInt;
	}

	public Long getNumImagenesObra() {
		return numImagenesObra;
	}

	public void setNumImagenesObra(Long numImagenesObra) {
		this.numImagenesObra = numImagenesObra;
	}

	public Long getNumImagenesMinRes() {
		return numImagenesMinRes;
	}

	public void setNumImagenesMinRes(Long numImagenesMinRes) {
		this.numImagenesMinRes = numImagenesMinRes;
	}

	public Long getNumImagenesMinResX() {
		return numImagenesMinResX;
	}

	public void setNumImagenesMinResX(Long numImagenesMinResX) {
		this.numImagenesMinResX = numImagenesMinResX;
	}

	public Long getNumImagenesMinResY() {
		return numImagenesMinResY;
	}

	public void setNumImagenesMinResY(Long numImagenesMinResY) {
		this.numImagenesMinResY = numImagenesMinResY;
	}

	public String getImagenesEst() {
		return imagenesEst;
	}

	public void setImagenesEst(String imagenesEst) {
		this.imagenesEst = imagenesEst;
	}

	public String getImagenesMensaje() {
		return imagenesMensaje;
	}

	public void setImagenesMensaje(String imagenesMensaje) {
		this.imagenesMensaje = imagenesMensaje;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getEtiCeeA() {
		return etiCeeA;
	}

	public void setEtiCeeA(String etiCeeA) {
		this.etiCeeA = etiCeeA;
	}

	public String getEtiCeeB() {
		return etiCeeB;
	}

	public void setEtiCeeB(String etiCeeB) {
		this.etiCeeB = etiCeeB;
	}

	public String getEtiCeeC() {
		return etiCeeC;
	}

	public void setEtiCeeC(String etiCeeC) {
		this.etiCeeC = etiCeeC;
	}

	public String getEtiCeeD() {
		return etiCeeD;
	}

	public void setEtiCeeD(String etiCeeD) {
		this.etiCeeD = etiCeeD;
	}

	public String getEtiCeeE() {
		return etiCeeE;
	}

	public void setEtiCeeE(String etiCeeE) {
		this.etiCeeE = etiCeeE;
	}

	public String getEtiCeeF() {
		return etiCeeF;
	}

	public void setEtiCeeF(String etiCeeF) {
		this.etiCeeF = etiCeeF;
	}

	public String getEtiCeeG() {
		return etiCeeG;
	}

	public void setEtiCeeG(String etiCeeG) {
		this.etiCeeG = etiCeeG;
	}

	public String getEstCee() {
		return estCee;
	}

	public void setEstCee(String estCee) {
		this.estCee = estCee;
	}

	public String getMensajeCee() {
		return mensajeCee;
	}

	public void setMensajeCee(String mensajeCee) {
		this.mensajeCee = mensajeCee;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
