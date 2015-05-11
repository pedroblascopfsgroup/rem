package es.pfsgroup.commons.utils.dao.abm.impl;

import java.io.Serializable;
import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.orm.hibernate3.HibernateAccessor;

import es.capgemini.devon.hibernate.dao.AbstractHibernateDao;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;

public class GenericABMDaoImpl implements GenericABMDao {

	/*
	 * Filter Impl
	 */
	public static class FilterImpl implements GenericABMDao.Filter {
		private FilterType type;
		private String propertyName;
		private Object propertyValue;

		public FilterImpl(FilterType type, String name, Object value) {
			this.type = type;
			this.propertyName = name;
			this.propertyValue = value;
		}

		@Override
		public FilterType getType() {
			return this.type;
		}

		@Override
		public String getPropertyName() {
			return propertyName;
		}

		@Override
		public Object getPropertyValue() {
			return propertyValue;
		}

	}

	/*
	 * OverriddedAbstractEntityDao
	 */
	private abstract static class OverriddedAbstractEntityDao<T extends Serializable>
			extends AbstractHibernateDao<T, Long> {
		// private Class<T> domainClass;

		public OverriddedAbstractEntityDao(Class<T> dc, SessionFactory sf) {
			domainClass = dc;
			setSessionFactory(sf);
		}

		@Override
		protected Class<T> getDomainClass() {
			return domainClass;
		}
	}

	/*
	 * ExtendedDao
	 */
	private static class ExtendedDao<T extends Serializable> extends
			OverriddedAbstractEntityDao<T> implements RWOperations<T> {

		public ExtendedDao(Class<T> domainClass, SessionFactory sf) {
			super(domainClass, sf);
		}

		public List<T> getList(HQLBuilder hqlBuilder) {
			return HibernateQueryUtils.list(this, hqlBuilder);
		}
		
		public Page getPage(HQLBuilder hqlBuilder, PaginationParams dto) {
			return HibernateQueryUtils.page(this, hqlBuilder, dto);
		}

		public T get(HQLBuilder hqlbuilder) {
			return HibernateQueryUtils.uniqueResult(this, hqlbuilder);
		}

	}

	private SessionFactory sessionFactory;

	public void setSessionFactory(SessionFactory sf) {
		this.sessionFactory = sf;
	}

	@Override
	public Filter createFilter(FilterType type, String propertyName,
			Object propertyValue) {
		return new FilterImpl(type, propertyName, propertyValue);
	}

	public <T extends Serializable> List<T> getList(Class<T> clazz) {
		return this.getListOrdered(clazz, noOrder(), noFilters());
	}

	@Override
	public <T extends Serializable> List<T> getListOrdered(Class<T> clazz,
			Order order) {
		return this.getListOrdered(clazz, order, noFilters());
	}
	
	@Override
	public <T extends Serializable> Page getPage(Class<T> clazz,PaginationParams dto) {
		return this.getPage(clazz,dto, noFilters());
	}

	@Override
	public <T extends Serializable> List<T> getList(Class<T> clazz,
			Filter... filters) {
		return this.getListOrdered(clazz, noOrder(), filters);

	}

	@Override
	public <T extends Serializable> List<T> getListOrdered(Class<T> clazz,
			Order order, Filter ...filters ) {
		ExtendedDao<T> dao = createExtendedDao(clazz);
		HQLBuilder b = new HQLBuilder("from " + clazz.getSimpleName());
		setupFilters(b, filters);
		setupOrder(b,order);
		return dao.getList(b);
	}
	
	@Override
	public <T extends Serializable> Page getPage(Class<T> clazz, PaginationParams dto,
			Filter... filters) {
		ExtendedDao<T> dao = createExtendedDao(clazz);
		HQLBuilder b = new HQLBuilder("from " + clazz.getSimpleName());
		setupFilters(b, filters);
		return dao.getPage(b,dto);

	}

	@Override
	public <T extends Serializable> T get(Class<T> clazz, Filter... filters) {
		ExtendedDao<T> dao = createExtendedDao(clazz);
		HQLBuilder b = new HQLBuilder("from " + clazz.getSimpleName());
		setupFilters(b, filters);
		return dao.get(b);
	}

	@Override
	public <T extends Serializable> T save(Class<T> clazz, T object) {
		ExtendedDao<T> dao = (ExtendedDao<T>) createExtendedDao(clazz);
		Long id = dao.save(object);
		return dao.get(id);
	}

	@Override
	public <T extends Serializable> void update(Class<T> clazz, T object) {
		ExtendedDao<T> dao = (ExtendedDao<T>) createExtendedDao(clazz);
		dao.update(object);
	}

	@Override
	public <T extends Serializable> void deleteById(Class<T> clazz, Long id) {
		ExtendedDao<T> dao = (ExtendedDao<T>) createExtendedDao(clazz);
		dao.deleteById(id);
	}

	@Override
	public <T extends Serializable> RWOperations<T> readWrite(Class<T> clazz) {
		ExtendedDao<T> dao = (ExtendedDao<T>) createExtendedDao(clazz);
		dao.getHibernateTemplate().setFlushMode(HibernateAccessor.FLUSH_AUTO);
		return dao;

	}

	private void check() {
		if (sessionFactory == null) {
			throw new IllegalStateException(
					"sesssionFactory: NO PUEDE SER NULL");
		}
	}
	
	
	private Filter[] noFilters(){
		return new Filter[]{};
	}
	
	private Order noOrder(){
		return null;
	}

	private void setupFilters(HQLBuilder b, Filter... filters) {
		if (filters != null) {
			for (Filter f : filters) {
				switch (f.getType()) {
				case EQUALS:
					HQLBuilder.addFiltroIgualQue(b, f.getPropertyName(), f
							.getPropertyValue());
					break;
				}
			}
		}
	}

	private void setupOrder(HQLBuilder b, Order order) {
		if (order != null) {
			String sentido = (OrderType.ASC.equals(order.getType()) ? HQLBuilder.ORDER_ASC
					: HQLBuilder.ORDER_DESC);
			b.orderBy(order.getPropertyName(), sentido);
		}
	}

	private <T extends Serializable> ExtendedDao<T> createExtendedDao(
			Class<T> clazz) {
		check();
		ExtendedDao<T> dao = new ExtendedDao<T>(clazz, this.sessionFactory) {
		};
		return dao;
	}

}
