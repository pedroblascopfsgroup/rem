package es.capgemini.devon.exception;

import java.io.PrintWriter;
import java.io.StringWriter;

public class ExceptionUtils {

    /**
     * Devuelve verdadero para las excepciones que tienen como causa
     * una excepción de usuario
     * 
     * @param exception
     * @return
     */
    public static boolean hasUserExceptionCause(Throwable exception) {
        return getUserExceptionCause(exception) != null;
    }

    /** Comprueba si una excepción tiene como causa una excepción del framework
     * @param exception
     * @return
     */
    public static boolean hasFwkExceptionCause(Throwable exception) {
        return getFwkExceptionCause(exception) != null;
    }

    /** Obtiene la causa de tipo frameworkException del stackTrace
     * @param exception
     * @return
     */
    public static Throwable getUserExceptionCause(Throwable exception) {
        //        Throwable ex = exception;
        //        while (ex != null && !(ex.getCause() instanceof UserException)) {
        //            if (ex != null) ex = ex.getCause();
        //        }
        //        return ex;
        return getCauseOfType(exception, UserException.class);
    }

    /** Obtiene la causa de tipo UserException del stackTrace
     * @param exception
     * @return
     */
    public static Throwable getFwkExceptionCause(Throwable exception) {
        //        Throwable ex = exception;
        //        while (ex != null && !(ex.getCause() instanceof FrameworkException)) {
        //            if (ex != null) ex = ex.getCause();
        //        }
        //        return ex;
        return getCauseOfType(exception, FrameworkException.class);

    }

    /** Obtiene una excepción tipo clazz en el stackTrace
     * @param exception
     * @param clazz
     * @return
     */
    public static Throwable getCauseOfType(Throwable exception, Class clazz) {
        Throwable ex = exception;
        while (ex != null) {
            if (clazz.isAssignableFrom(ex.getClass())) return ex;
            ex = ex.getCause();
        }
        return null;
    }

    /**
    * Gets the exception stack trace as a string.
    * @param exception
    * @return
    */
    public static String getStackTraceAsString(Throwable exception) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        pw.print(" [ ");
        pw.print(exception.getClass().getName());
        pw.print(" ] ");
        pw.print(exception.getMessage());
        exception.printStackTrace(pw);
        return sw.toString();
    }

}
