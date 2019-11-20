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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDJuntaComunidades;

@Entity
@Table(name = "VI_BUSQUEDA_JUNTAS", schema = "${entity.schema}")
public class VActivoJuntaPropietarios implements Serializable {

	private static final long serialVersionUID = 750359188915093506L;

	@Id
	@Column(name = "JCM_ID")	
	private Long id;
	
	@Column(name = "ACT_ID")
	private Long activo;
	
	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name = "PVE_COD_REM")
	private String codProveedor;
	
	@Column(name = "PVE_NOMBRE")
	private String proveedor;
	
	@Column(name = "JCM_FECHA_JUNTA")
	private Date fechaJunta;
	
	@Column(name = "JCM_COMUNIDAD")
	private Long comunidad;
	
	@Column(name = "DD_CRA_DESCRIPCION")
	private String cartera;
	
	@Column(name = "BIE_LOC_DIRECCION")
	private String localizacion;
	
	@Column(name = "JCM_PORCENTAJE_PARTICIPACION")
	private Double porcentaje;
	
	@Column(name = "JCM_PROMOCION_MAYOR_50")
	private Long promoMayor50;
	
	@Column(name = "JCM_PROMOCION_ENTRE_20_50")
	private Long promo20a50;
	
	@Column(name = "DD_JCP_DESCRIPCION")
	private String junta;
		
	@Column(name = "JCM_ACT_JUDIC_CON_PROMOCION")	
	private Long judicial;
	
	@Column(name = "JCM_DERRAMA_MAYOR_5000")
	private Long derrama;
		
	@Column(name = "JCM_MODIFICACIONES_ESTATUTOS")
	private Long estatutos;
	
	@Column(name = "JCM_ITE")
	private Long ite;

	@Column(name = "JCM_ACTUACIONES_CONTRA_MOROSOS")
	private Long morosos;
	
	@Column(name = "JCM_MODIFICA_CUOTA")
	private Long cuota;
	
	@Column(name = "JCM_OTROS")
	private String otros;

	@Column(name = "JCM_IMPORTE")
	private Double importe;
	
	@Column(name = "JCM_CUOTA_ORDINARIA")
	private Double ordinaria;
	
	@Column(name = "JCM_CUOTA_EXTRA")
	private Double extra;

	@Column(name = "JCM_SUMINISTROS")
	private Double suministros;

	@Column(name = "JCM_PROPUESTA")
	private String propuesta;

	@Column(name = "JCM_GUION_DE_VOTO")
	private String voto;

	@Column(name = "JCM_INDICACIONES")
	private String indicaciones;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getActivo() {
		return activo;
	}

	public void setActivo(Long activo) {
		this.activo = activo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getCodProveedor() {
		return codProveedor;
	}

	public void setCodProveedor(String codProveedor) {
		this.codProveedor = codProveedor;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public Date getFechaJunta() {
		return fechaJunta;
	}

	public void setFechaJunta(Date fechaJunta) {
		this.fechaJunta = fechaJunta;
	}

	public Long getComunidad() {
		return comunidad;
	}

	public void setComunidad(Long comunidad) {
		this.comunidad = comunidad;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getLocalizacion() {
		return localizacion;
	}

	public void setLocalizacion(String localizacion) {
		this.localizacion = localizacion;
	}

	public Double getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Double porcentaje) {
		this.porcentaje = porcentaje;
	}

	public Long getPromoMayor50() {
		return promoMayor50;
	}

	public void setPromoMayor50(Long promoMayor50) {
		this.promoMayor50 = promoMayor50;
	}

	public Long getPromo20a50() {
		return promo20a50;
	}

	public void setPromo20a50(Long promo20a50) {
		this.promo20a50 = promo20a50;
	}

	public String getJunta() {
		return junta;
	}

	public void setJunta(String junta) {
		this.junta = junta;
	}

	public Long getJudicial() {
		return judicial;
	}

	public void setJudicial(Long judicial) {
		this.judicial = judicial;
	}

	public Long getDerrama() {
		return derrama;
	}

	public void setDerrama(Long derrama) {
		this.derrama = derrama;
	}

	public Long getEstatutos() {
		return estatutos;
	}

	public void setEstatutos(Long estatutos) {
		this.estatutos = estatutos;
	}

	public Long getIte() {
		return ite;
	}

	public void setIte(Long ite) {
		this.ite = ite;
	}

	public Long getMorosos() {
		return morosos;
	}

	public void setMorosos(Long morosos) {
		this.morosos = morosos;
	}

	public Long getCuota() {
		return cuota;
	}

	public void setCuota(Long cuota) {
		this.cuota = cuota;
	}

	public String getOtros() {
		return otros;
	}

	public void setOtros(String otros) {
		this.otros = otros;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Double getOrdinaria() {
		return ordinaria;
	}

	public void setOrdinaria(Double ordinaria) {
		this.ordinaria = ordinaria;
	}

	public Double getExtra() {
		return extra;
	}

	public void setExtra(Double extra) {
		this.extra = extra;
	}

	public Double getSuministros() {
		return suministros;
	}

	public void setSuministros(Double suministros) {
		this.suministros = suministros;
	}

	public String getPropuesta() {
		return propuesta;
	}

	public void setPropuesta(String propuesta) {
		this.propuesta = propuesta;
	}

	public String getVoto() {
		return voto;
	}

	public void setVoto(String voto) {
		this.voto = voto;
	}

	public String getIndicaciones() {
		return indicaciones;
	}

	public void setIndicaciones(String indicaciones) {
		this.indicaciones = indicaciones;
	}

	
}
