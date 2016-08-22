package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;


@Entity
@Table(name = "V_BUSQUEDA_PRESUPUESTOS_ACTIVO", schema = "${entity.schema}")
public class VBusquedaPresupuestosActivo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "PTO_ID")
	private String id;
	
	@Column(name = "ACT_ID")
	private String idActivo;
	
	@Column(name = "PTO_IMPORTE_INICIAL")
	private Double importeInicial;

	@Column(name = "EJE_ANYO")
	private String ejercicioAnyo;
	
	@Column(name = "INCREMENTO")
	private Double sumaIncrementos;
	
	@Transient
	private Double dispuesto;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public Double getImporteInicial() {
		return importeInicial;
	}

	public void setImporteInicial(Double importeInicial) {
		this.importeInicial = importeInicial;
	}

	public String getEjercicioAnyo() {
		return ejercicioAnyo;
	}

	public void setEjercicioAnyo(String ejercicioAnyo) {
		this.ejercicioAnyo = ejercicioAnyo;
	}

	public Double getSumaIncrementos() {
		return sumaIncrementos;
	}

	public void setSumaIncrementos(Double sumaIncrementos) {
		this.sumaIncrementos = sumaIncrementos;
	}

	public Double getDispuesto() {
		return dispuesto;
	}

	public void setDispuesto(Double dispuesto) {
		this.dispuesto = dispuesto;
	}
    
   

}