package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.ArrayList;
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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;


/**
 * Modelo que gestiona la informacion de una oferta
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "OFR_OFERTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Oferta implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "OFR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaGenerator")
    @SequenceGenerator(name = "OfertaGenerator", sequenceName = "S_OFR_OFERTAS")
    private Long id;
	
    @Column(name = "OFR_WEBCOM_ID")
    private Long idWebCom;
	
    @Column(name = "OFR_NUM_OFERTA")
    private Long numOferta;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;
	
	@Column(name="OFR_IMPORTE")
	private Double importeOferta;
	
	@Column(name="OFR_IMPORTE_CONTRAOFERTA")
	private Double importeContraOferta;
	
	@Column(name="OFR_FECHA_CONTRAOFERTA")
	private Date fechaContraoferta;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EOF_ID")
	private DDEstadoOferta estadoOferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MRO_ID")
	private DDMotivoRechazoOferta motivoRechazo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EVO_ID")
	private DDEstadosVisitaOferta estadoVisitaOferta;    
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TOF_ID")
	private DDTipoOferta tipoOferta;      
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CLC_ID")
    private ClienteComercial cliente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VIS_ID")
    private Visita visita;
    
    @Column(name = "OFR_FECHA_ACCION")
    private Date fechaAccion;
    
    @Column(name = "OFR_USUARIO_BAJA")
    private String usuarioBaja;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioAccion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_PRESCRIPTOR")
	private ActivoProveedor prescriptor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_API_RESPONSABLE")
	private ActivoProveedor apiResponsable;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_CUSTODIO")
	private ActivoProveedor custodio;   
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_FDV")
	private ActivoProveedor fdv;
    
    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TitularesAdicionalesOferta> titularesAdicionales;
    
    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TextosOferta> textos;
    
    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private List<ActivoOferta> activosOferta;
    
    @Column(name = "OFR_ORIGEN")
    private String origen;
   
    
    @Column(name = "OFR_FECHA_ALTA")
    private Date fechaAlta;
    
    @Column(name = "OFR_FECHA_NOTIFICACION")
    private Date fechaNotificacion;
    
	@Column(name="OFR_IMPORTE_APROBADO")
	private Double importeOfertaAprobado; 
	
	@Column(name="OFR_IND_LOTE_RESTRINGIDO")
	private Integer indicadorLoteRestringido;
	
	@Column(name="OFR_FECHA_RECHAZO")
	private Date fechaRechazoOferta;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CAP_ID")
	private DDCanalPrescripcion canalPrescripcion;
    
    // Datos de Tanteo y Retracto +-+-+-+-+-+ TR
	@Column(name="OFR_DESDE_TANTEO")
	private Boolean desdeTanteo;

	@Column(name="OFR_CONDICIONES_TX")
	private String condicionesTransmision;
	
	@Column(name="OFR_FECHA_COMUNIC_REG")
	private Date fechaComunicacionReg;
	
	@Column(name="OFR_FECHA_CONTESTACION")
	private Date fechaContestacion;
	
	@Column(name="OFR_FECHA_SOLICITUD_VISITA")
	private Date fechaSolicitudVisita;
	
	@Column(name="OFR_FECHA_REALIZACION_VISITA")
	private Date fechaRealizacionVisita;
	
	@Column(name="OFR_FECHA_HASTA_TANTEO")
	private Date fechaFinTanteo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_DRT_ID")
	private DDResultadoTanteo resultadoTanteo;
	
	@Column(name="OFR_INTENCION_FINANCIAR")
	private Integer intencionFinanciar;
	
	@Column(name="OFR_FECHA_MAX_FORMALIZACION")
	private Date plazoMaxFormalizacion;	
	//+-+-+-+-+-+ TR
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_SUCURSAL")
	private ActivoProveedor sucursal;
    
    @Column(name="OFR_OFERTA_EXPRESS")
	private Boolean ofertaExpress;	
    
    @Column(name="OFR_NECESITA_FINANCIACION")
	private Boolean necesitaFinanciacion;	
    
    @Column(name="OFR_OBSERVACIONES")
	private String observaciones;	
    
    @Column(name = "OFR_UVEM_ID")
    private Long idUvem;
    
    @Column(name = "OFR_VENTA_DIRECTA")
    private Boolean ventaDirecta = false; 
     
    
	

	

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

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
	
	public Long getIdWebCom() {
		return idWebCom;
	}

	public void setIdWebCom(Long idWebCom) {
		this.idWebCom = idWebCom;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public DDEstadoOferta getEstadoOferta() {
		return estadoOferta;
	}

	public void setEstadoOferta(DDEstadoOferta estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	public DDMotivoRechazoOferta getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(DDMotivoRechazoOferta motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	
	public DDEstadosVisitaOferta getEstadoVisitaOferta() {
		return estadoVisitaOferta;
	}

	public void setEstadoVisitaOferta(DDEstadosVisitaOferta estadoVisitaOferta) {
		this.estadoVisitaOferta = estadoVisitaOferta;
	}

	public DDTipoOferta getTipoOferta() {
		return tipoOferta;
	}

	public void setTipoOferta(DDTipoOferta tipoOferta) {
		this.tipoOferta = tipoOferta;
	}

	public ClienteComercial getCliente() {
		return cliente;
	}

	public void setCliente(ClienteComercial cliente) {
		this.cliente = cliente;
	}

	public Visita getVisita() {
		return visita;
	}

	public void setVisita(Visita visita) {
		this.visita = visita;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Usuario getUsuarioAccion() {
		return usuarioAccion;
	}

	public void setUsuarioAccion(Usuario usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}

	public ActivoProveedor getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(ActivoProveedor prescriptor) {
		this.prescriptor = prescriptor;
	}

	public List<TitularesAdicionalesOferta> getTitularesAdicionales() {
		return titularesAdicionales;
	}

	public void setTitularesAdicionales(
			List<TitularesAdicionalesOferta> titularesAdicionales) {
		this.titularesAdicionales = titularesAdicionales;
	}

	public List<TextosOferta> getTextos() {
		return textos;
	}

	public void setTextos(List<TextosOferta> textos) {
		this.textos = textos;
	}

	public List<ActivoOferta> getActivosOferta() {
		
		if(activosOferta == null) activosOferta = new ArrayList<ActivoOferta>(); 
		
		return activosOferta;
	}

	public void setActivosOferta(List<ActivoOferta> activosOferta) {
		this.activosOferta = activosOferta;
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

	/**
	 * Devuelve un activo. El activo principal si es una agrupación, 
	 * el primer y único activo relacionado con la oferta si no es agrupación.
	 * @return Activo activo
	 */
	public Activo getActivoPrincipal() {
		
		Activo activo = null;
		
		if(!Checks.esNulo(this.getAgrupacion())) {
			activo = this.getAgrupacion().getActivoPrincipal();
			if(Checks.esNulo(activo)) {
				List<ActivoAgrupacionActivo> listaActivosAgrupacion = this.getAgrupacion().getActivos();
				if(!Checks.estaVacio(listaActivosAgrupacion)){
					activo = listaActivosAgrupacion.get(0).getActivo();
				}
			}
		}else if(!Checks.esNulo(this.getActivosOferta()) && !this.getActivosOferta().isEmpty()) {
			activo = this.getActivosOferta().get(0).getPrimaryKey().getActivo();
		}	
		return activo;
		
	}

	public Double getImporteContraOferta() {
		return importeContraOferta;
	}

	public void setImporteContraOferta(Double importeContraOferta) {
		this.importeContraOferta = importeContraOferta;
	}

	public Date getFechaContraoferta() {
		return fechaContraoferta;
	}

	public void setFechaContraoferta(Date fechaContraoferta) {
		this.fechaContraoferta = fechaContraoferta;
	}

	public ActivoProveedor getApiResponsable() {
		return apiResponsable;
	}

	public void setApiResponsable(ActivoProveedor apiResponsable) {
		this.apiResponsable = apiResponsable;
	}

	public Date getFechaNotificacion() {
		return fechaNotificacion;
	}

	public void setFechaNotificacion(Date fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}

	public ActivoProveedor getCustodio() {
		return custodio;
	}

	public void setCustodio(ActivoProveedor custodio) {
		this.custodio = custodio;
	}

	public ActivoProveedor getFdv() {
		return fdv;
	}

	public void setFdv(ActivoProveedor fdv) {
		this.fdv = fdv;
	}

	public Double getImporteOfertaAprobado() {
		return importeOfertaAprobado;
	}

	public void setImporteOfertaAprobado(Double importeOfertaAprobado) {
		this.importeOfertaAprobado = importeOfertaAprobado;
	}

	public Integer getIndicadorLoteRestringido() {
		return indicadorLoteRestringido;
	}

	public void setIndicadorLoteRestringido(Integer indicadorLoteRestringido) {
		this.indicadorLoteRestringido = indicadorLoteRestringido;
	}

	public Date getFechaRechazoOferta() {
		return fechaRechazoOferta;
	}

	public void setFechaRechazoOferta(Date fechaRechazoOferta) {
		this.fechaRechazoOferta = fechaRechazoOferta;
	}

	public DDCanalPrescripcion getCanalPrescripcion() {
		return canalPrescripcion;
	}

	public void setCanalPrescripcion(DDCanalPrescripcion canalPrescripcion) {
		this.canalPrescripcion = canalPrescripcion;
	}
	
	public String getCondicionesTransmision() {
		return condicionesTransmision;
	}

	public void setCondicionesTransmision(String condicionesTransmision) {
		this.condicionesTransmision = condicionesTransmision;
	}

	public Date getFechaComunicacionReg() {
		return fechaComunicacionReg;
	}

	public void setFechaComunicacionReg(Date fechaComunicacionReg) {
		this.fechaComunicacionReg = fechaComunicacionReg;
	}

	public Date getFechaContestacion() {
		return fechaContestacion;
	}

	public void setFechaContestacion(Date fechaContestacion) {
		this.fechaContestacion = fechaContestacion;
	}

	public Date getFechaSolicitudVisita() {
		return fechaSolicitudVisita;
	}

	public void setFechaSolicitudVisita(Date fechaSolicitudVisita) {
		this.fechaSolicitudVisita = fechaSolicitudVisita;
	}
	
	public Date getFechaRealizacionVisita() {
		return fechaRealizacionVisita;
	}

	public void setFechaRealizacionVisita(Date fechaRealizacionVisita) {
		this.fechaRealizacionVisita = fechaRealizacionVisita;
	}
	
	public Date getFechaFinTanteo() {
		return fechaFinTanteo;
	}

	public void setFechaFinTanteo(Date fechaFinTanteo) {
		this.fechaFinTanteo = fechaFinTanteo;
	}

	public DDResultadoTanteo getResultadoTanteo() {
		return resultadoTanteo;
	}

	public void setResultadoTanteo(DDResultadoTanteo resultadoTanteo) {
		this.resultadoTanteo = resultadoTanteo;
	}

	public Date getPlazoMaxFormalizacion() {
		return plazoMaxFormalizacion;
	}

	public void setPlazoMaxFormalizacion(Date plazoMaxFormalizacion) {
		this.plazoMaxFormalizacion = plazoMaxFormalizacion;
	}

	public Boolean getDesdeTanteo() {
		return desdeTanteo;
	}

	public void setDesdeTanteo(Boolean desdeTanteo) {
		this.desdeTanteo = desdeTanteo;
	}

	public Integer getIntencionFinanciar() {
		return intencionFinanciar;
	}

	public void setIntencionFinanciar(Integer intencionFinanciar) {
		this.intencionFinanciar = intencionFinanciar;
	}

	public ActivoProveedor getSucursal() {
		return sucursal;
	}

	public void setSucursal(ActivoProveedor sucursal) {
		this.sucursal = sucursal;
	}

	public String getUsuarioBaja() {
		return usuarioBaja;
	}

	public void setUsuarioBaja(String usuarioBaja) {
		this.usuarioBaja = usuarioBaja;
	}

	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}

	public Boolean getOfertaExpress() {
		return ofertaExpress == null ? false : ofertaExpress;
	}

	public void setOfertaExpress(Boolean ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public Boolean getNecesitaFinanciacion() {
		return necesitaFinanciacion;
	}

	public void setNecesitaFinanciacion(Boolean necesitaFinanciacion) {
		this.necesitaFinanciacion = necesitaFinanciacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Long getIdUvem() {
		return idUvem;
	}

	public void setIdUvem(Long idUvem) {
		this.idUvem = idUvem;
	}
	
	public Boolean getVentaDirecta() {
		if(ventaDirecta == null){
			return false;
		}else{
			return ventaDirecta;
		}
		
	}

	public void setVentaDirecta(Boolean ventaDirecta) {
		this.ventaDirecta = ventaDirecta;
	}

}
