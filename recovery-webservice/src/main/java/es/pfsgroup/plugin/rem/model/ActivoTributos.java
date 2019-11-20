package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSolicitudTributo;


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
