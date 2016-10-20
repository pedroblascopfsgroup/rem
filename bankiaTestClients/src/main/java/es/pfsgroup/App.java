package es.pfsgroup;

import es.cajamadrid.servicios.GM.GMPAJC93_INS.GMPAJC93_INS;
import es.cajamadrid.servicios.GM.GMPDJB13_INS.GMPDJB13_INS;
import es.pfsgroup.plugin.rem.api.impl.UvemManager;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;

/**
 * Test clientes bankia
 * 
 * @author rllinares
 *
 */
public class App {
	public static void main(String[] args) {
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
			} else if (args[0].equals("numCliente")) { 
				System.out.println("Ejecutando servicio numCliente");
				if (args.length == 4) {
					Integer numcliente = uvemManager.ejecutarNumCliente(args[1], args[2], args[3]);
					System.out.println("Resultado llamada resultadoNumCliente: " + numcliente + "\n");
					
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh numCliente 20036188Z 1 00000/05021");
					System.exit(1);
				}

			} else if (args[0].equals("datosCliente")) { 
				System.out.println("Ejecutando servicio datosCliente");
				if (args.length == 4) {		
					Integer numcliente = uvemManager.ejecutarNumCliente(args[1], args[2], args[3]);
					DatosClienteDto datosClienteIns = uvemManager.ejecutarDatosCliente(numcliente, args[3]);
					System.out.println("Resultado llamada resultadoDatosCliente: " + datosClienteIns.getNombreComercialDeLaEmpresa()+ "\n");
					
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh datosCliente 20036188Z 1 00000/05021");
					System.exit(1);
				}

			} else if(args[0].equals("instanciaDecision")){
				InstanciaDecisionDto dto = new InstanciaDecisionDto();
				ResultadoInstanciaDecisionDto instancia = null;
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
							instancia = uvemManager.instanciaDecision(dto, args[1]);
							System.out.println("Resultado llamada Longitud Mensaje De Salida: " + instancia.getLongitudMensajeSalida());
							System.out.println("Resultado llamada Codigo De Oferta Haya: " + instancia.getCodigoDeOfertaHaya());
							System.out.println("Resultado llamada Codigo Comite: " + instancia.getCodigoComite());
						}else{
							System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision ALTA 0000000000000201 <financiaCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4>");
							System.exit(1);			
						}
						
					}else if(args[1].equals("CONS")){
					
						if(args.length == 7){
							dto.setCodigoDeOfertaHaya(args[2]);	
							dto.setFinanciacionCliente(Boolean.getBoolean(args[3]));
							dto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							dto.setImporteConSigno(Long.valueOf(args[5]));
							dto.setTipoDeImpuesto(Short.valueOf(args[6]));
							instancia = uvemManager.instanciaDecision(dto, args[1]);
							System.out.println("Resultado llamada Longitud Mensaje De Salida: " + instancia.getLongitudMensajeSalida());
							System.out.println("Resultado llamada Codigo De Oferta Haya: " + instancia.getCodigoDeOfertaHaya());
							System.out.println("Resultado llamada Codigo Comite: " + instancia.getCodigoComite());	
						}else{
							System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision CONS 0000000000000201 <financiaCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4>");
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
							instancia = uvemManager.instanciaDecision(dto, args[1]);
							System.out.println("Resultado llamada Longitud Mensaje De Salida: " + instancia.getLongitudMensajeSalida());
							System.out.println("Resultado llamada Codigo De Oferta Haya: " + instancia.getCodigoDeOfertaHaya());
							System.out.println("Resultado llamada Codigo Comite: " + instancia.getCodigoComite());	
						}else{
							System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision ALTA <idOfertaHAYA> <finCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4>");
							System.exit(1);			
						}
					}

					
					
				}else{
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh instanciaDecision ALTA/CONS/MODI");
					System.exit(1);
				}
				
			} if (args[0].equals("consultaDatosPrestamo")) {
				System.out.println("Ejecutando servicio consultaDatosPrestamo");
				if (args.length == 3) {
					Long result = uvemManager.consultaDatosPrestamo(args[1], Integer.valueOf(args[2]));
					System.out.println("Resultado llamada Importex100: " + result);
				} else {
					System.out.println("Número de parametros incorrectos: ejem: sh run.sh consultaDatosPrestamo 000000000005 <tipoRiesgo>");
					System.exit(1);
				}
			}
				else {			
				System.out.println("Servicios admintidos: tasaciones,numCliente,datosCliente,instanciaDecision,consultaDatosPrestamo");
				System.exit(1);
			}
		} catch (Exception e) {
			System.out.println("------ERROR-MESSAGE-----");
			System.out.println(e.getMessage());
			System.out.println("------ERROR-----");
			e.printStackTrace();
		}
	}
}
