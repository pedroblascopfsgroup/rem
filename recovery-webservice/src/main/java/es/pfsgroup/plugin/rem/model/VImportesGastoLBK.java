package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_IMPORTES_GASTO_LBK", schema = "${entity.schema}")
public class VImportesGastoLBK implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "GPV_ID")
	private Long id;
	
	@Column(name="ID_ELEMENTO")
	private Long idElemento;
	
	@Column(name="TIPO_ELEMENTO")
	private String tipoElemento;
	
	@Column(name="IMPORTE_GASTO")
	private Double importeGasto;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdElemento() {
		return idElemento;
	}

	public void setIdElemento(Long idElemento) {
		this.idElemento = idElemento;
	}

	public String getTipoElemento() {
		return tipoElemento;
	}

	public void setTipoElemento(String tipoElemento) {
		this.tipoElemento = tipoElemento;
	}

	public Double getImporteGasto() {
		return importeGasto;
	}

	public void setImporteGasto(Double importeGasto) {
		this.importeGasto = importeGasto;
	}

	
}