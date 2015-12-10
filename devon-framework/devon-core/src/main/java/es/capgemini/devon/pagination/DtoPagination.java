package es.capgemini.devon.pagination;

import java.io.Serializable;

/** clase base para los DTO que se usar�n como par�metros de paginaci�n
 * @author amarinso
 *
 */
public class DtoPagination implements Serializable {

    private int limit;
    private int start;

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    public int getStart() {
        return start;
    }

    public void setStart(int start) {
        this.start = start;
    }

}
