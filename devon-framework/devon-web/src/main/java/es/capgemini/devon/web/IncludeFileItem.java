package es.capgemini.devon.web;

import java.io.Serializable;

public class IncludeFileItem implements Serializable {

    private static final long serialVersionUID = 1L;

    String fileName;
    String id;
    int order;
    private int priority;

    public IncludeFileItem(String id, String fileName) {
        this(id, fileName, 0, 0);
    }

    public IncludeFileItem(String id, String fileName, int order, int priority) {
        this.id = id;
        this.fileName = fileName;
        this.order = order;
        this.priority = priority;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public int getOrder() {
        return order;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public int getPriority() {
        return priority;
    }

}
