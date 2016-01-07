package es.pfsgroup.commons.utils.hibernate;

import javax.annotation.Resource;

import org.hibernate.SessionFactory;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;

@Component
public class HibernateUtils extends HibernateDaoSupport //implements ApplicationContextAware
{

	
	//private ApplicationContext ctx;

	
	public static <T> T merge(T o){
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean("hibernateUtils");
		return u.mergeObject(o);
	}
		
	 /**
     * @param entitySessionFactory SessionFactory
     */
    @Resource
    public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
        super.setSessionFactory(entitySessionFactory);
    }
	
	@SuppressWarnings("unchecked")
    public <T> T mergeObject(T o){
		return (T) getSession().merge(o);
	}

	public static void flush() {
		HibernateUtils u = (HibernateUtils) ApplicationContextUtil.getBean("hibernateUtils");
		u.flushSession();
	}

	public void flushSession() {
		getSession().flush();
	}
	
//	@Override
//	public void setApplicationContext(ApplicationContext applicationContext)
//			throws BeansException {
//		ctx = applicationContext;
//		
//	}
	
	
}
