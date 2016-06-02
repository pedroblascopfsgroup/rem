package es.pfgroup.batch.shell;

public class LauncherDebug {

	public static void main(String[] args) {
		Launcher.debugMode = true;
		Launcher.main(args);
	}
}
