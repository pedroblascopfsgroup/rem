package es.capgemini.pfs.web.procedimientos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.devon.web.DynamicElementManager;

@Component
public class ConsultaProcedimientoManager {

    @Autowired
    DynamicElementManager tabManager;

    @BusinessOperation
    public List<DynamicElement> getTabs(long idProcedimiento) {
        return tabManager.getDynamicElements("tabs.procedimiento", idProcedimiento);
    }

}
