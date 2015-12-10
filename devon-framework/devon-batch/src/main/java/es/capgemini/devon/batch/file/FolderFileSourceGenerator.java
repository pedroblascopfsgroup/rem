package es.capgemini.devon.batch.file;

import java.io.File;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.file.FileReadingMessageSource;
import org.springframework.integration.file.transformer.FileToByteArrayTransformer;
import org.springframework.integration.file.transformer.FileToStringTransformer;
import org.springframework.integration.transformer.MessageTransformingHandler;
import org.springframework.integration.transformer.Transformer;
import org.springframework.util.Assert;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.startup.Initializable;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.IntegrationUtils;
import es.capgemini.devon.utils.QueueUtils;

/**
 * Clase para "escuchar" en todas las carpetas configuradas.
 * 
 * @author Nicolás Cornaglia
 */
public class FolderFileSourceGenerator implements Initializable {

    private final Log logger = LogFactory.getLog(getClass());

    public static String SEPARATOR = "/"; // Unix based

    private static final String FILE_SOURCE_TYPE_ATTRIBUTE = "file";
    private static final String TEXT_SOURCE_TYPE_ATTRIBUTE = "text";
    private static final String BINARY_SOURCE_TYPE_ATTRIBUTE = "binary";

    @Autowired
    private ApplicationContext applicationContext;
    //    @Autowired
    //    protected MessageBus messageBus;
    @Autowired
    protected EventManager eventManager;
    @Resource
    protected Properties appProperties;

    protected File baseDirectoryToGenerate;
    protected String patternToGenerate = ".*";
    protected String inDir = "";
    protected String backupSubDir = "backup";

    protected String filePattern;
    protected String channel;
    protected int period;
    protected String type = TEXT_SOURCE_TYPE_ATTRIBUTE;
    protected String workingCodePlaceholder;

    protected String fileHandlerBeanName;
    protected String fileHandlerMethodName;

    protected boolean entityConcurrent = false;

    private int order = Integer.MAX_VALUE - 1000;

    /**
     * @see es.capgemini.devon.startup.Initializable#initialize()
     */
    public void initialize() {
        Assert.notNull(baseDirectoryToGenerate, "'baseDirectoryToGenerate' must not be null");

        Map<String, String> inDirs = FileUtils.generateDirectories(baseDirectoryToGenerate, patternToGenerate, inDir, backupSubDir);
        for (String code : inDirs.keySet()) {
            final String pattern = filePattern.replace(workingCodePlaceholder, code);
            logger.info("Creating fileSourceAdapter [" + inDirs.get(code) + File.separator + pattern + "] for use by [" + channel + "] every ["
                    + period + "ms.]");

            // Build FileReadingMessageSource
            FileReadingMessageSource source = IntegrationUtils.buildFileReadingMessageSource(inDirs.get(code), pattern, true);

            // Get the correct Message Channel (one per folder if concurrent, one global otherwise)
            MessageChannel messageChannel = getChannel(code);

            // Build SourcePollingChannelAdapter
            IntegrationUtils.buildSourcePollingChannelAdapter(source, messageChannel, period, true);

            // Subscribe the bean to the channel if configured one channel per folder
            if (isEntityConcurrent()) {
                registerSubscription(injectTransformer(messageChannel));
            }

        }

        // Subscribe the bean to the channel if configured for a global channel
        if (!isEntityConcurrent()) {
            MessageChannel messageChannel = injectTransformer(getChannel(null));
            registerSubscription(messageChannel);
        }
    }

    protected void registerSubscription(MessageChannel messageChannel) {
        Object bean = applicationContext.getBean(fileHandlerBeanName);
        eventManager.subscribe(messageChannel.getName(), bean, fileHandlerMethodName);
    }

    /**
     * Devuelve el MessageChannel donde lanzar los eventos
     * 
     * @return
     */
    protected MessageChannel getChannel(String code) {
        if (isEntityConcurrent()) {
            return eventManager.createPublishSubscribeChannel(QueueUtils.getQueueNameForEntity(channel, code));
        } else {
            return eventManager.createPublishSubscribeChannel(channel);
        }
    }

    /**
     * @param messageChannel
     * @return
     */
    protected MessageChannel injectTransformer(MessageChannel originalMessageChannel) {
        Transformer transformer = null;
        if (type.equals(TEXT_SOURCE_TYPE_ATTRIBUTE)) {
            transformer = new FileToStringTransformer();
        } else if (type.equals(BINARY_SOURCE_TYPE_ATTRIBUTE)) {
            transformer = new FileToByteArrayTransformer();
        }
        MessageChannel newMessageChannel = originalMessageChannel;
        if (transformer != null) {
            MessageTransformingHandler mtHandler = new MessageTransformingHandler(transformer);
            newMessageChannel = eventManager.createPublishSubscribeChannel(originalMessageChannel.getName() + "-transformed");
            mtHandler.setOutputChannel(newMessageChannel);
            IntegrationUtils.buildConsumerEndpointFactoryBean(originalMessageChannel, mtHandler, true, applicationContext
                    .getAutowireCapableBeanFactory());
        }

        return newMessageChannel;
    }

    /**
     * @see es.capgemini.devon.startup.Initializable#getOrder()
     */
    @Override
    public int getOrder() {
        return order;
    }

    public void setBaseDirectoryToGenerate(File directory) {
        this.baseDirectoryToGenerate = directory;
    }

    public void setPatternToGenerate(String pattern) {
        this.patternToGenerate = pattern;
    }

    public void setInDir(String suffix) {
        this.inDir = suffix;
    }

    public void setFilePattern(String filePattern) {
        this.filePattern = filePattern;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public void setPeriod(int period) {
        this.period = period;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setAppProperties(Properties appProperties) {
        this.appProperties = appProperties;
    }

    public void setBackupSubDir(String backupSubDir) {
        this.backupSubDir = backupSubDir;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public void setWorkingCodePlaceholder(String workingCodePlaceholder) {
        this.workingCodePlaceholder = workingCodePlaceholder;
    }

    public boolean isEntityConcurrent() {
        return entityConcurrent;
    }

    public void setEntityConcurrent(boolean entityConcurrent) {
        this.entityConcurrent = entityConcurrent;
    }

    public void setFileHandlerBeanName(String fileHandlerBeanName) {
        this.fileHandlerBeanName = fileHandlerBeanName;
    }

    public void setFileHandlerMethodName(String fileHandlerMethodName) {
        this.fileHandlerMethodName = fileHandlerMethodName;
    }

    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "FolderFileSourceGenerator: [" + "order:" + getOrder() + ", entityConcurrent:" + entityConcurrent + ", baseDirectoryToGenerate:"
                + baseDirectoryToGenerate + ",patternToGenerate:" + patternToGenerate + ",inDir:" + inDir + ",backupSubDir:" + backupSubDir
                + ",filePattern:" + filePattern + ",channel:" + channel + ",period:" + period + ",type:" + type + ",workingCodePlaceholder:"
                + workingCodePlaceholder + ",fileHandlerBeanName:" + fileHandlerBeanName + ",fileHandlerMethodName:" + fileHandlerMethodName + "]";
    }

}
