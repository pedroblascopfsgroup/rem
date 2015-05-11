package es.pfsgroup.commons.utils.dao.abm;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
/**
 * Ordenación por una propiedad concreta
 * 
 * @author bruno
 * 
 */
public class Order{
	
	private OrderType type;
	private String property;

	public Order(OrderType type, String property) {
		super();
		assert(type != null);
		assert(!Checks.esNulo(property));
		this.type = type;
		this.property = property;
	}

	public String getPropertyName() {
		return property;
	}

	public OrderType getType() {
		return type;
	}

}
