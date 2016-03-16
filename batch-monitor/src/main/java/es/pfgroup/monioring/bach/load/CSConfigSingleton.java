package es.pfgroup.monioring.bach.load;

/**
 * Clase Singleton con flags de configuración que se pueden usar en distintos puntos del código.
 * @author bruno
 *
 */
public class CSConfigSingleton {

	/*
	 * Flags de configuración
	 */
	// Determina si se va a usar la marca de PasajeProduccion para averiguar el estado de un JOB
	private boolean usePasajeProduccionMark = true;
	
	
	/*
	 *GETS y SETS 
	 */
	public boolean isUsePasajeProduccionMark() {
		return usePasajeProduccionMark;
	}

	public void setUsePasajeProduccionMark(boolean usePasajeProduccionMark) {
		this.usePasajeProduccionMark = usePasajeProduccionMark;
	}

	/*
	 * Construcción del singleton
	 */
	/**
	 * Constructor privado
	 */
	private CSConfigSingleton(){}
	
	private static CSConfigSingleton instance;
	
	public static synchronized CSConfigSingleton getInstance(){
		if (instance == null){
			instance = new CSConfigSingleton();
		}
		return instance;
	}
}
