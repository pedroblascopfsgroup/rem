package es.capgemini.devon.bo;

import es.capgemini.devon.exception.FrameworkException;

public interface Executor {

    /**
     * @param id
     * @param arg
     * @return
     * @throws Exception
     */
    // Angel: utilizando argumentos variables falla al usar reflection, no encuentra el método
    //public abstract Object execute(String id, Object... arg) throws Exception;
    public abstract Object execute(String id) throws FrameworkException;

    public abstract Object execute(String id, Object arg1) throws FrameworkException;

    public abstract Object execute(String id, Object arg1, Object arg2) throws FrameworkException;

    public abstract Object execute(String id, Object arg1, Object arg2, Object arg3) throws FrameworkException;

    public abstract Object execute(String id, Object arg1, Object arg2, Object arg3, Object arg4) throws FrameworkException;

    public abstract Object execute(String id, Object arg1, Object arg2, Object arg3, Object arg4, Object arg5) throws FrameworkException;

}