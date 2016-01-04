package es.pfsgroup.plugin.recovery.procuradores.categorias.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;

public class RelacionCategoriaResolucionDto extends PaginationParamsImpl{



	private static final long serialVersionUID = -5684897392615688483L;
	
	
	private Long id;
	private MSVResolucion resolucion;
	private Categoria categoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public MSVResolucion getResolucion() {
		return resolucion;
	}

	public void setResolucion(MSVResolucion resolucion) {
		this.resolucion = resolucion;
	}
	
	public Categoria getCategoria() {
		return categoria;
	}

	public void setCategoria(Categoria categoria) {
		this.categoria = categoria;
	}

}
