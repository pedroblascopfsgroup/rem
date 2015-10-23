package es.pfsgroup.plugin.precontencioso;

public class PrecontenciosoProjectContextImpl implements PrecontenciosoProjectContext {
	
	public static final String RECOVERY_HAYA = "HAYA";
	public static final String RECOVERY_BANKIA = "BANKIA";
	
	private String codigoFaseComun;
	private String recovery;

	@Override
	public String getCodigoFaseComun() {
		return codigoFaseComun;
	}

	public void setCodigoFaseComun(String codigoFaseComun) {
		this.codigoFaseComun = codigoFaseComun;
	}
	
	@Override
	public String getRecovery() {
		return recovery;
	}

	public void setRecovery(String recovery) {
		this.recovery = recovery;
	}
	
}