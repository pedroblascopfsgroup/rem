package es.capgemini.devon.hibernate.session;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;

import javax.persistence.Entity;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.ClassPathScanningCandidateComponentProvider;
import org.springframework.core.type.filter.AnnotationTypeFilter;
import org.springframework.orm.hibernate3.annotation.AnnotationSessionFactoryBean;
import org.springframework.util.ClassUtils;

public class ExtendedAnnotationSessionFactoryBean extends AnnotationSessionFactoryBean {

    private final Log logger = LogFactory.getLog(getClass());

    @SuppressWarnings("unchecked")
    private Class[] annotatedClasses;
    private String[] annotatedPackageClasses;

    private ClassLoader beanClassLoader;

    @SuppressWarnings("unchecked")
    @Override
    public void setAnnotatedClasses(Class[] annotatedClasses) {
        this.annotatedClasses = annotatedClasses;
    }

    public void setAnnotatedPackageClasses(String[] annotatedPackageClasses) {
        this.annotatedPackageClasses = annotatedPackageClasses;
    }

    @Override
    public void setBeanClassLoader(ClassLoader beanClassLoader) {
        this.beanClassLoader = beanClassLoader;
    }

    @SuppressWarnings("unchecked")
    @Override
    public void afterPropertiesSet() throws Exception {
        Collection<Class<?>> entities = new ArrayList<Class<?>>();
        ClassPathScanningCandidateComponentProvider scanner = this.createScanner();
        for (String basePackage : this.annotatedPackageClasses) {
            this.findEntities(scanner, entities, basePackage);
        }
        for (Class annotatedClass : annotatedClasses) {
            if (!entities.contains(annotatedClass)) {
                entities.add(annotatedClass);
            }
        }
        super.setAnnotatedClasses(entities.toArray(new Class<?>[entities.size()]));
        super.afterPropertiesSet();

        //DatabaseUtils.setHibernateDialect(getHibernateProperties().getProperty(Environment.DIALECT));
    }

    private ClassPathScanningCandidateComponentProvider createScanner() {
        ClassPathScanningCandidateComponentProvider scanner = new ClassPathScanningCandidateComponentProvider(false);
        scanner.addIncludeFilter(new AnnotationTypeFilter(Entity.class));
        return scanner;
    }

    private void findEntities(ClassPathScanningCandidateComponentProvider scanner, Collection<Class<?>> entities, String basePackage) {
        Set<BeanDefinition> annotatedClasses = scanner.findCandidateComponents(basePackage);
        for (BeanDefinition bd : annotatedClasses) {
            String className = bd.getBeanClassName();
            Class<?> type = ClassUtils.resolveClassName(className, this.beanClassLoader);
            entities.add(type);
            if (logger.isDebugEnabled()) {
                logger.debug("Added entity [" + type.getName() + "]");
            }
        }
    }
}