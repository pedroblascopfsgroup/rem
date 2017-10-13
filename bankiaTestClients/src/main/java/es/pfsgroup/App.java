package es.pfsgroup;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.rem.api.impl.UvemManager;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDataDto;
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
			System.out.println("Cantidad parametros: " + args.length);
			for (int i = 0; i < args.length; i++) {
				System.out.println("args[" + i + "] -> " + args[i]);
			}

			if (args[0].equals("tasaciones")) {
				System.out.println("Ejecutando servicio tasaciones");
				if (args.length == 2) {
					Long idBien = Long.valueOf(args[1]);
					Integer respValue = uvemManager.ejecutarSolicitarTasacionTest(idBien, "SUPER", "noexisto@pfs.es",
							"99999999");
					System.out.println("Resultado llamada tasaciones: " + respValue);

				} else {
					System.out.println(
							"Número de parametros incorrectos: ejem: sh run.sh tasaciones 22 nombreGestor BANKIA/HAYA");
					System.exit(1);
				}
			} else if (args[0].equals("numCliente")) {
				System.out.println("Ejecutando servicio numCliente");
				if (args.length == 4) {
					List<DatosClienteDto> clientes = uvemManager.ejecutarNumCliente(args[1], args[2], args[3]);
					for (DatosClienteDto cliente : clientes) {
						System.out.println(
								"Resultado llamada resultadoNumCliente: " + cliente.getNumeroClienteUrsus() + "\n");
						System.out.println("Resultado llamada nif: " + cliente.getDniNifDelTitularDeLaOferta() + "\n");
						System.out.println(
								"Resultado llamada nombre: " + cliente.getNombreYApellidosTitularDeOferta() + "\n");
					}

				} else {
					System.out.println(
							"Número de parametros incorrectos: ejem: sh run.sh numCliente 20036188Z 1 00000/05021");
					System.exit(1);
				}

			} else if (args[0].equals("datosCliente")) {
				System.out.println("Ejecutando servicio datosCliente");
				if (args.length == 4) {
					List<DatosClienteDto> clientes = uvemManager.ejecutarNumCliente(args[1], args[2], args[3]);
					for (DatosClienteDto cliente : clientes) {
						DatosClienteDto datosClienteIns = uvemManager
								.ejecutarDatosCliente(Integer.valueOf(cliente.getNumeroClienteUrsus()), args[3]);
						System.out.println("Resultado llamada resultadoDatosCliente: "
								+ datosClienteIns.getNombreDelCliente() + "\n");
					}

				} else {
					System.out.println(
							"Número de parametros incorrectos: ejem: sh run.sh datosCliente 20036188Z 1 00000/05021");
					System.exit(1);
				}

			} else if (args[0].equals("instanciaDecision")) {

				ResultadoInstanciaDecisionDto instancia = null;
				if (args.length > 1) {
					if (!args[1].equals("ALTA") && !args[1].equals("CONS") && !args[1].equals("MODI")) {
						System.out.println(args[1]);
						System.out.println("Acciones disponibles: ALTA|CONS|MODI");
						System.exit(1);
					}

					if (args[1].equals("ALTA")) {
						if (args.length == 8 || args.length == 12) {

							List<InstanciaDecisionDataDto> instanciaList = new ArrayList<InstanciaDecisionDataDto>();
							InstanciaDecisionDto instanciaDto = new InstanciaDecisionDto();
							instanciaDto.setCodigoDeOfertaHaya(args[2]);
							instanciaDto.setFinanciacionCliente(Boolean.getBoolean(args[3]));

							// Metemos los datos del primer activo args[4],
							// args[5], args[6], args[7]
							InstanciaDecisionDataDto instanciaDataDto = new InstanciaDecisionDataDto();
							instanciaDataDto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							instanciaDataDto.setImporteConSigno(Long.valueOf(args[5]));
							instanciaDataDto.setTipoDeImpuesto(Short.valueOf(args[6]));
							instanciaDataDto.setPorcentajeImpuesto(Integer.valueOf(args[7]));
							instanciaList.add(instanciaDataDto);

							// Metemos los datos del segundo activo si existe
							// args[8], args[9], args[10], args[11]
							if (args.length == 12) {
								InstanciaDecisionDataDto instanciaDataDto2 = new InstanciaDecisionDataDto();
								instanciaDataDto2.setIdentificadorActivoEspecial(Integer.valueOf(args[8]));
								instanciaDataDto2.setImporteConSigno(Long.valueOf(args[9]));
								instanciaDataDto2.setTipoDeImpuesto(Short.valueOf(args[10]));
								instanciaDataDto2.setPorcentajeImpuesto(Integer.valueOf(args[11]));
								instanciaList.add(instanciaDataDto2);
							}

							instanciaDto.setData(instanciaList);

							instancia = uvemManager.instanciaDecision(instanciaDto, args[1]);
							System.out.println("Resultado llamada Longitud Mensaje De Salida: "
									+ instancia.getLongitudMensajeSalida());
							System.out.println(
									"Resultado llamada Codigo De Oferta Haya: " + instancia.getCodigoDeOfertaHaya());
							System.out.println("Resultado llamada Codigo Comite: " + instancia.getCodigoComite());
						} else {
							System.out.println(
									"Parametros incorrectos: ./run.sh instanciaDecision ALTA <ofertaHRE> <financiaCliente-true/false> <idActivoEspe1> <importeSig1> <tipoImp1-0/1/2/3/4> <%Impuesto1> <idActivoEspe2> <importeSig2> <tipoImp2-0/1/2/3/4> <%Impuesto2>");
							System.exit(1);
						}

					} else if (args[1].equals("CONS")) {

						if (args.length == 7) {

							InstanciaDecisionDto instanciaDto = new InstanciaDecisionDto();
							instanciaDto.setCodigoDeOfertaHaya(args[2]);
							instanciaDto.setFinanciacionCliente(Boolean.getBoolean(args[3]));

							InstanciaDecisionDataDto instanciaDataDto = new InstanciaDecisionDataDto();
							instanciaDataDto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							instanciaDataDto.setImporteConSigno(Long.valueOf(args[5]));
							instanciaDataDto.setTipoDeImpuesto(Short.valueOf(args[6]));

							List<InstanciaDecisionDataDto> instanciaList = new ArrayList<InstanciaDecisionDataDto>();
							instanciaList.add(instanciaDataDto);
							instanciaDto.setData(instanciaList);

							instancia = uvemManager.instanciaDecision(instanciaDto, args[1]);
							System.out.println("Resultado llamada Longitud Mensaje De Salida: "
									+ instancia.getLongitudMensajeSalida());
							System.out.println(
									"Resultado llamada Codigo De Oferta Haya: " + instancia.getCodigoDeOfertaHaya());
							System.out.println("Resultado llamada Codigo Comite: " + instancia.getCodigoComite());
						} else {
							System.out.println(
									"Parametros incorrectos: ./run.sh instanciaDecision CONS 201 <financiaCliente-true/false> <idActivoEspe> <importeSig> <tipoImp-0/1/2/3/4> ");
							System.exit(1);
						}

					} else if (args[1].equals("MODI")) {

						if (args.length == 8 || args.length == 12) {

							List<InstanciaDecisionDataDto> instanciaList = new ArrayList<InstanciaDecisionDataDto>();
							InstanciaDecisionDto instanciaDto = new InstanciaDecisionDto();
							instanciaDto.setCodigoDeOfertaHaya(args[2]);
							instanciaDto.setFinanciacionCliente(Boolean.getBoolean(args[3]));

							// Metemos los datos del primer activo args[4],
							// args[5], args[6], args[7]
							InstanciaDecisionDataDto instanciaDataDto = new InstanciaDecisionDataDto();
							instanciaDataDto.setIdentificadorActivoEspecial(Integer.valueOf(args[4]));
							instanciaDataDto.setImporteConSigno(Long.valueOf(args[5]));
							instanciaDataDto.setTipoDeImpuesto(Short.valueOf(args[6]));
							instanciaDataDto.setPorcentajeImpuesto(Integer.valueOf(args[7]));
							instanciaList.add(instanciaDataDto);

							// Metemos los datos del segundo activo si existe
							// args[8], args[9], args[10], args[11]
							if (args.length == 12) {
								InstanciaDecisionDataDto instanciaDataDto2 = new InstanciaDecisionDataDto();
								instanciaDataDto2.setIdentificadorActivoEspecial(Integer.valueOf(args[8]));
								instanciaDataDto2.setImporteConSigno(Long.valueOf(args[9]));
								instanciaDataDto2.setTipoDeImpuesto(Short.valueOf(args[10]));
								instanciaDataDto2.setPorcentajeImpuesto(Integer.valueOf(args[11]));
								instanciaList.add(instanciaDataDto2);
							}

							instanciaDto.setData(instanciaList);

							instancia = uvemManager.instanciaDecision(instanciaDto, args[1]);
							System.out.println("Resultado llamada Longitud Mensaje De Salida: "
									+ instancia.getLongitudMensajeSalida());
							System.out.println(
									"Resultado llamada Codigo De Oferta Haya: " + instancia.getCodigoDeOfertaHaya());
							System.out.println("Resultado llamada Codigo Comite: " + instancia.getCodigoComite());
						} else {
							System.out.println(
									"Parametros incorrectos: ./run.sh instanciaDecision MODI <ofertaHRE> <financiaCliente-true/false> <idActivoEspe1> <importeSig1> <tipoImp1-0/1/2/3/4> <%Impuesto1> <idActivoEspe2> <importeSig2> <tipoImp2-0/1/2/3/4> <%Impuesto2>");
							System.exit(1);
						}
					}

				} else {
					System.out.println(
							"Número de parametros incorrectos: ejem: ./run.sh instanciaDecision ALTA/CONS/MODI");
					System.exit(1);
				}

			} else if (args[0].equals("consultaDatosPrestamo")) {
				System.out.println("Ejecutando servicio consultaDatosPrestamo");
				if (args.length == 3) {
					Long result = uvemManager.consultaDatosPrestamo(args[1], Integer.valueOf(args[2]));
					System.out.println("Resultado llamada Importex100: " + result);
				} else {
					System.out.println(
							"Número de parametros incorrectos: ejem: sh run.sh consultaDatosPrestamo 000000000005 <tipoRiesgo>");
					System.exit(1);
				}
			} else {
				System.out.println(
						"Servicios admintidos: tasaciones,numCliente,datosCliente,instanciaDecision,consultaDatosPrestamo");
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
