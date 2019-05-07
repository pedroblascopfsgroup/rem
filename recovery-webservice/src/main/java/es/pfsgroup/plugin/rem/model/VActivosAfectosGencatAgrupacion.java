package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Daniel Algaba
 *
 */
@Entity
@Table(name = "VI_ACTIVOS_AGRUPACION_GENCAT", schema = "${entity.schema}")
public class VActivosAfectosGencatAgrupacion implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "CONTADOR")
	private int contador;

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public int getContador() {
		return contador;
	}

	public void setContador(int contador) {
		this.contador = contador;
	}
}
