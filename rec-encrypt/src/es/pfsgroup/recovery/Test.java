package es.pfsgroup.recovery;

public class Test {

	public static void main(String[] args) {

		System.out.println(Encriptador.desencriptarPwUrl("bank01/q+7ac340oeM=91843087@//RACPFS-DESA-SCAN:1576/pfsreco_desa"));
		try {
			System.out.println(Encriptador.desencriptarPw("3ehsr8YqxDPSlt3OgXbJbw==27458555"));
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
				
	}

}
