package es.capgemini.devon.pagination;

import java.io.Serializable;

/**
 * Clase base para utilizar la paginación y ordenación de tablas. Los DTO de
 * usuario pueden heredar para no tener que escribir los métodos de los
 * interfaces Pagination
 * 
 * @author amarinso
 * 
 */
public class PaginationParamsImpl implements Serializable, PaginationParams {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private int limit = -1;
    private int start = -1;
    private String sort = null;
    private String dir = null;

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

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

    /** Static factory method para crear un PaginationParams
     * @return
     */
    public static PaginationParams getNewInstance() {
        return new PaginationParamsImpl();
    }

}
