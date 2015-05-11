package es.capgemini.pfs.utils.hibernate.page;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.orm.hibernate3.HibernateTemplate;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;

@Service(overrides = "paginationManager")
public class PaginationOptimizedManager extends PaginationManager {

	@Resource
	private Properties appProperties;

	public Page getHibernatePage(HibernateTemplate template,
			String queryString, PaginationParams paginationParams,
			HashMap params) {

		if (paginationParams.getLimit() == Page.LIMIT_NOT_DEFINED) {
			paginationParams.setLimit(Integer.parseInt(appProperties
					.getProperty("pagination.limit")));
		}

		final es.capgemini.devon.hibernate.pagination.PageHibernate page = damePaginador(
				queryString, paginationParams, params);

		template.executeFind(page);
		return page;
	}

	public Page getHibernatePage(HibernateTemplate template,
			String queryString, PaginationParams paginationParams) {

		if (paginationParams.getLimit() == Page.LIMIT_NOT_DEFINED) {
			paginationParams.setLimit(Integer.parseInt(appProperties
					.getProperty("pagination.limit")));
		}
		final es.capgemini.devon.hibernate.pagination.PageHibernate page = damePaginador(
				queryString, paginationParams, null);

		template.executeFind(page);
		return page;
	}

	/**
	 * Este métod devuelve un paginador dependiendo de la estrategia marcada en
	 * DEVON. Esto se hace sólo con el propósito de probar cómo funcionan mejor
	 * las búsquedas
	 * 
	 * @param queryString
	 * @param paginationParams
	 * @param params
	 * @return
	 */
	private es.capgemini.devon.hibernate.pagination.PageHibernate damePaginador(
			String queryString, PaginationParams paginationParams,
			HashMap params) {

		// Recuperamos la opción de paginación de devon.properties
		final String testPagOpt = appProperties
				.getProperty("test.pagination.mode");

		int pagiOption = 0;

		if (testPagOpt != null) {
			try {
				pagiOption = Integer.parseInt(testPagOpt.trim());
			} catch (NumberFormatException nfe) {
				// simplemente ignoramos
			}
		}

		// Elegimos el tipo de paginación dependiendo de lo que pongamos en
		// devon.properties.
		// 1. PageHibernate normal (default).
		// 2. PageHibernate original de Devon
		// 3. PageHibernate mejorada (bruno)
		switch (pagiOption) {
		case 1:
			// Este es el modo de paginación que se viene usando
			return new PageHibernate(queryString, paginationParams, params);
		case 2:
			// Paginador por defecto de Devon
			return new es.capgemini.devon.hibernate.pagination.PageHibernate(
					queryString, paginationParams, params);
		case 3:
			// Paginador tuneado
			return new PageHibernateOptimizada(queryString, paginationParams,
					params);
		default:
			return new PageHibernate(queryString, paginationParams, params);
		}
	}
}
