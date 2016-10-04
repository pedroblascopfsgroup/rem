package es.pfsgroup;

import es.cajamadrid.servicios.GM.GMPAJC11_INS.GMPAJC11_INS;
import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.GMPDJB13_INS;
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
			System.out.println("Indique el cliente a ejecutar: tasaciones,infoCliente, instanciaDecision");
			System.exit(1);
		}

		UvemManager uvemManager = new UvemManager();
		try {
			if (args[0].equals("tasaciones")) {
				System.out.println("Ejecutando servicio tasaciones");
				if (args.length == 4) {
					Long idBien = Long.valueOf(args[1]);
					Integer respValue = uvemManager.ejecutarSolicitarTasacion(idBien, args[2], args[3]);
					System.out.println("Resultado llamada tasaciones: " + respValue);
					
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh tasaciones 22 nombreGestor BANKIA/HAYA");
					System.exit(1);
				}
			} else if (args[0].equals("infoCliente")) {
				System.out.println("Ejecutando servicio infoCliente");
				if (args.length == 4) {
					GMPAJC11_INS numclienteIns = uvemManager.ejecutarNumCliente(args[1], args[2], args[3]);
					System.out.println("Resultado llamada resultadoNumCliente: " + numclienteIns.getnumeroCliente());
					
					GMPAJC93_INS datosClienteIns = uvemManager.ejecutarDatosCliente(numclienteIns, args[3]);
					System.out.println("Resultado llamada resultadoDatosCliente: " + datosClienteIns.getName());
					
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh infoCliente 20036188Z 1 00000/05021");
					System.exit(1);
				}

			}else if(args[0].equals("instanciaDecision")){
				InstanciaDecisionDto dto = new InstanciaDecisionDto();
				if (args.length > 1) {
					if(!args[1].equals("ALTA") && !args[1].equals("CONS") && !args[1].equals("MODI")){
						System.out.println(args[1]);
						System.out.println("Acciones disponibles: ALTA|CONS|MODI");		
						System.exit(1);
					}
					
					if(args[1].equals("ALTA")){
						if(args.length == 7){
							dto.setCodigoDeOfertaHaya(args[2]);
							dto.setFinanciacionCliente(Boolean.getBoolean(args[3]));
							dto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							dto.setImporteConSigno(Long.valueOf(args[5]));
							dto.setTipoDeImpuesto(Short.valueOf(args[6]));
							//dto.setContraoferta(Boolean.getBoolean(args[2])); <-- ¿No se setea en el manager?					
						}else{
							System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision ALTA <idOfertaHAYA> <finCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4>");
							System.exit(1);			
						}
						
					}else if(args[1].equals("CONS")){
					
						if(args.length == 7){
							dto.setCodigoDeOfertaHaya(args[2]);	
							dto.setFinanciacionCliente(Boolean.getBoolean(args[3]));
							dto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							dto.setImporteConSigno(Long.valueOf(args[5]));
							dto.setTipoDeImpuesto(Short.valueOf(args[6]));
						}else{
							System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision CONS <idOfertaHAYA> <finCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4>");
							System.exit(1);			
						}
						
					}else if(args[1].equals("MODI")){
					
						if(args.length == 7){	
							dto.setCodigoDeOfertaHaya(args[2]);
							dto.setFinanciacionCliente(Boolean.getBoolean(args[3]));
							dto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							dto.setImporteConSigno(Long.valueOf(args[5]));
							dto.setTipoDeImpuesto(Short.valueOf(args[6]));	
							//dto.setContraoferta(Boolean.getBoolean(args[2]));<-- ¿No se setea en el manager?
						}else{
							System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision ALTA <idOfertaHAYA> <finCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4>");
							System.exit(1);			
						}
					}
					
					GMPDJB13_INS instancia = uvemManager.instanciaDecision(dto, args[1]);
					System.out.println("Resultado llamada instanciaDecision: " + instancia.getCodigoDeOfertaHayacoofhx());
					
				}else{
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision ALTA/CONS/MODI");
					System.exit(1);
				}
				
			}else {
				System.out.println("Servicios admintidos: tasaciones,infoCliente,instanciaDecision");
				System.exit(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
