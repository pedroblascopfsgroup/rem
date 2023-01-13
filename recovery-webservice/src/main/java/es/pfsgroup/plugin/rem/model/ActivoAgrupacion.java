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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;


/**
 * Modelo que gestiona las agrupaciones de los activos
 *  
 * @author Benjamín Guerrero
 *
 */
@Entity
//@org.hibernate.annotations.Entity(dynamicInsert=true, dynamicUpdate=true)
@Table(name = "ACT_AGR_AGRUPACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
//@NamedNativeQuery(name = "SECUENCIA_NUM_AGRUPACION", query = "SELECT S_H_RSD_RANKING_SUBCAR_DETALLE.NEXTVAL FROM DUAL")
public class ActivoAgrupacion implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AGR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgrupacionGenerator")
    @SequenceGenerator(name = "ActivoAgrupacionGenerator", sequenceName = "S_ACT_AGR_AGRUPACION")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAG_ID")
    private DDTipoAgrupacion tipoAgrupacion;
        
    @Column(name = "AGR_NUM_AGRUP_REM")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgrupacionNumRemGenerator")
    @SequenceGenerator(name = "ActivoAgrupacionNumRemGenerator", sequenceName = "S_AGR_NUM_AGRUP_REM")
	private Long numAgrupRem;
    
    @Column(name = "AGR_NUM_AGRUP_UVEM")
	private Long numAgrupUvem;
    
    @Column(name = "AGR_NOMBRE")
	private String nombre;
    
	@Column(name = "AGR_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "AGR_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "AGR_ELIMINADO")
	//@Column(name = "AGR_ELIMINADO", columnDefinition = "Number(1,0) default '0'")
	private Integer eliminado = 0;
	 
	@Column(name = "AGR_FECHA_BAJA")
	private Date fechaBaja;
	
	@Column(name = "AGR_URL")
	private String url;
	
	@Column(name = "AGR_PUBLICADO")
	private Integer publicado = 0;
	
	@Column(name = "AGR_SEG_VISITAS")
	private Integer seguimientoVisitas = 0;
	
	@Column(name = "AGR_TEXTO_WEB")
	private String textoWeb;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ACT_PRINCIPAL")
    private Activo activoPrincipal;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_GESTOR_ID")
    private GestorActivo gestorAgrupacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_MEDIADOR_ID")
    private GestorActivo mediadorAgrupacion;
	
    @OneToMany(mappedBy = "agrupacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoAgrupacionObservacion> agrupacionObservacion;
    
    @OneToMany(mappedBy = "agrupacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoAgrupacionActivo> activos;
    
    @OneToMany(mappedBy = "agrupacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoFoto> fotos;
    
    @OneToMany(mappedBy = "agrupacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private List<Oferta> ofertas;
    
	@Column(name = "AGR_INI_VIGENCIA")
	private Date fechaInicioVigencia;
	
	@Column(name = "AGR_FIN_VIGENCIA")
	private Date fechaFinVigencia;
	
	@Column(name = "AGR_IS_FORMALIZACION")
	private Integer isFormalizacion;
	
	@Column(name = "AGR_UVEM_COAGIW")
	private Integer uvemCodigoAgrupacionInmueble;
	
	@Column(name = "AGR_NUM_AGRUP_PRINEX_HPM")
	private String numAgrupPrinexHPM;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAL_ID")
    private DDTipoAlquiler tipoAlquiler;
	
	@Column(name = "AGR_COMERCIALIZABLE_CONS_PLANO")
	private Boolean comercializableConsPlano;
	
	@Column(name = "AGR_EXISTE_PISO_PILOTO")
	private Boolean existePiloto;
	
	@Column(name = "AGR_VISITABLE")
	private Boolean esVisitable;
	
	@Column(name = "AGR_EMPRESA_PROMOTORA")
	private String empresaPromotora;
	
	@Column(name = "AGR_EMPRESA_COMERCIALIZADORA")
	private String empresaComercializadora;

	@OneToOne(mappedBy = "activoAgrupacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoAutorizacionTramitacionOfertas activoAutorizacionTramitacionOfertas;
	
	@Column(name = "AGR_COD_ON_SAREB")
	private String codigoOnSareb;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_DND_ID")
    private ActivoAgrupacion agrupacionONDnd;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_VENTA_PLANO")
	private DDSinSiNo ventaPlano;
    
    @Column(name = "AGR_FECHA_PREV_FINALIZACION")
	private Date fechaPrevFinalizacion;
    
    @Column(name = "AGR_FECHA_ESCRITURA_DESDE")
	private Date fechaEscrituraDesde;
    
    @Column(name = "AGR_FECHA_ESCRITURA_HASTA")
	private Date fechaEscrituraHasta;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoAgrupacion getTipoAgrupacion() {
		return tipoAgrupacion;
	}

	public void setTipoAgrupacion(DDTipoAgrupacion tipoAgrupacion) {
		this.tipoAgrupacion = tipoAgrupacion;
	}

	public Long getNumAgrupRem() {
		return numAgrupRem;
	}

	public void setNumAgrupRem(Long numAgrupRem) {
		this.numAgrupRem = numAgrupRem;
	}

	public Long getNumAgrupUvem() {
		return numAgrupUvem;
	}

	public void setNumAgrupUvem(Long numAgrupUvem) {
		this.numAgrupUvem = numAgrupUvem;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Integer getEliminado() {
		return eliminado;
	}

	public void setEliminado(Integer eliminado) {
		this.eliminado = eliminado;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getPublicado() {
		return publicado;
	}

	public void setPublicado(Integer publicado) {
		this.publicado = publicado;
	}

	public Integer getSeguimientoVisitas() {
		return seguimientoVisitas;
	}

	public void setSeguimientoVisitas(Integer seguimientoVisitas) {
		this.seguimientoVisitas = seguimientoVisitas;
	}

	public String getTextoWeb() {
		return textoWeb;
	}

	public void setTextoWeb(String textoWeb) {
		this.textoWeb = textoWeb;
	}

	public Activo getActivoPrincipal() {
		return activoPrincipal;
	}

	public void setActivoPrincipal(Activo activoPrincipal) {
		this.activoPrincipal = activoPrincipal;
	}

	public GestorActivo getGestorAgrupacion() {
		return gestorAgrupacion;
	}

	public void setGestorAgrupacion(GestorActivo gestorAgrupacion) {
		this.gestorAgrupacion = gestorAgrupacion;
	}

	public GestorActivo getMediadorAgrupacion() {
		return mediadorAgrupacion;
	}

	public void setMediadorAgrupacion(GestorActivo mediadorAgrupacion) {
		this.mediadorAgrupacion = mediadorAgrupacion;
	}

	public List<ActivoAgrupacionObservacion> getAgrupacionObservacion() {
		return agrupacionObservacion;
	}

	public void setAgrupacionObservacion(List<ActivoAgrupacionObservacion> agrupacionObservacion) {
		this.agrupacionObservacion = agrupacionObservacion;
	}

	public List<Oferta> getOfertas() {
		return ofertas;
	}

	public void setOfertas(List<Oferta> ofertas) {
		this.ofertas = ofertas;
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

	public List<ActivoAgrupacionActivo> getActivos() {
		return activos;
	}

	public void setActivos(List<ActivoAgrupacionActivo> activos) {
		this.activos = activos;
	}

	public List<ActivoFoto> getFotos() {
		return fotos;
	}

	public void setFotos(List<ActivoFoto> fotos) {
		this.fotos = fotos;
	}
	
    public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}

	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}

	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}

	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	public Integer getIsFormalizacion() {
		return isFormalizacion;
	}

	public void setIsFormalizacion(Integer isFormalizacion) {
		this.isFormalizacion = isFormalizacion;
	}

	public Integer getUvemCodigoAgrupacionInmueble() {
		return uvemCodigoAgrupacionInmueble;
	}

	public void setUvemCodigoAgrupacionInmueble(Integer uvemCodigoAgrupacionInmueble) {
		this.uvemCodigoAgrupacionInmueble = uvemCodigoAgrupacionInmueble;
	}

	public DDTipoAlquiler getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(DDTipoAlquiler tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}

	public String getNumAgrupPrinexHPM() {
		return numAgrupPrinexHPM;
	}

	public void setNumAgrupPrinexHPM(String numAgrupPrinexHPM) {
		this.numAgrupPrinexHPM = numAgrupPrinexHPM;
	}

	public Boolean isComercializableConsPlano() {
		return comercializableConsPlano;
	}

	public void setComercializableConsPlano(Boolean comercializableConsPlano) {
		this.comercializableConsPlano = comercializableConsPlano;
	}

	public Boolean isExistePiloto() {
		return existePiloto;
	}

	public void setExistePiloto(Boolean existePiloto) {
		this.existePiloto = existePiloto;
	}

	public Boolean isEsVisitable() {
		return esVisitable;
	}

	public void setEsVisitable(Boolean esVisitable) {
		this.esVisitable = esVisitable;
	}

	public String getEmpresaPromotora() {
		return empresaPromotora;
	}

	public void setEmpresaPromotora(String empresaPromotora) {
		this.empresaPromotora = empresaPromotora;
	}

	public String getEmpresaComercializadora() {
		return empresaComercializadora;
	}

	public void setEmpresaComercializadora(String empresaComercializadora) {
		this.empresaComercializadora = empresaComercializadora;
	}
	
	public ActivoAutorizacionTramitacionOfertas getActivoAutorizacionTramitacionOfertas() {
		return activoAutorizacionTramitacionOfertas;
	}

	public void setActivoAutorizacionTramitacionOfertas(
			ActivoAutorizacionTramitacionOfertas activoAutorizacionTramitacionOfertas) {
		this.activoAutorizacionTramitacionOfertas = activoAutorizacionTramitacionOfertas;
	}

	public String getCodigoOnSareb() {
		return codigoOnSareb;
	}

	public void setCodigoOnSareb(String codigoOnSareb) {
		this.codigoOnSareb = codigoOnSareb;
	}

	public Boolean getComercializableConsPlano() {
		return comercializableConsPlano;
	}

	public Boolean getExistePiloto() {
		return existePiloto;
	}

	public Boolean getEsVisitable() {
		return esVisitable;
	}

	public ActivoAgrupacion getAgrupacionONDnd() {
		return agrupacionONDnd;
	}

	public void setAgrupacionONDnd(ActivoAgrupacion agrupacionONDnd) {
		this.agrupacionONDnd = agrupacionONDnd;
	}

	public DDSinSiNo getVentaPlano() {
		return ventaPlano;
	}

	public void setVentaPlano(DDSinSiNo ventaPlano) {
		this.ventaPlano = ventaPlano;
	}

	public Date getFechaPrevFinalizacion() {
		return fechaPrevFinalizacion;
	}

	public void setFechaPrevFinalizacion(Date fechaPrevFinalizacion) {
		this.fechaPrevFinalizacion = fechaPrevFinalizacion;
	}

	public Date getFechaEscrituraDesde() {
		return fechaEscrituraDesde;
	}

	public void setFechaEscrituraDesde(Date fechaEscrituraDesde) {
		this.fechaEscrituraDesde = fechaEscrituraDesde;
	}

	public Date getFechaEscrituraHasta() {
		return fechaEscrituraHasta;
	}

	public void setFechaEscrituraHasta(Date fechaEscrituraHasta) {
		this.fechaEscrituraHasta = fechaEscrituraHasta;
	}
	

}
