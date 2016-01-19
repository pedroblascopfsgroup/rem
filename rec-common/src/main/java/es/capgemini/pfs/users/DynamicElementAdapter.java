package es.capgemini.pfs.users;

import java.io.Serializable;

public class DynamicElementAdapter implements DynamicElement, Serializable {

    private String entity = "";
    private String fileName = "";
    private String name = "";
    private int order = 0;
    private int priority = 0;

    public DynamicElementAdapter() {
    }

    public DynamicElementAdapter(String entity, String name, String fileName, int order, int priority) {
        this(entity, name, fileName, order, priority, null);
    }

    public DynamicElementAdapter(String entity, String name, String fileName, int order, int priority, String permission) {
        this.entity = entity;
        this.name = name;
        this.fileName = fileName;
        this.order = order;
        this.priority = priority;
    }

    @Override
    public String getEntity() {
        return entity;
    }

    public void setEntity(String entity) {
        this.entity = entity;
    }

    @Override
    public String getFileName() {
        return fileName;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public int getOrder() {
        return order;
    }

    @Override
    public int getPriority() {
        return priority;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    @Override
    public boolean valid(Object param) {
        return true;
    }

}
