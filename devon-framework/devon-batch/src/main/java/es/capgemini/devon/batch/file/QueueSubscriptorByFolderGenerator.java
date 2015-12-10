package es.capgemini.devon.batch.file;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.util.Assert;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.startup.Initializable;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.devon.utils.QueueUtils;

/**
 * Clase para "escuchar" en todas las carpetas configuradas.
 * 
 * @author Nicolás Cornaglia
 */
public class QueueSubscriptorByFolderGenerator implements Initializable {

    @Autowired
    protected ApplicationContext applicationContext;
    @Autowired
    protected EventManager eventManager;

    protected File baseDirectory;
    protected String patternToGenerate = ".*";
    protected String channel;
    protected String beanName;
    protected String methodName;

    private int order = Integer.MAX_VALUE;

    /**
     * @see es.capgemini.devon.startup.Initializable#initialize()
     */
    public void initialize() {
        Assert.notNull(baseDirectory, "'baseDirectory' must not be null");

        List<String> dirs = FileUtils.getDirectoryNames(baseDirectory, patternToGenerate);
        for (String code : dirs) {
            Object bean = applicationContext.getBean(beanName);

            String channelName = QueueUtils.getQueueNameForEntity(channel, code);
            eventManager.createPublishSubscribeChannel(channelName);
            eventManager.subscribe(channelName, bean, methodName);

        }
    }

    /**
     * @see es.capgemini.devon.startup.Initializable#getOrder()
     */
    @Override
    public int getOrder() {
        return order;
    }

    /**
     * @param channel the channel to set
     */
    public void setChannel(String channel) {
        this.channel = channel;
    }

    /**
     * @param beanName the beanName to set
     */
    public void setBeanName(String beanName) {
        this.beanName = beanName;
    }

    /**
     * @param methodName the methodName to set
     */
    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    /**
     * @param baseDirectory the baseDirectory to set
     */
    public void setBaseDirectoryToGenerate(File baseDirectoryToGenerate) {
        this.baseDirectory = baseDirectoryToGenerate;
    }

    /**
     * @param patternToGenerate the patternToGenerate to set
     */
    public void setPatternToGenerate(String patternToGenerate) {
        this.patternToGenerate = patternToGenerate;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "QueueSubscriptorByFolderGenerator: [" + "order:" + getOrder() + " baseDirectory:" + baseDirectory.getAbsolutePath() + " patternToGenerate:" + patternToGenerate
                + " channel:" + channel + " beanName:" + beanName + " methodName:" + methodName + "]";
    }

}
