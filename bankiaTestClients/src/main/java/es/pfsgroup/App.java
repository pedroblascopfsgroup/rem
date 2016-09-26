package es.pfsgroup;

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.pfsgroup.plugin.rem.api.impl.UvemManager;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;

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
					System.exit(1);
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
					System.exit(1);
				}

			}else if(args[0].equals("instanciaDecision")){
				InstanciaDecisionDto dto = new InstanciaDecisionDto();
				if(!args[1].equals("ALTA") || !args[1].equals("CONS") || !args[1].equals("MODI")){
					System.out.println("Acciones disponibles: ALTA|CONS|MODI");
					System.exit(1);
				}
				
				if(args[1].equals("ALTA")){
					//dto.setCodigoDeOfertaHaya(args[2]);
					dto.setContraoferta(Boolean.getBoolean(args[2]));
					dto.setFinanciacionCliente(Boolean.getBoolean(args[3]));
					dto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
					dto.setImporteConSigno(Long.valueOf(args[5]));
					dto.setTipoDeImpuesto(Short.valueOf(args[6]));
					
				}else if(args[1].equals("CONS")){
					dto.setCodigoDeOfertaHaya(args[2]);
				}if(args[1].equals("MODI")){
					dto.setCodigoDeOfertaHaya(args[2]);
					dto.setContraoferta(Boolean.getBoolean(args[3]));
					dto.setFinanciacionCliente(Boolean.getBoolean(args[4]));
					dto.setIdentificadorActivoEspecial(Integer.valueOf(args[5]));
					dto.setImporteConSigno(Long.valueOf(args[6]));
					dto.setTipoDeImpuesto(Short.valueOf(args[7]));
				}
				
				uvemManager.instanciaDecision(dto, args[1]);
				
			}else {
				System.out.println("Servicios admintidos: tasaciones,infoCliente,instanciaDecision");
				System.exit(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
