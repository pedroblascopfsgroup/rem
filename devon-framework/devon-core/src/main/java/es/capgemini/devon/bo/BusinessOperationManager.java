package es.capgemini.devon.bo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;

@Service
@ManagedResource("type=BusinessOperationManager")
public class BusinessOperationManager {

    @Autowired
    private BusinessOperationRegistry businessOperationRegistry;

    @ManagedOperation(description = "Return the Business Operations list")
    @BusinessOperation(FwkBusinessOperations.BO_OPERATIONS_LIST)
    public List getList() {
        return new ArrayList<String>(businessOperationRegistry.getObjectsRegistry().keySet());
    }

}
