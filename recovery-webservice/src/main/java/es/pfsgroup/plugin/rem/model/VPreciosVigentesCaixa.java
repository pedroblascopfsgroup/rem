package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_PRECIOS_VIGENTES_CAIXA", schema = "${entity.schema}")
public class VPreciosVigentesCaixa implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "ID")  
	private String idCaixa;	
	
	@Column(name = "VAL_ID")  
	private String idPrecioVigenteCaixa;
	
	@Column(name = "ACT_ID")  
	private String idActivoCaixa;
	
	@Column(name = "DD_TPC_DESCRIPCION")
	private String descripcionTipoPrecioCaixa;
	
	@Column(name = "DD_TPC_CODIGO")
	private String codigoTipoPrecioCaixa;
	
	@Column(name="DD_TPC_ORDEN")
	private Integer ordenCaixa;

	@Column(name = "VAL_IMPORTE")
	private Double importeCaixa;
	
	@Column(name = "VAL_FECHA_APROBACION")
	private Date fechaAprobacionCaixa;
	
	@Column(name = "VAL_FECHA_CARGA")
	private Date fechaCargaCaixa;
	
	@Column(name = "VAL_FECHA_INICIO")
	private Date fechaInicioCaixa;
	
	@Column(name = "VAL_FECHA_FIN")
	private Date fechaFinCaixa;
	
	@Column(name = "GESTOR_PRECIOS")
	private String gestorCaixa;
	
	@Column(name = "VAL_OBSERVACIONES")
	private String observacionesCaixa;

	public String getIdCaixa() {
		return idCaixa;
	}

	public void setIdCaixa(String idCaixa) {
		this.idCaixa = idCaixa;
	}

	public String getIdPrecioVigenteCaixa() {
		return idPrecioVigenteCaixa;
	}

	public void setIdPrecioVigenteCaixa(String idPrecioVigenteCaixa) {
		this.idPrecioVigenteCaixa = idPrecioVigenteCaixa;
	}

	public String getIdActivoCaixa() {
		return idActivoCaixa;
	}

	public void setIdActivoCaixa(String idActivoCaixa) {
		this.idActivoCaixa = idActivoCaixa;
	}

	public String getDescripcionTipoPrecioCaixa() {
		return descripcionTipoPrecioCaixa;
	}

	public void setDescripcionTipoPrecioCaixa(String descripcionTipoPrecioCaixa) {
		this.descripcionTipoPrecioCaixa = descripcionTipoPrecioCaixa;
	}

	public String getCodigoTipoPrecioCaixa() {
		return codigoTipoPrecioCaixa;
	}

	public void setCodigoTipoPrecioCaixa(String codigoTipoPrecioCaixa) {
		this.codigoTipoPrecioCaixa = codigoTipoPrecioCaixa;
	}

	public Integer getOrdenCaixa() {
		return ordenCaixa;
	}

	public void setOrdenCaixa(Integer ordenCaixa) {
		this.ordenCaixa = ordenCaixa;
	}

	public Double getImporteCaixa() {
		return importeCaixa;
	}

	public void setImporteCaixa(Double importeCaixa) {
		this.importeCaixa = importeCaixa;
	}

	public Date getFechaAprobacionCaixa() {
		return fechaAprobacionCaixa;
	}

	public void setFechaAprobacionCaixa(Date fechaAprobacionCaixa) {
		this.fechaAprobacionCaixa = fechaAprobacionCaixa;
	}

	public Date getFechaCargaCaixa() {
		return fechaCargaCaixa;
	}

	public void setFechaCargaCaixa(Date fechaCargaCaixa) {
		this.fechaCargaCaixa = fechaCargaCaixa;
	}

	public Date getFechaInicioCaixa() {
		return fechaInicioCaixa;
	}

	public void setFechaInicioCaixa(Date fechaInicioCaixa) {
		this.fechaInicioCaixa = fechaInicioCaixa;
	}

	public Date getFechaFinCaixa() {
		return fechaFinCaixa;
	}

	public void setFechaFinCaixa(Date fechaFinCaixa) {
		this.fechaFinCaixa = fechaFinCaixa;
	}

	public String getGestorCaixa() {
		return gestorCaixa;
	}

	public void setGestorCaixa(String gestorCaixa) {
		this.gestorCaixa = gestorCaixa;
	}

	public String getObservacionesCaixa() {
		return observacionesCaixa;
	}

	public void setObservacionesCaixa(String observacionesCaixa) {
		this.observacionesCaixa = observacionesCaixa;
	}

}