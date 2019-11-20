package es.pfgroup.batch.test.shell.Launcher;

/**
 * 
 * @author bruno
 *
 */
public class RunJobInfo {

	private int entidad;
	
	private String job;

	public int getEntidad() {
		return entidad;
	}

	public RunJobInfo(int entidad, String job) {
		super();
		this.entidad = entidad;
		this.job = job;
	}

	public String getJob() {
		return job;
	}
}
