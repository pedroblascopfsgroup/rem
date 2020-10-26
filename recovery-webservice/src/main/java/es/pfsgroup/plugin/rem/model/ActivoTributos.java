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
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoExento;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoSolicitud;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSolicitudTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTributo;


/**
 * Modelo que gestiona los tributos de los activos
 *  
 * @author Juanjo Arbona
 *
 */
@Entity
@Table(name = "ACT_TRI_TRIBUTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoTributos implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ACT_TRI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgrupacionGenerator")
    @SequenceGenerator(name = "ActivoAgrupacionGenerator", sequenceName = "S_ACT_AGR_AGRUPACION")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
        
    @Column(name = "ACT_TRI_FECHA_PRESENTACION_RECURSO")
	private Date fechaPresentacionRecurso;
    
    @Column(name = "ACT_TRI_FECHA_RECEPCION_PROPIETARIO")
	private Date fechaRecepcionPropietario;
    
    @Column(name = "ACT_TRI_FECHA_RECEPCION_GESTORIA")
	private Date fechaRecepcionGestoria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TST_ID")
    private DDTipoSolicitudTributo tipoSolicitudTributo;
	
	@Column(name = "OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "ACT_TRI_FECHA_RECEPCION_RECURSO_PROPIETARIO")
	private Date fechaRecepcionRecursoPropietario;
	 
	@Column(name = "ACT_TRI_FECHA_RECEPCION_RECURSO_GESTORIA")
	private Date fechaRecepcionRecursoGestoria;
	
	@Column(name = "ACT_TRI_FECHA_RESPUESTA_RECURSO")
	private Date fechaRespuestaRecurso;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_FAV_ID")
    private DDFavorable favorable;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor;
	
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ACT_NUM_TRIBUTO")
	private Long numTributo;

	@OneToMany(mappedBy = "activoTributo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_TRI_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<ActivoAdjuntoTributo> adjuntos;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPT_ID")
    private DDTipoTributo tipoTributo;
	
	@Column(name = "ACT_TRI_FECHA_RECEPCION_TRIBUTO")
	private Date fechaRecepcionTributo;
	
	@Column(name = "ACT_TRI_FECHA_PAGO_TRIBUTO")
	private Date fechaPagoTributo;
	
	@Column(name = "ACT_TRI_IMPORTE_PAGADO")
	private Double importePagado;
	
	
    @Column(name = "NUM_EXPEDIENTE")
    private Long expediente;
	
	@Column(name = "ACT_TRI_FECHA_COM_DEV_INGRESO")
	private Date fechaComunicacionDevolucionIngreso;
	
	@Column(name = "ACT_TRI_IMPORTE_REC_RECURSO")
	private Double importeRecuperadoRecurso;
	
	@Column(name = "ACT_TRI_EXENTO")
	private Boolean tributoExento;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MOE_ID")
    private DDMotivoExento motivoExento;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RES_ID")
    private DDResultadoSolicitud resultadoSolicitud;
	
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaPresentacionRecurso() {
		return fechaPresentacionRecurso;
	}

	public void setFechaPresentacionRecurso(Date fechaPresentacionRecurso) {
		this.fechaPresentacionRecurso = fechaPresentacionRecurso;
	}

	public Date getFechaRecepcionPropietario() {
		return fechaRecepcionPropietario;
	}

	public void setFechaRecepcionPropietario(Date fechaRecepcionPropietario) {
		this.fechaRecepcionPropietario = fechaRecepcionPropietario;
	}

	public Date getFechaRecepcionGestoria() {
		return fechaRecepcionGestoria;
	}

	public void setFechaRecepcionGestoria(Date fechaRecepcionGestoria) {
		this.fechaRecepcionGestoria = fechaRecepcionGestoria;
	}

	public DDTipoSolicitudTributo getTipoSolicitudTributo() {
		return tipoSolicitudTributo;
	}

	public void setTipoSolicitudTributo(DDTipoSolicitudTributo tipoSolicitudTributo) {
		this.tipoSolicitudTributo = tipoSolicitudTributo;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Date getFechaRecepcionRecursoPropietario() {
		return fechaRecepcionRecursoPropietario;
	}

	public void setFechaRecepcionRecursoPropietario(Date fechaRecepcionRecursoPropietario) {
		this.fechaRecepcionRecursoPropietario = fechaRecepcionRecursoPropietario;
	}

	public Date getFechaRecepcionRecursoGestoria() {
		return fechaRecepcionRecursoGestoria;
	}

	public void setFechaRecepcionRecursoGestoria(Date fechaRecepcionRecursoGestoria) {
		this.fechaRecepcionRecursoGestoria = fechaRecepcionRecursoGestoria;
	}

	public Date getFechaRespuestaRecurso() {
		return fechaRespuestaRecurso;
	}

	public void setFechaRespuestaRecurso(Date fechaRespuestaRecurso) {
		this.fechaRespuestaRecurso = fechaRespuestaRecurso;
	}

	public DDFavorable getFavorable() {
		return favorable;
	}

	public void setFavorable(DDFavorable favorable) {
		this.favorable = favorable;
	}

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public List<ActivoAdjuntoTributo> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<ActivoAdjuntoTributo> adjuntos) {
		this.adjuntos = adjuntos;
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

	public Long getNumTributo() {
		return numTributo;
	}

	public void setNumTributo(Long numTributo) {
		this.numTributo = numTributo;
	}
	
	
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public ActivoAdjuntoTributo getAdjunto(Long id) {
        for (ActivoAdjuntoTributo adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

	public DDTipoTributo getTipoTributo() {
		return tipoTributo;
	}

	public void setTipoTributo(DDTipoTributo tipoTributo) {
		this.tipoTributo = tipoTributo;
	}

	public Date getFechaRecepcionTributo() {
		return fechaRecepcionTributo;
	}

	public void setFechaRecepcionTributo(Date fechaRecepcionTributo) {
		this.fechaRecepcionTributo = fechaRecepcionTributo;
	}

	public Date getFechaPagoTributo() {
		return fechaPagoTributo;
	}

	public void setFechaPagoTributo(Date fechaPagoTributo) {
		this.fechaPagoTributo = fechaPagoTributo;
	}

	public Double getImportePagado() {
		return importePagado;
	}

	public void setImportePagado(Double importePagado) {
		this.importePagado = importePagado;
	}

	public Long getExpediente() {
		return expediente;
	}

	public void setExpediente(Long expediente) {
		this.expediente = expediente;
	}

	public Date getFechaComunicacionDevolucionIngreso() {
		return fechaComunicacionDevolucionIngreso;
	}

	public void setFechaComunicacionDevolucionIngreso(Date fechaComunicacionDevolucionIngreso) {
		this.fechaComunicacionDevolucionIngreso = fechaComunicacionDevolucionIngreso;
	}

	public Double getImporteRecuperadoRecurso() {
		return importeRecuperadoRecurso;
	}

	public void setImporteRecuperadoRecurso(Double importeRecuperadoRecurso) {
		this.importeRecuperadoRecurso = importeRecuperadoRecurso;
	}

	public Boolean getTributoExento() {
		return tributoExento;
	}

	public void setTributoExento(Boolean tributoExento) {
		this.tributoExento = tributoExento;
	}

	public DDMotivoExento getMotivoExento() {
		return motivoExento;
	}

	public void setMotivoExento(DDMotivoExento motivoExento) {
		this.motivoExento = motivoExento;
	}

	public DDResultadoSolicitud getResultadoSolicitud() {
		return resultadoSolicitud;
	}

	public void setResultadoSolicitud(DDResultadoSolicitud resultadoSolicitud) {
		this.resultadoSolicitud = resultadoSolicitud;
	}

}
