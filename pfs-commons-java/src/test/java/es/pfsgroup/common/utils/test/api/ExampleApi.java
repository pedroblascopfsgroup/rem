package es.pfsgroup.common.utils.test.api;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ExampleApi {

	static final String EXAMPLE_BO1 = "commons.api.test.example1";
	static final String EXAMPLE_BO2 = "commons.api.test.example2";
	
	@BusinessOperationDefinition(EXAMPLE_BO1)
	int exammpleBusinessOperation(int a, int b);
	
	@BusinessOperationDefinition(EXAMPLE_BO2)
	void exammpleBusinessOperation2(Object o);
}
