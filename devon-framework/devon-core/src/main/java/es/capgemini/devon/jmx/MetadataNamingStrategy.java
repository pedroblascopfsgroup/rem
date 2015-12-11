package es.capgemini.devon.jmx;

import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;

import org.springframework.aop.support.AopUtils;
import org.springframework.jmx.export.metadata.JmxAttributeSource;
import org.springframework.jmx.export.metadata.ManagedResource;
import org.springframework.jmx.support.ObjectNameManager;
import org.springframework.util.StringUtils;

/**
 * @author Nicolás Cornaglia
 */
public class MetadataNamingStrategy extends org.springframework.jmx.export.naming.MetadataNamingStrategy {

    private JmxAttributeSource attributeSource;
    private String defaultDomain;

    public MetadataNamingStrategy(JmxAttributeSource attributeSource) {
        super(attributeSource);
        this.attributeSource = attributeSource;
    }

    @Override
    public ObjectName getObjectName(Object managedBean, String beanKey) throws MalformedObjectNameException {
        Class managedClass = AopUtils.getTargetClass(managedBean);
        ManagedResource mr = this.attributeSource.getManagedResource(managedClass);
        if (mr != null && StringUtils.hasText(mr.getObjectName()) && mr.getObjectName().indexOf(":") < 1) {
            return ObjectNameManager.getInstance(defaultDomain + (mr.getObjectName().indexOf(":") < 0 ? ":" : "") + mr.getObjectName());
        }
        return super.getObjectName(managedBean, beanKey);
    }

    @Override
    public void setDefaultDomain(String defaultDomain) {
        super.setDefaultDomain(defaultDomain);
        this.defaultDomain = defaultDomain;
    }
}
