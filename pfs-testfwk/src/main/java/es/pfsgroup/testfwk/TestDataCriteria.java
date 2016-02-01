package es.pfsgroup.testfwk;

public abstract class TestDataCriteria {

	private String name;
	
	private Object value;

	public String getName() {
		return name;
	}

	public Object getValue() {
		return value;
	}


	public TestDataCriteria(String name, Object value) {
		super();
		this.name = name;
		this.value = value;
	}
	
	boolean isColumnCriteria(){
		return this instanceof ColumnCriteria;
	}
	
	boolean isJoinColumnCriteria(){
		return this instanceof JoinColumnCriteria;
	}
	
	boolean isFieldCriteria(){
		return this instanceof FieldCriteria;
	}
	
	boolean isTypeCriteria(){
		return this instanceof TypeCriteria;
	}
}
