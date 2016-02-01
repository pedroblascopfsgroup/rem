package es.capgemini.devon.pagination;

import java.io.Serializable;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

public abstract class PageImpl implements Serializable, Page {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    @Resource
    private Properties appProperties;

    public List<?> results;
    private int firstResult = 0;
    private int pageNumber;
    private int resultsPerPage = Page.LIMIT_NOT_DEFINED;
    private int totalCount;
    private String queryString;
    private Integer totalPages = null;
    private String sortColumn = null;
    private String dir = null;

    public String getSort() {
        return sortColumn;
    }

    public void setSort(String sortColumn) {
        this.sortColumn = sortColumn;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    public int getStart() {
        return firstResult;
    }

    public void setStart(int firstResult) {
        this.firstResult = firstResult;
    }

    public List<?> getResults() {
        return results;
    }

    public void setResults(List<?> results) {
        this.results = results;
    }

    public int getPageNumber() {
        return pageNumber;
    }

    public void setPageNumber(int pageNumber) {
        this.pageNumber = pageNumber;
    }

    public int getResultsPerPage() {
        return resultsPerPage;
    }

    public void setResultsPerPage(int resultsPerPage) {
        this.resultsPerPage = resultsPerPage;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public String getQueryString() {
        return queryString;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

    public Integer getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(Integer totalPages) {
        this.totalPages = totalPages;
    }

    public void setAppProperties(Properties appProperties) {
        this.appProperties = appProperties;
    }

}