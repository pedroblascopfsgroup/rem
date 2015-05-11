package es.capgemini.pfs.persona.dao.impl;

import java.util.List;

import es.capgemini.devon.pagination.Page;

/**
 * TODO FO.
 *
 */
public class PageSql implements Page {

    private List<?> listado = null;
    private int totalCount = -1;

    /**
     * @return lista
     */
    @Override
    public List<?> getResults() {
        return listado;
    }

    /**
     * @return int
     */
    @Override
    public int getTotalCount() {
        return totalCount;
    }

    /**
     * @param totalCount int
     */
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    /**
     * @param listado list
     */
    public void setResults(List<?> listado) {
        this.listado = listado;
    }

}
