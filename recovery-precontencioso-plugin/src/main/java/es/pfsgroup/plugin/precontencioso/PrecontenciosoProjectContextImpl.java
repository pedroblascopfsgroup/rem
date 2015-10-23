package es.pfsgroup.plugin.precontencioso;

public class PrecontenciosoProjectContextImpl implements PrecontenciosoProjectContext {
	
	private String codigoFaseComun;
	private boolean generarArchivoBurofax;

	@Override
	public String getCodigoFaseComun() {
		return codigoFaseComun;
	}

	public void setCodigoFaseComun(String codigoFaseComun) {
		this.codigoFaseComun = codigoFaseComun;
	}

	public boolean isGenerarArchivoBurofax() {
		return generarArchivoBurofax;
	}

	public void setGenerarArchivoBurofax(boolean generarArchivoBurofax) {
		this.generarArchivoBurofax = generarArchivoBurofax;
	}
	
	
	
}