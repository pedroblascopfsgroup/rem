package es.capgemini.devon.batch.tasks.utils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Required;

import es.capgemini.devon.batch.BatchException;
import es.capgemini.devon.batch.tasks.BatchValidationException;
import es.capgemini.devon.events.ErrorEvent;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.utils.DbIdContextHolder;

/**
 * TODO DOCUMENTAR!!!!!
 */
public class EventBatchUtil {

   private static EventBatchUtil eventBatchUtil = null;

   private EventBatchUtil() {

   }

   public static EventBatchUtil getInstance() {
      if (eventBatchUtil == null) {
         eventBatchUtil = new EventBatchUtil();
      }
      return eventBatchUtil;
   }

   @Autowired
   private EventManager eventManager;

   public void throwEventErrorChannel(String message, String severidad, boolean imprimeTraza) {
      ErrorEvent ev = new ErrorEvent(new BatchValidationException(message, severidad, imprimeTraza));
      ev.setProperty("dbId", DbIdContextHolder.getDbId());
      getInstance().getEventManager().fireEvent(BatchException.ERROR_CHANNEL, ev);
      if (log.isErrorEnabled()) {
         log.error(message);
      }
   }

   public void throwEventErrorChannel(String message, String severidad, boolean imprimeTraza, Object... messageArgs) {
      ErrorEvent ev = new ErrorEvent(new BatchValidationException(message, severidad, imprimeTraza, messageArgs));
      ev.setProperty("dbId", DbIdContextHolder.getDbId());
      getInstance().getEventManager().fireEvent(BatchException.ERROR_CHANNEL, ev);
      if (log.isErrorEnabled()) {
         log.error(message);
      }
   }

   public void throwEventErrorChannel(String message, String severidad) {
      ErrorEvent ev = new ErrorEvent(new BatchValidationException(message, severidad));
      ev.setProperty("dbId", DbIdContextHolder.getDbId());
      getInstance().getEventManager().fireEvent(BatchException.ERROR_CHANNEL, ev);
      if (log.isErrorEnabled())
         log.error(message);
   }

   public void throwEventErrorChannel(Throwable e, String severidad, String message) {
      ErrorEvent ev = new ErrorEvent(new BatchValidationException(e, severidad, message));
      ev.setProperty("dbId", DbIdContextHolder.getDbId());
      getInstance().getEventManager().fireEvent(BatchException.ERROR_CHANNEL, ev);
      if (log.isErrorEnabled()) {
         log.error(message, e);
      }
   }

   public EventManager getEventManager() {
      return getInstance().eventManager;
   }

   @Required
   public void setEventManager(EventManager eventManager) {
      getInstance().eventManager = eventManager;
   }

   private static Log log = LogFactory.getLog(EventBatchUtil.class);
}
