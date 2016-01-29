package es.capgemini.devon.dto;

import java.io.Serializable;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageResolver;

import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.devon.pagination.PaginationParamsImpl;

public abstract class AbstractDto implements PaginationParams, Serializable {

    private static final long serialVersionUID = 1L;
    private PaginationParams params = PaginationParamsImpl.getNewInstance();

    public String getDir() {
        return params.getDir();
    }

    public int getLimit() {
        return params.getLimit();
    }

    public String getSort() {
        return params.getSort();
    }

    public int getStart() {
        return params.getStart();
    }

    public void setDir(String dir) {
        params.setDir(dir);
    }

    public void setLimit(int limit) {
        params.setLimit(limit);
    }

    public void setSort(String sort) {
        params.setSort(sort);
    }

    public void setStart(int start) {
        params.setStart(start);
    }

    private MessageResolver error(String prefix, String source, String key, String defaultText) {
        return new MessageBuilder().error().source(prefix + "." + source).defaultText(defaultText).build();
    }

}
