package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.oficina.api.OficinaApi;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimientoApi;

public class InformeSubastaCommon {
	
	@Autowired
	protected ApiProxyFactory proxyFactory;

	@Autowired
	protected SubastaApi subastaApi;
	
	@Autowired
	protected NMBProjectContext nmbCommonProjectContext;
	
	
	private static final String COD_BANCA_MINORISTA = "0376";
	private static final String COD_BANCA_MAYORISTA = "0440";
	private static final Integer COD_OFICINA_MINORISTA = 213;
	private static final Integer COD_OFICINA_MAYORISTA = 625;
	

	protected HistoricoProcedimiento getNodo(Procedimiento procedimiento, String nombreNodo) {
		System.out.println("[INFO] -  - Metodo getNodo - ");
		HistoricoProcedimiento hPrc = null;
		if ((!Checks.esNulo(procedimiento)) && (!Checks.esNulo(nombreNodo))) {
			System.out.println("[INFO] - Procedimiento: " + procedimiento.getId().toString());
			System.out.println("[INFO] - Nombre nodo: " + nombreNodo);
			List<EXTHistoricoProcedimiento> listadoTareasProc = proxyFactory.proxy(EXTHistoricoProcedimientoApi.class).getListByProcedimientoEXT(procedimiento.getId());			
			if (!Checks.esNulo(listadoTareasProc)) {
				System.out.println("[INFO] - Hay tareas procedimiento");
				for (EXTHistoricoProcedimiento hp : listadoTareasProc) {
					System.out.println("[INFO] - Tarea procedimiento: " + (Checks.esNulo(hp.getCodigoTarea()) ? "nulo" : hp.getCodigoTarea()));
					// Filtramos por el código de la tarea donde están los campos que
					// necesitamos y nos quedamos con el último
					if (!Checks.esNulo(hp.getCodigoTarea()) &&  nombreNodo.equals(hp.getCodigoTarea())) {
						hPrc = hp;
						System.out.println("[INFO] - Tarea encontrada: " + hp.getCodigoTarea());
						break;
					}
				}
			}
		}
		System.out.println("[INFO] -  - Metodo getNodo Finalizado OK - ");
		return hPrc;
	}
	
	protected HistoricoProcedimiento getNodo(Procedimiento procedimiento, List<String> nombreNodos) {
		HistoricoProcedimiento hPrc = null;
		if ((!Checks.esNulo(procedimiento)) && (!Checks.estaVacio(nombreNodos))) {
			List<EXTHistoricoProcedimiento> listadoTareasProc = proxyFactory.proxy(EXTHistoricoProcedimientoApi.class).getListByProcedimientoEXT(procedimiento.getId());			
			if (!Checks.esNulo(listadoTareasProc)) {
				for (EXTHistoricoProcedimiento hp : listadoTareasProc) {
					// Filtramos por el código de la tarea donde están los campos que
					// necesitamos y nos quedamos con el último
					if (!Checks.esNulo(hp.getCodigoTarea()) &&  nombreNodos.contains(hp.getCodigoTarea())) {
						hPrc = hp;
						break;
					}
				}
			}
		}
		return hPrc;
	}

