package es.pfsgroup.plugin.recovery.procuradores.categorias.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class RelacionCategoriasDto extends PaginationParamsImpl{



	private static final long serialVersionUID = -5684897392615688483L;
	
	public static final String TIPO_RELACION_TAREASPROC = "1";
	public static final String TIPO_RELACION_TIPORESOL = "2";
	
	
	private Long idrelacion;
	private String tipoRelacion;
	private Long idcategoria;
	private Long idtramite;
	private Long idcategorizacion;
	private Long idtap;
	private Long idtiporesolucion;
	
	public Long getIdrelacion() {
		return idrelacion;
	}

	public void setIdrelacion(Long idrelacion) {
		this.idrelacion = idrelacion;
	}

	public String getTipoRelacion() {
		return tipoRelacion;
	}

	public void setTipoRelacion(String tipoRelacion) {
		this.tipoRelacion = tipoRelacion;
	}
	
	public Long getIdcategoria() {
		return idcategoria;
	}

	public void setIdcategoria(Long idcategoria) {
		this.idcategoria = idcategoria;
	}
	
	public Long getIdtramite() {
		return idtramite;
	}

	public void setIdtramite(Long idtramite) {
		this.idtramite = idtramite;
	}

	public Long getIdcategorizacion() {
		return idcategorizacion;
	}

	public void setIdcategorizacion(Long idcategorizacion) {
		this.idcategorizacion = idcategorizacion;
	}

	public Long getIdtap() {
		return idtap;
	}

	public void setIdtap(Long idtap) {
		this.idtap = idtap;
	}

	public Long getIdtiporesolucion() {
		return idtiporesolucion;
	}

	public void setIdtiporesolucion(Long idtiporesolucion) {
		this.idtiporesolucion = idtiporesolucion;
	}

}
