package es.capgemini.devon.pagination;

import java.util.List;

public interface Page {

    /**
     * no especificamos el tamaño de página en la query
     */
    public final static int LIMIT_NOT_DEFINED = -1;

    public abstract int getTotalCount();

    public abstract List<?> getResults();
    /*
        public abstract String getSort();

        public abstract void setSort(String sortColumn);

        public abstract String getDir();

        public abstract void setDir(String dir);

        public abstract int getStart();

        public abstract void setStart(int start);


        public abstract void setResults(List<?> results);

        public abstract int getPageNumber();

        public abstract void setPageNumber(int pageNumber);

        public abstract int getResultsPerPage();

        public abstract void setResultsPerPage(int resultsPerPage);


        public abstract void setTotalCount(int totalCount);

        public abstract String getQueryString();

        public abstract void setQueryString(String queryString);

        public abstract Integer getTotalPages();

        public abstract void setTotalPages(Integer totalPages);
    */
}