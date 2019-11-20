package es.pfgroup.batch.shell;

import org.archive.jmx.Client;

import es.pfsgroup.recovery.Encriptador;

/**
 * Fachada para el cmdline-jmxclient
 * 
 * @author bruno
 * 
 */
public class JMXClientFacade {

	private class JMXRunnable implements Runnable {

		private String[] args;

		public JMXRunnable(final JMXConnectionInfo cnninfo) {
			super();
			this.args = tryToDecryptPassword(cnninfo).getArray();
		}

		@Override
		public synchronized void run() {
			try {
				Client.main(args);
				Thread.currentThread().sleep(300);
				notifyAll();
			} catch (InterruptedException e) {
				throw new UserInterruptionNonCheckedException(e);
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}

	public void launchJMX(final JMXConnectionInfo cnninfo) {
		final JMXRunnable jmx = new JMXRunnable(cnninfo);
		synchronized (jmx) {
			new Thread(jmx).start();
			try {
				jmx.wait();
			} catch (InterruptedException e) {
				throw new UserInterruptionNonCheckedException(e);
			}
		}

	}

	/**
	 * Este método añade soporte a la encriptación del password para acceder a
	 * JMX. Primero intentará desencriptar el password, si el desencriptado no
	 * tiene éxito lo dejará talcual.
	 * 
	 * @param cnninfo
	 * @return
	 */
	private JMXConnectionInfo tryToDecryptPassword(final JMXConnectionInfo cnninfo) {
		assert cnninfo != null;
		final JMXConnectionInfo infodecrypted = cnninfo.clone();
		if ((infodecrypted.getJmxAuth() != null) && (!"".equals(infodecrypted.getJmxAuth()))){
			final String[] encArray = infodecrypted.getJmxAuth().split(":");
			if (encArray.length == 2){
				final String login = encArray[0];
				final String encpwd = encArray[1];
				String pwd = null;
				try{
					pwd = Encriptador.desencriptarPw(encpwd);
				}catch(Exception e){
					// Si no se puede encriptar dejamso pwd como null
					// puede deberse a que nos han pasado el password en claro.
					pwd = null;
				}
				// Cambiamos el password inicial sólo si lo hemos desencriptado
				if ((pwd != null) && (!pwd.equals(encpwd))){
					infodecrypted.setJmxAuth(login + ":" + pwd);
				}
			}
		}
		
		
		return infodecrypted;
	}
}
