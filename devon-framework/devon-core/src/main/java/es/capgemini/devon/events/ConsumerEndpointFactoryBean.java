package es.capgemini.devon.events;

import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.beans.factory.BeanNameAware;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.Lifecycle;
import org.springframework.integration.channel.PollableChannel;
import org.springframework.integration.channel.SubscribableChannel;
import org.springframework.integration.context.IntegrationContextUtils;
import org.springframework.integration.core.MessageChannel;
import org.springframework.integration.endpoint.AbstractEndpoint;
import org.springframework.integration.endpoint.EventDrivenConsumer;
import org.springframework.integration.endpoint.PollingConsumer;
import org.springframework.integration.message.MessageHandler;
import org.springframework.integration.scheduling.PollerMetadata;
import org.springframework.util.Assert;

/**
 * @author Mark Fisher
 */
public class ConsumerEndpointFactoryBean implements FactoryBean, BeanFactoryAware, BeanNameAware, InitializingBean, Lifecycle, ApplicationListener {

    private volatile MessageHandler handler;

    private volatile String beanName;

    private volatile String inputChannelName;
    private volatile MessageChannel channel;

    private volatile PollerMetadata pollerMetadata;

    private volatile boolean autoStartup = true;

    private volatile ConfigurableBeanFactory beanFactory;

    private volatile AbstractEndpoint endpoint;

    private volatile boolean initialized;

    private final Object initializationMonitor = new Object();

    private final Object handlerMonitor = new Object();

    public void setHandler(MessageHandler handler) {
        Assert.notNull(handler, "handler must not be null");
        synchronized (this.handlerMonitor) {
            Assert.isNull(this.handler, "handler cannot be overridden");
            this.handler = handler;
        }
    }

    public void setInputChannelName(String inputChannelName) {
        this.inputChannelName = inputChannelName;
    }

    public void setChannel(MessageChannel channel) {
        this.channel = channel;
    }

    public void setPollerMetadata(PollerMetadata pollerMetadata) {
        this.pollerMetadata = pollerMetadata;
    }

    public void setAutoStartup(boolean autoStartup) {
        this.autoStartup = autoStartup;
    }

    public void setBeanName(String beanName) {
        this.beanName = beanName;
    }

    public void setBeanFactory(BeanFactory beanFactory) {
        Assert.isInstanceOf(ConfigurableBeanFactory.class, beanFactory, "a ConfigurableBeanFactory is required");
        this.beanFactory = (ConfigurableBeanFactory) beanFactory;
    }

    public void afterPropertiesSet() throws Exception {
        //this.initializeEndpoint();
    }

    public boolean isSingleton() {
        return true;
    }

    public Object getObject() throws Exception {
        if (!this.initialized) {
            this.initializeEndpoint();
        }
        return this.endpoint;
    }

    public Class<?> getObjectType() {
        if (this.endpoint == null) {
            return AbstractEndpoint.class;
        }
        return this.endpoint.getClass();
    }

    private void initializeEndpoint() throws Exception {
        synchronized (this.initializationMonitor) {
            if (this.initialized) {
                return;
            }
            //            Assert.hasText(this.inputChannelName, "inputChannelName is required");
            //            Assert.isTrue(this.beanFactory.containsBean(this.inputChannelName), "no such input channel '" + this.inputChannelName
            //                    + "' for endpoint '" + this.beanName + "'");
            //            MessageChannel channel = (MessageChannel) this.beanFactory.getBean(this.inputChannelName, MessageChannel.class);

            if (channel instanceof SubscribableChannel) {
                Assert.isNull(this.pollerMetadata, "A poller should not be specified for endpoint '" + this.beanName + "', since '"
                        + this.inputChannelName + "' is a SubscribableChannel (not pollable).");
                this.endpoint = new EventDrivenConsumer((SubscribableChannel) channel, this.handler);
            } else if (channel instanceof PollableChannel) {
                PollingConsumer pollingConsumer = new PollingConsumer((PollableChannel) channel, this.handler);
                if (this.pollerMetadata == null) {
                    this.pollerMetadata = IntegrationContextUtils.getDefaultPollerMetadata(this.beanFactory);
                    Assert.notNull(this.pollerMetadata, "No poller has been defined for endpoint '" + this.beanName
                            + "', and no default poller is available within the context.");
                }
                pollingConsumer.setTrigger(this.pollerMetadata.getTrigger());
                pollingConsumer.setMaxMessagesPerPoll(this.pollerMetadata.getMaxMessagesPerPoll());
                pollingConsumer.setReceiveTimeout(this.pollerMetadata.getReceiveTimeout());
                pollingConsumer.setTaskExecutor(this.pollerMetadata.getTaskExecutor());
                pollingConsumer.setTransactionManager(this.pollerMetadata.getTransactionManager());
                pollingConsumer.setTransactionDefinition(this.pollerMetadata.getTransactionDefinition());
                pollingConsumer.setAdviceChain(this.pollerMetadata.getAdviceChain());
                this.endpoint = pollingConsumer;
            } else {
                throw new IllegalArgumentException("unsupported channel type: [" + channel.getClass() + "]");
            }
            this.endpoint.setAutoStartup(this.autoStartup);
            this.endpoint.setBeanName(this.beanName);
            this.endpoint.setBeanFactory(this.beanFactory);
            if (this.endpoint instanceof InitializingBean) {
                ((InitializingBean) this.endpoint).afterPropertiesSet();
            }
            this.initialized = true;
        }
    }

    /*
     * Lifecycle implementation
     */

    public boolean isRunning() {
        return (this.endpoint != null ? this.endpoint.isRunning() : false);
    }

    public void start() {
        if (this.endpoint != null) {
            this.endpoint.start();
        }
    }

    public void stop() {
        if (this.endpoint != null) {
            this.endpoint.stop();
        }
    }

    /*
     * ApplicationListener implementation
     */

    public void onApplicationEvent(ApplicationEvent event) {
        if (this.endpoint instanceof ApplicationListener) {
            ((ApplicationListener) this.endpoint).onApplicationEvent(event);
        }
    }
}