	protected String getValorNodoPrc(HistoricoProcedimiento hPrc, String valor) {
		System.out.println("[INFO] - - Metodo getValorNodoPrc - ");
		// Si hemos encontrado una tarea del tipo especificado
		if (!Checks.esNulo(hPrc) && !Checks.esNulo(valor)) {
			System.out.println("[INFO] - historico prc: " + (Checks.esNulo(hPrc.getIdEntidad())? "nulo" : hPrc.getIdEntidad()));
			System.out.println("[INFO] - Valor a buscar: " + valor);
			if (!Checks.esNulo(hPrc.getIdEntidad())) {
				TareaNotificacion tareaSS = proxyFactory.proxy(TareaNotificacionApi.class).get(hPrc.getIdEntidad());
				if (!Checks.esNulo(tareaSS)) {
					System.out.println("[INFO] - Tarea notificacion: " + tareaSS.getCodigo());
					if (!Checks.esNulo(tareaSS.getTareaExterna())) {
						System.out.println("[INFO] - Tarea externa: " + tareaSS.getTareaExterna().getId());
						List<TareaExternaValor> listadoValores = tareaSS.getTareaExterna().getValores();
						if (!Checks.esNulo(listadoValores)) {
							System.out.println("[INFO] - Hay valores TEV");
							for (TareaExternaValor val : listadoValores) {
								System.out.println("[INFO] - Nombre valor: " + val.getNombre());
								if (valor.equals(val.getNombre())) {
									System.out.println("[INFO] - Return valor: " + val.getValor());
									System.out.println("[INFO] -  - Metodo getValorNodoPrc finalizado OK - ");
									return val.getValor();
								}
							}
						}
					}
				}
			}
		}
		
		System.out.println("[INFO] - [ERROR] - Metodo getValorNodoPrc finalizado KO - ");
		return null;

	}

	protected String getValorNodoPrc(Procedimiento procedimiento, String nombreNodo, String valor) {
		return this.getValorNodoPrc(this.getNodo(procedimiento, nombreNodo), valor);
	}

	protected Date dameFecha(String strFecha) {
		System.out.println("[INFO] -  Metodo dameFecha - ");
		SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
		Date fecha = null;
		if (!Checks.esNulo(strFecha)) {
			System.out.println("[INFO] - Fecha IN: " + strFecha);
			try {
				fecha = formatoDelTexto.parse(strFecha);
			} catch (ParseException ex) {
				System.out.println(ex.getMessage());
				ex.printStackTrace();
			}
		}
		System.out.println("[INFO] -  Metodo dameFecha finalizado OK (Return: " + (Checks.esNulo(fecha) ? "nulo" : fecha) +")");
		return fecha;
	}
	
//	protected String getCodDescripOficina(oficina, descripcion, nombre) pasa a entidad Oficina (rec-common)
	
	protected Contrato getContratoBienImporteMaximo(NMBBien bien) {
		System.out.println("[INFO] - - Metodo getContratoBienImporteMaximo -");
		Contrato contratoBien = null;
		if (!Checks.esNulo(bien)) {
			System.out.println("[INFO] - Bien id: " + bien.getId().toString());
			Float importeMaximo = 0F;
			List<NMBContratoBien> contratosBien = bien.getContratos();
			if (!Checks.esNulo(contratosBien)) {
				System.out.println("[INFO] - Hay contratosBien");
				for (NMBContratoBien nmbContratoBien : contratosBien) {
					Contrato contratoTmp = nmbContratoBien.getContrato();
					Float pVenc = (Checks.esNulo(contratoTmp.getLastMovimiento().getPosVivaVencida())) ? 0F : contratoTmp.getLastMovimiento().getPosVivaVencida();
					Float pNoVenc = (Checks.esNulo(contratoTmp.getLastMovimiento().getPosVivaNoVencida())) ? 0F : contratoTmp.getLastMovimiento().getPosVivaNoVencida();
					Float posViva = pVenc + pNoVenc;
					if (posViva > importeMaximo) {
						contratoBien = contratoTmp;
						importeMaximo = posViva;
					}
				}
			}
		}
		System.out.println("[INFO] - ContratoBien devuelto: " + (Checks.esNulo(contratoBien) ? "nulo" : contratoBien.getId().toString()));
		return contratoBien;
	}
	
