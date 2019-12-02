package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;

public interface GestorSustitutoApi {
	/**
	 * Recupera la lista completa de Gestores Sustitutos
	 *
	 */
	Page getPageGestoresSustitutos(DtoGestoresSustitutosFilter dto);

	String createGestorSustituto(DtoGestoresSustitutosFilter dto);

	void deleteGestorSustitutoById(DtoGestoresSustitutosFilter dto);
	
}