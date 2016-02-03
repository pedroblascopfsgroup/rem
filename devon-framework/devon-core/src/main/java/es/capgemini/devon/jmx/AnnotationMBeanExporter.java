package es.capgemini.devon.jmx;

import org.springframework.jmx.export.annotation.AnnotationJmxAttributeSource;
import org.springframework.jmx.export.assembler.MetadataMBeanInfoAssembler;

/**
 * @author Nicolás Cornaglia
 */
public class AnnotationMBeanExporter extends org.springframework.jmx.export.annotation.AnnotationMBeanExporter {

    private final AnnotationJmxAttributeSource annotationSource = new AnnotationJmxAttributeSource();
    private final MetadataNamingStrategy metadataNamingStrategy = new MetadataNamingStrategy(this.annotationSource);
    private final MetadataMBeanInfoAssembler metadataAssembler = new MetadataMBeanInfoAssembler(this.annotationSource);

    public AnnotationMBeanExporter() {
        setNamingStrategy(this.metadataNamingStrategy);
        setAssembler(this.metadataAssembler);
        setAutodetectMode(AUTODETECT_ALL);
    }

    /**
     * Specify the default domain to be used for generating ObjectNames
     * when no source-level metadata has been specified.
     * <p>The default is to use the domain specified in the bean name
     * (if the bean name follows the JMX ObjectName syntax); else,
     * the package name of the managed bean class.
     * @see MetadataNamingStrategy#setDefaultDomain
     */
    @Override
    public void setDefaultDomain(String defaultDomain) {
        this.metadataNamingStrategy.setDefaultDomain(defaultDomain);
    }
}
