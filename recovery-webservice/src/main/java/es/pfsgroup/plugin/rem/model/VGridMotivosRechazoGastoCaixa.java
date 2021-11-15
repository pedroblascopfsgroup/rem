package es.pfsgroup.plugin.rem.model;
import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_MOT_RECHAZO_GASTO_CX", schema = "${entity.schema}")
public class VGridMotivosRechazoGastoCaixa implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "RGS_ID")
	private Long id;
	
	@Column(name= "GASTO_ID")
	private Long gastoId;

	@Column(name = "GPV_NUM_GASTO")
	private Long numeroGasto;		

	@Column(name = "LES_CODIGO")
	private String listadoErroresCod;
	
	@Column(name = "LES_RETORNO")
	private String listadoErroresRetorno;
	
	@Column(name = "LES_DESCRIPCION")
	private String listadoErroresDesc;
	
	@Column(name = "NUM_LINEA")
	private Long numeroLinea;
	
	@Column(name = "ACT_ID")
	private Long activoId;
	
	@Column(name = "NUM_ACTIVO")
	private Long numeroActivo;

	@Column(name = "MENSAJE_ERROR")
	private String mensajeError;

	@Column(name = "FECHA_PROCESADO")
	private Date fechaProcesado;
	
	@Column(name = "TIPO_IMPORTE")
	private String tipoImporte;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getGastoId() {
		return gastoId;
	}

	public void setGastoId(Long gastoId) {
		this.gastoId = gastoId;
	}

	public Long getNumeroGasto() {
		return numeroGasto;
	}

	public void setNumeroGasto(Long numeroGasto) {
		this.numeroGasto = numeroGasto;
	}

	public String getListadoErroresCod() {
		return listadoErroresCod;
	}

	public void setListadoErroresCod(String listadoErroresCod) {
		this.listadoErroresCod = listadoErroresCod;
	}

	public String getListadoErroresRetorno() {
		return listadoErroresRetorno;
	}

	public void setListadoErroresRetorno(String listadoErroresRetorno) {
		this.listadoErroresRetorno = listadoErroresRetorno;
	}

	public String getListadoErroresDesc() {
		return listadoErroresDesc;
	}

	public void setListadoErroresDesc(String listadoErroresDesc) {
		this.listadoErroresDesc = listadoErroresDesc;
	}

	public Long getNumeroLinea() {
		return numeroLinea;
	}

	public void setNumeroLinea(Long numeroLinea) {
		this.numeroLinea = numeroLinea;
	}

	public Long getActivoId() {
		return activoId;
	}

	public void setActivoId(Long activoId) {
		this.activoId = activoId;
	}

	public Long getNumeroActivo() {
		return numeroActivo;
	}

	public void setNumeroActivo(Long numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	public String getMensajeError() {
		return mensajeError;
	}

	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}

	public Date getFechaProcesado() {
		return fechaProcesado;
	}

	public void setFechaProcesado(Date fechaProcesado) {
		this.fechaProcesado = fechaProcesado;
	}

	public String getTipoImporte() {
		return tipoImporte;
	}

	public void setTipoImporte(String tipoImporte) {
		this.tipoImporte = tipoImporte;
	}
	
}

