package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.model.dd.DDDistritoCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDEscaleraEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDPlantaEdificio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicacion;



/**
 * Modelo que gestiona la localizacion de un activo
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_LOC_LOCALIZACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoLocalizacion implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "LOC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoLocalizacionGenerator")
    @SequenceGenerator(name = "ActivoLocalizacionGenerator", sequenceName = "S_ACT_LOC_LOCALIZACION")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_LOC_ID")
    private NMBLocalizacionesBien localizacionBien;

	@Column(name = "LOC_LONGITUD")
	private BigDecimal longitud;
	
	@Column(name = "LOC_LATITUD")
	private BigDecimal latitud;
	
	@Column(name = "LOC_DIST_PLAYA")
	private Float distanciaPlaya;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TUB_ID")
	private DDTipoUbicacion tipoUbicacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PLN_ID")
	private DDPlantaEdificio plantaEdificio;	
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESE_ID")
	private DDEscaleraEdificio escaleraEdificio;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	
	@Column(name = "LOC_DIRECCION_DOS")
	private String direccionDos;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DIC_ID")
	private DDDistritoCaixa distritoCaixa;
	
	@Column(name = "LOC_BLOQUE")
	private String bloque;

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

	public NMBLocalizacionesBien getLocalizacionBien() {
		return localizacionBien;
	}

	public void setLocalizacionBien(NMBLocalizacionesBien localizacionBien) {
		this.localizacionBien = localizacionBien;
	}

	public BigDecimal getLongitud() {
		return longitud;
	}

	public void setLongitud(BigDecimal longitud) {
		this.longitud = longitud;
	}

	public BigDecimal getLatitud() {
		return latitud;
	}

	public void setLatitud(BigDecimal latitud) {
		this.latitud = latitud;
	}

	public Float getDistanciaPlaya() {
		return distanciaPlaya;
	}

	public void setDistanciaPlaya(Float distanciaPlaya) {
		this.distanciaPlaya = distanciaPlaya;
	}

	public DDTipoUbicacion getTipoUbicacion() {
		return tipoUbicacion;
	}

	public void setTipoUbicacion(DDTipoUbicacion tipoUbicacion) {
		this.tipoUbicacion = tipoUbicacion;
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

	public String getDireccionDos() {
		return direccionDos;
	}

	public void setDireccionDos(String direccionDos) {
		this.direccionDos = direccionDos;
	}

	public DDDistritoCaixa getDistritoCaixa() {
		return distritoCaixa;
	}

	public void setDistritoCaixa(DDDistritoCaixa distritoCaixa) {
		this.distritoCaixa = distritoCaixa;
	}
	
	public DDPlantaEdificio getPlantaEdificio() {
		return plantaEdificio;
	}

	public void setPlantaEdificio(DDPlantaEdificio plantaEdificio) {
		this.plantaEdificio = plantaEdificio;
	}

	public DDEscaleraEdificio getEscaleraEdificio() {
		return escaleraEdificio;
	}

	public void setEscaleraEdificio(DDEscaleraEdificio escaleraEdificio) {
		this.escaleraEdificio = escaleraEdificio;
	}

	public String getBloque() {
		return bloque;
	}

	public void setBloque(String bloque) {
		this.bloque = bloque;
	}  									
	
}
