package es.pfsgroup.recovery.ext.factory.dao;

import es.pfsgroup.commons.utils.HQLBuilder;

/**
 * HQLBulider reutilizable.
 * 
 * Este objeto contiene
 * <ul>
 * <li>Un {@link HQLBuilder} usado por algún método de búsqueda de un DAO</li>
 * <li>Un {@link HQLQueryCallback} que debe usarse para realizar la query usando ese HQLBuilder.</li>
 * </ul>
 * 
 * @author bruno
 *
 */
public class HQLBuilderReutilizable {
	
	public HQLBuilder getHqlBuilder() {
		return hqlBuilder;
	}

	public HQLQueryCallback getQueryCallback() {
		return queryCallback;
	}

	public HQLBuilderReutilizable(HQLBuilder hqlBuilder,
			HQLQueryCallback queryCallback) {
		super();
		this.hqlBuilder = hqlBuilder;
		this.queryCallback = queryCallback;
	}

	private HQLBuilder hqlBuilder;
	
	private HQLQueryCallback queryCallback;
	

}
