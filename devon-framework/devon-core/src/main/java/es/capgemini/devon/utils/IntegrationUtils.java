package es.capgemini.devon.utils;

import java.util.regex.Pattern;

import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.support.AbstractRefreshableConfigApplicationContext;
import org.springframework.integration.config.SourcePollingChannelAdapterFactoryBean;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.endpoint.AbstractEndpoint;
import org.springframework.integration.endpoint.SourcePollingChannelAdapter;
import org.springframework.integration.file.AcceptOnceFileListFilter;
import org.springframework.integration.file.CompositeFileListFilter;
import org.springframework.integration.file.FileListFilter;
import org.springframework.integration.file.FileReadingMessageSource;
import org.springframework.integration.file.PatternMatchingFileListFilter;
import org.springframework.integration.file.config.FileReadingMessageSourceFactoryBean;
import org.springframework.integration.message.MessageHandler;
import org.springframework.integration.message.MessageSource;
import org.springframework.integration.scheduling.IntervalTrigger;
import org.springframework.integration.scheduling.PollerMetadata;

import es.capgemini.devon.events.ConsumerEndpointFactoryBean;
import es.capgemini.devon.exception.FrameworkException;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public class IntegrationUtils {

    /**
     * @param directory
     * @param pattern
     * @param autoCreateDirectory
     * @return
     */
    public static FileReadingMessageSource buildFileReadingMessageSource(String directory, String pattern, boolean autoCreateDirectory) {
        FileReadingMessageSourceFactoryBean msFactory = new FileReadingMessageSourceFactoryBean();
        msFactory.setAutoCreateDirectory(autoCreateDirectory);
        msFactory.setDirectory("file:" + directory);
        msFactory.setResourceLoader(ApplicationContextUtil.getApplicationContext());

        FileListFilter aoflf = new AcceptOnceFileListFilter();
        FileListFilter pmflf = new PatternMatchingFileListFilter(Pattern.compile(pattern));
        CompositeFileListFilter filter = new CompositeFileListFilter(aoflf, pmflf);
        msFactory.setFilter(filter);

        FileReadingMessageSource source;
        try {
            source = (FileReadingMessageSource) msFactory.getObject();
        } catch (Exception e) {
            throw new FrameworkException(e);
        }

        return source;
    }

    /**
     * @param source
     * @param outputChannel
     * @param interval
     * @return
     */
    public static SourcePollingChannelAdapter buildSourcePollingChannelAdapter(MessageSource<?> source, MessageChannel outputChannel, long interval,
            boolean autoStartup) {
        PollerMetadata poller = new PollerMetadata();
        poller.setTrigger(new IntervalTrigger(interval));

        SourcePollingChannelAdapterFactoryBean spFactory = new SourcePollingChannelAdapterFactoryBean();
        spFactory.setSource(source);
        spFactory.setOutputChannel(outputChannel);
        spFactory.setPollerMetadata(poller);
        spFactory.setAutoStartup(autoStartup);
        spFactory.setBeanFactory(((AbstractRefreshableConfigApplicationContext)ApplicationContextUtil.getApplicationContext()).getBeanFactory());
        spFactory.setBeanClassLoader(ApplicationContextUtil.getApplicationContext().getClassLoader());

        SourcePollingChannelAdapter adapter;
        try {
            adapter = (SourcePollingChannelAdapter) spFactory.getObject();
        } catch (Exception e) {
            throw new FrameworkException(e);
        }

        return adapter;
    }

    /**
     * @param inputChannelName
     * @param handler
     * @param autoStartup
     * @return
     */
    public static AbstractEndpoint buildConsumerEndpointFactoryBean(MessageChannel inputChannel, MessageHandler handler, boolean autoStartup,
            BeanFactory beanFactory) {
        ConsumerEndpointFactoryBean epFactory = (ConsumerEndpointFactoryBean) beanFactory.getBean("&integration.consumerEndpointFactoryBean");
        epFactory.setAutoStartup(true);
        epFactory.setHandler(handler);
        epFactory.setChannel(inputChannel);
        AbstractEndpoint endPoint;
        try {
            endPoint = (AbstractEndpoint) epFactory.getObject();
        } catch (Exception e) {
            throw new FrameworkException(e);
        }
        return endPoint;
    }
}
