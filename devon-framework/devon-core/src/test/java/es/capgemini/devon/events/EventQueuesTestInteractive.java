//package es.capgemini.devon.events;
//
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.io.Serializable;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import javax.annotation.Resource;
//
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
//import org.junit.Test;
//import org.springframework.integration.annotation.ServiceActivator;
//import org.springframework.integration.core.Message;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
//
///**
// * FIXME Estos tests no pasan
// * 
// * @author Nicol�s Cornaglia
// */
//// ApplicationContext will be loaded from "classpath:/es/capgemini/devon/events/EventQueuesTestInteractive-context.xml"
//@ContextConfiguration
//public class EventQueuesTestInteractive extends AbstractJUnit4SpringContextTests { // use AbstractTransactionalJUnit4SpringContextTests 4 txs
//
//    private final Log logger = LogFactory.getLog(getClass());
//
//    private static String USER1_CHANNEL = "admin";
//    private static String USER2_CHANNEL = "user11";
//    private static String USER3_CHANNEL = "user12";
//
//    @Resource
//    private EventManager eventManager;
//
//    private boolean goOn = false;
//
//    
//    @Test
//    public void testName() throws Exception {
//        Thread t = new Thread() {
//
//            @Override
//            public void run() {
//                Map<String, Serializable> globalProperties = new HashMap<String, Serializable>() {
//
//                    {
//                        put(Event.SCOPE_KEY, EventScope.GLOBAL);
//                    }
//                };
//                BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
//                String s = null;
//                try {
//                    System.out.println("g-> Sends a GLOBAL message");
//                    System.out.println("rN-> Receives a message in N queue (1 to 3)");
//                    System.out.println("q-> Quits");
//                    while ((s = in.readLine()) != null && s.length() != 0 & !goOn) {
//                        if ("g".equalsIgnoreCase(s)) {
//                            eventManager.fireEvent(WebEventsSubscriptor.USER_CHANNEL, "test", globalProperties);
//                        } else if ("q".equalsIgnoreCase(s)) {
//                            goOn = true;
//                        } else if ("r1".equalsIgnoreCase(s)) {
//                            receive(USER1_CHANNEL);
//                        } else if ("r2".equalsIgnoreCase(s)) {
//                            receive(USER2_CHANNEL);
//                        } else if ("r3".equalsIgnoreCase(s)) {
//                            receive(USER3_CHANNEL);
//                        }
//                    }
//                } catch (IOException e) {
//                }
//            }
//        };
//
//        t.run();
//
//    }
//
//    @ServiceActivator(inputChannel = "userChannel0")
//    public void log0(Message<?> message) {
//        logger.debug("received userChannel0: " + message.getHeaders().getTimestamp() + ": " + message.getPayload());
//    }
//
//    /**
//     * @param channelName
//     */
//    private void receive(String channelName) {
//        List<Event> events = eventManager.receive(channelName);
//        for (Event event : events) {
//            logger.debug("Test: received message [" + event + "] on queue [" + channelName + "]");
//        }
//    }
//
//}
