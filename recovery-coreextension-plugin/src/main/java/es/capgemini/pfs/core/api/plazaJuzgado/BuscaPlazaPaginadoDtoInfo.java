package es.capgemini.pfs.core.api.plazaJuzgado;

import es.capgemini.devon.pagination.PaginationParams;

public interface BuscaPlazaPaginadoDtoInfo extends PaginationParams{
	
	public static final String START = "start";
	public static final String LIMIT = "limit";
	public static final String QUERY = "query";

	/**
	 * cadena de caracteres que se introduce en el combo
	 * @return
	 */
	String getQuery();

}
