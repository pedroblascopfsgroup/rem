package es.pfsgroup;

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.pfsgroup.plugin.rem.api.impl.UvemManager;

/**
 * Test clientes bankia
 * 
 * @author rllinares
 *
 */
public class App {
	public static void main(String[] args) {
		if (args.length < 1) {
			System.out.println("Indique el cliente a ejecutar: tasaciones,infoCliente");
			System.exit(1);
		}

		UvemManager uvemManager = new UvemManager();
		try {
			if (args[0].equals("tasaciones")) {
				System.out.println("Ejecutando servicio tasaciones");
				if (args.length == 4) {
					Long idBien = Long.valueOf(args[1]);
					uvemManager.ejecutarSolicitarTasacion(idBien, args[2], args[3]);
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh tasaciones 22 nombreGestor BANKIA/HAYA"+args.length);
				}
			} else if (args[0].equals("infoCliente")) {
				System.out.println("Ejecutando servicio infoCliente");
				if (args.length == 3) {
					uvemManager.ejecutarNumCliente(args[1], args[2], "00000");
					GMPAJC11_INS numclienteIns = uvemManager.resultadoNumCliente();
					uvemManager.ejecutarDatosCliente(numclienteIns.getnumeroCliente(), "00000");
					GMPAJC93_INS datosClienteIns = uvemManager.resultadoDatosCliente();
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh infoCliente 20036188Z 1"+args.length);
				}

			} else {
				System.out.println("Servicios admintidos: tasaciones,infoCliente");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
