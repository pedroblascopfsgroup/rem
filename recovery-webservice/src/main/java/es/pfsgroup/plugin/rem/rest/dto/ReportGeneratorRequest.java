package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ReportGeneratorRequest implements Serializable{
	
    List<Long> id;

    String reportCode;

    public void sedId(Long id) {
        this.id = new ArrayList<Long>();
        this.id.add(id);
        
    }

    public void setId(List<Long> id) {
        this.id = id;
    }

    public List<Long> getListId() {
        return this.id;
    }

    public void setReportCode(String code) {
        this.reportCode = code;
    }

    public String getReportCode(){
        return this.reportCode;
    }
}
