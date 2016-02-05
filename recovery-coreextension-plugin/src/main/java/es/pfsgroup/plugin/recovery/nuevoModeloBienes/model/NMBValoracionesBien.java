package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;

@Entity
@Table(name = "BIE_VALORACIONES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBValoracionesBien implements Serializable, Auditable, NMBValoracionesBienInfo{

	private static final long serialVersionUID = -3290771629640906608L;

	@Id
    @Column(name = "BIE_VAL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBValoracionesBienGenerator")
    @SequenceGenerator(name = "NMBValoracionesBienGenerator", sequenceName = "S_BIE_VALORACIONES")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private NMBBien bien;
	
	@Column(name = "BIE_FECHA_VALOR_SUBJETIVO")
    private Date fechaValorSubjetivo;
	
	@Column(name = "BIE_IMPORTE_VALOR_SUBJETIVO")
    private Float importeValorSubjetivo;
	
	@Column(name = "BIE_FECHA_VALOR_APRECIACION")
    private Date fechaValorApreciacion;
	
	@Column(name = "BIE_IMPORTE_VALOR_APRECIACION")
    private Float importeValorApreciacion;
	
	@Column(name = "BIE_FECHA_VALOR_TASACION")
    private Date fechaValorTasacion;
	
	@Column(name = "BIE_IMPORTE_VALOR_TASACION")
    private Float importeValorTasacion;
	
	@Column(name = "BIE_RESPUESTA_CONSULTA") 
	private String respuestaConsulta;
	
	@Column(name = "BIE_VALOR_TASACION_EXT")  
    private Float valorTasacionExterna;
    
    @Column(name = "BIE_F_TAS_EXTERNA")      
    private Date fechaTasacionExterna;
    
    @OneToOne
    @JoinColumn(name = "DD_TRA_ID ")
    private DDTasadora tasadora;
	
    @Column(name = "BIE_F_SOL_TASACION") 
    private Date fechaSolicitudTasacion;
    
    @Column(name = "BIE_CD_NUITA") 
    private Long codigoNuita;

    public String getRespuestaConsulta() {
		return respuestaConsulta;
	}

	public void setRespuestaConsulta(String respuestaConsulta) {
		this.respuestaConsulta = respuestaConsulta;
	}

	public Float getValorTasacionExterna() {
		return valorTasacionExterna;
	}

	public void setValorTasacionExterna(Float valorTasacionExterna) {
		this.valorTasacionExterna = valorTasacionExterna;
	}

	public Date getFechaTasacionExterna() {
		return fechaTasacionExterna;
	}

	public void setFechaTasacionExterna(Date fechaTasacionExterna) {
		this.fechaTasacionExterna = fechaTasacionExterna;
	}

	public DDTasadora getTasadora() {
		return tasadora;
	}

	public void setTasadora(DDTasadora tasadora) {
		this.tasadora = tasadora;
	}

	public Date getFechaSolicitudTasacion() {
		return fechaSolicitudTasacion;
	}

	public void setFechaSolicitudTasacion(Date fechaSolicitudTasacion) {
		this.fechaSolicitudTasacion = fechaSolicitudTasacion;
	}

	@Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public Date getFechaValorSubjetivo() {
		return fechaValorSubjetivo;
	}

	public void setFechaValorSubjetivo(Date fechaValorSubjetivo) {
		this.fechaValorSubjetivo = fechaValorSubjetivo;
	}

	public Float getImporteValorSubjetivo() {
		return importeValorSubjetivo;
	}

	public void setImporteValorSubjetivo(Float importeValorSubjetivo) {
		this.importeValorSubjetivo = importeValorSubjetivo;
	}

	public Date getFechaValorApreciacion() {
		return fechaValorApreciacion;
	}

	public void setFechaValorApreciacion(Date fechaValorApreciacion) {
		this.fechaValorApreciacion = fechaValorApreciacion;
	}

	public Float getImporteValorApreciacion() {
		return importeValorApreciacion;
	}

	public void setImporteValorApreciacion(Float importeValorApreciacion) {
		this.importeValorApreciacion = importeValorApreciacion;
	}

	public Date getFechaValorTasacion() {
		return fechaValorTasacion;
	}

	public void setFechaValorTasacion(Date fechaValorTasacion) {
		this.fechaValorTasacion = fechaValorTasacion;
	}

	public Float getImporteValorTasacion() {
		return importeValorTasacion;
	}

	public void setImporteValorTasacion(Float importeValorTasacion) {
		this.importeValorTasacion = importeValorTasacion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Long getCodigoNuita() {
		return codigoNuita;
	}

	public void setCodigoNuita(Long codigoNuita) {
		this.codigoNuita = codigoNuita;
	}	
	
}
