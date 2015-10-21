package es.pfsgroup.plugin.precontencioso;

public class PrecontenciosoProjectContextImpl implements PrecontenciosoProjectContext {
	
	private String codigoFaseComun;

	@Override
	public String getCodigoFaseComun() {
		return codigoFaseComun;
	}

	public void setCodigoFaseComun(String codigoFaseComun) {
		this.codigoFaseComun = codigoFaseComun;
	}
	
}