	protected Float getSumaDeudaTotal(Contrato opContrato) {
		if (!Checks.esNulo(opContrato) && !Checks.esNulo(opContrato.getLastMovimiento())) {			
			Float opVenc = (!Checks.esNulo(opContrato.getLastMovimiento().getPosVivaVencida())) ? opContrato.getLastMovimiento().getPosVivaVencida() : 0F;
			Float opNoVenc = (!Checks.esNulo(opContrato.getLastMovimiento().getPosVivaNoVencida())) ? opContrato.getLastMovimiento().getPosVivaNoVencida() : 0F;
			Float opSum = opVenc+opNoVenc;
			if (opSum > 0F) {				
				Float interesesOrdinarios = (Checks.esNulo(opContrato.getLastMovimiento().getMovIntRemuneratoriosAbsoluta())) ? 0F : opContrato.getLastMovimiento().getMovIntRemuneratoriosAbsoluta(); 
				Float interesesMoratorios = (Checks.esNulo(opContrato.getLastMovimiento().getMovIntMoratoriosAbsoluta())) ? 0F : opContrato.getLastMovimiento().getMovIntMoratoriosAbsoluta();
				return interesesOrdinarios + interesesMoratorios + opSum;				
			}
		}
		return null;
	}
	
	
	/**
	 * 1) A partir de la oficina tenemos que subir hasta el nivel 5. Si encontramos el valor 0440 entonces se trata de Banca Mayorista.<br>
	 * 2) Si no encontramos nada en el nivel 5 o encontramos algo pero no coincide con 0440, entonces tenemos que subir hasta el nivel 6. Si el valor encontrado es 0376, entonces se trata de Banca Minorista.<br>
	 * Según el resultado de los pasos 1 y 2, tenemos que rellenar el campo Dirección Proponente del impreso:<br>
	 * Si Banca Mayorista --> Sacamos el literal 0625 - DIR. RECUPERACIONES MAYORISTA<br>
	 * Si Banca Minorista --> Sacamos el literal 0213 - DIR. RECUPERACIONES MINORISTA<br>
	 * @param oficina
	 * @return
	 */
	protected String getDirProponente(DDZona zona, Set<Long> zonasHijas) {

		if (Checks.esNulo(zona))
			return "";

		if (!Checks.esNulo(zona.getNivel().getCodigo())) {
			if ("5".equals(zona.getNivel().getCodigo()) && (!Checks.esNulo(zona.getOficina()))) {
				if (COD_BANCA_MAYORISTA.equals(zona.getOficina().getCodDescripOficina(false, false))) {
					Oficina oficinaReturn = proxyFactory.proxy(OficinaApi.class).buscarPorCodigoOficina(COD_OFICINA_MAYORISTA);
					if (!Checks.esNulo(oficinaReturn)) {
						return oficinaReturn.getCodDescripOficina(true, true);
					} else {
						return "0625 - DIR. RECUPERACIONES MAYORISTA";
					}
				}
			}
			if ("6".equals(zona.getNivel().getCodigo()) && (!Checks.esNulo(zona.getOficina()))) {
				if (COD_BANCA_MINORISTA.equals(zona.getOficina().getCodDescripOficina(false, false))) {
					Oficina oficinaReturn = proxyFactory.proxy(OficinaApi.class).buscarPorCodigoOficina(COD_OFICINA_MINORISTA);
					if (!Checks.esNulo(oficinaReturn)) {
						return oficinaReturn.getCodDescripOficina(true, true);
					} else {
						return "0213 - DIR. RECUPERACIONES MINORISTA";
					}
				}
			}
		}

		DDZona zonaPadre = (!Checks.esNulo(zona)) ? zona.getZonaPadre() : null;

		// Si la zona padre es la misma que la hija entraría en un bucle
		// infinito
		if (!Checks.esNulo(zonaPadre) && !Checks.estaVacio(zonasHijas) && zonasHijas.contains(zonaPadre.getId())) {
			System.out.print("[ERROR] - La zonificación está mal configurada - CODIGO ZONA: " + zonaPadre.getCodigo());
			return "";
		} else {
			zonasHijas.add(zona.getId());
			return (!Checks.esNulo(zonaPadre) ? getDirProponente(zonaPadre, zonasHijas) : "");
		}
	}
}
