package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_NUM_ACT_TIPO_PRECIO", schema = "${entity.schema}")
public class VBusquedaNumActivosTipoPrecio implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "FILA")
	private Long fila;

	@Column(name = "ENTIDAD_CODIGO")
    private String entidadPropietariaCodigo;
    
    @Column(name = "ENTIDAD_DESCRIPCION")
    private String entidadPropietariaDescripcion;
    
    @Column(name = "NIVEL")
    private Long nivel;
    
    @Column(name = "SUBCARTERA_CODIGO")
    private String subcarteraCodigo;
    
    @Column(name = "SUBCARTERA_DESCRIPCION")
    private String subcarteraDescripcion;
    
	@Column(name = "ESTADO_FISICO_CODIGO")
    private String estadoFisicoCodigo;

	@Column(name = "ESTADO_FISICO_DESCRIPCION")
    private String estadoFisicoDescripcion;
    
    @Column(name = "NUM_ACTIVOS_PRECIAR")
    private String numActivosPreciar;
    
    @Column(name = "NUM_ACTIVOS_REPRECIAR")
    private String numActivosRepreciar;
    
    @Column(name = "NUM_ACTIVOS_DESCUENTO")
    private String numActivosDescuento;
    

	public Long getFila() {
		return fila;
	}

	public void setFila(Long fila) {
		this.fila = fila;
	}
	
	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public Long getNivel() {
		return nivel;
	}

	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getSubcarteraDescripcion() {
		return subcarteraDescripcion;
	}

	public void setSubcarteraDescripcion(String subcarteraDescripcion) {
		this.subcarteraDescripcion = subcarteraDescripcion;
	}
	
    public String getEstadoFisicoCodigo() {
		return estadoFisicoCodigo;
	}

	public void setEstadoFisicoCodigo(String estadoFisicoCodigo) {
		this.estadoFisicoCodigo = estadoFisicoCodigo;
	}

	public String getEstadoFisicoDescripcion() {
		return estadoFisicoDescripcion;
	}

	public void setEstadoFisicoDescripcion(String estadoFisicoDescripcion) {
		this.estadoFisicoDescripcion = estadoFisicoDescripcion;
	}
	
	public String getNumActivosPreciar() {
		return numActivosPreciar;
	}

	public void setNumActivosPreciar(String numActivosPreciar) {
		this.numActivosPreciar = numActivosPreciar;
	}

	public String getNumActivosRepreciar() {
		return numActivosRepreciar;
	}

	public void setNumActivosRepreciar(String numActivosRepreciar) {
		this.numActivosRepreciar = numActivosRepreciar;
	}

	public String getNumActivosDescuento() {
		return numActivosDescuento;
	}

	public void setNumActivosDescuento(String numActivosDescuento) {
		this.numActivosDescuento = numActivosDescuento;
	}

}
