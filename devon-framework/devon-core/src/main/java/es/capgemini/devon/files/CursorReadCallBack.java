package es.capgemini.devon.files;

import es.capgemini.devon.exception.FrameworkException;

/**
 * @author Nicol�s Cornaglia
 */
public interface CursorReadCallBack {

    public void beforeFirst();

    public void doWithLine(Object[] row) throws FrameworkException;

    public void afterLast();

}