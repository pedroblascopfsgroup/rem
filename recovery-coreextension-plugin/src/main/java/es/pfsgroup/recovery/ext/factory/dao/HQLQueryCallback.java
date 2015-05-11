package es.pfsgroup.recovery.ext.factory.dao;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.HQLBuilder;

/**
 * Retrollamada para realizar una query a partir de un determinado HQLBuilder
 * @author bruno
 *
 */
public interface HQLQueryCallback {
	
	public enum TipoResultado {
		/**
		 * Devuelve un objeto PAGE
		 */
		PAGE;
	}
	
	/**
	 * Método que nos dice qué tipo de resultado nos va a devolver la retrollamada
	 * <ul>
	 * <li>PAGE una lista paginada</li>
	 * </ul>
	 * @return
	 */
	TipoResultado getCallbackType();
	
	/**
	 * 
	 * @param dao
	 * @param hqlbuilder
	 * @param dto
	 * @return
	 */
	Page getPage(AbstractHibernateDao dao, HQLBuilder hqlbuilder, WebDto dto);
}
