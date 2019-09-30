package es.pfsgroup.plugin.rem.excel;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.VListOfertasCES;

public class ListaOfertasCESExcelReport extends AbstractExcelReport implements ExcelReport {
	
	/** Logger available to subclasses */
	protected final Log logger = LogFactory.getLog(getClass());
	
	private List<VListOfertasCES> listaOfertas;
	
	private static final String SERVICER = "Haya Real Estate";
	
	public ListaOfertasCESExcelReport(List<VListOfertasCES> listaOfertas) {
		this.listaOfertas = listaOfertas;

	}

	public List<String> getCabeceras() {
		List<String> listaCabeceras = new ArrayList<String>();
		listaCabeceras.add("OFFER NUMBER");
		listaCabeceras.add("SERVICER");
		listaCabeceras.add("UNIT ID - HAYA");
		listaCabeceras.add("UNIT ID - SERVICER");
		listaCabeceras.add("UNIT ID - Banco Santander");
		listaCabeceras.add("FR");
		listaCabeceras.add("REFERENCIA CATASTAL");
		listaCabeceras.add("DIRECCION ACTIVO");
		listaCabeceras.add("LOCALIDAD");
		listaCabeceras.add("PROVINCIA");
		listaCabeceras.add("CCAA");
		listaCabeceras.add("OFFER DATE");
		listaCabeceras.add("Fecha Prevista firma");
		listaCabeceras.add("OFFER (€)");
		listaCabeceras.add("ASKING PRICE");
		listaCabeceras.add("LEADS NUMBER");
		listaCabeceras.add("VISITS NUMBER");
		listaCabeceras.add("OFFERS NUMBER");
		listaCabeceras.add("Nombre Comprador1");
		listaCabeceras.add("Apellidos Comprador1");
		listaCabeceras.add("Numero de identificación comprador1");
		listaCabeceras.add("Nombre Comprador2");
		listaCabeceras.add("Apellidos Comprador2");
		listaCabeceras.add("Numero de identificación comprador2");
		listaCabeceras.add("Nombre Comprador3");
		listaCabeceras.add("Apellidos Comprador3");
		listaCabeceras.add("Numero de identificación comprador3");
		
		return listaCabeceras;
	}

	public List<List<String>> getData() {
		
		List<List<String>> valores = new ArrayList<List<String>>();
		DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		
		for(VListOfertasCES ofertaCES: listaOfertas){
			List<String> fila = new ArrayList<String>();
			
			String fechaAltaOferta ="";
			String fechaPrevista="";
			
			if(!Checks.esNulo(ofertaCES.getFechaAltaOferta()))
				fechaAltaOferta = formatter.format(ofertaCES.getFechaAltaOferta());
			if(!Checks.esNulo(ofertaCES.getFechaPosicionamientoPrevista()))
				fechaPrevista = formatter.format(ofertaCES.getFechaPosicionamientoPrevista());
				
			
			fila.add(!Checks.esNulo(ofertaCES.getNumOferta()) ? ofertaCES.getNumOferta().toString() : "");//OFFER NUMBER
			fila.add(SERVICER);//SERVICER
			fila.add(ofertaCES.getNumActivo());//UNIT ID - HAYA
			fila.add(ofertaCES.getIdServicer());//UNIT ID - SERVICER
			fila.add(ofertaCES.getIdInmuebleBS());//UNIT ID - Banco Santander
			fila.add(ofertaCES.getFincaRegistral());//FR Finca Registral
			fila.add(ofertaCES.getReferenciaCatastral());//REFERENCIA CATASTAL
			fila.add(ofertaCES.getDireccion());//DIRECCION ACTIVO
			fila.add(ofertaCES.getLocalidad());//LOCALIDAD
			fila.add(ofertaCES.getProvincia());//PROVINCIA
			fila.add(ofertaCES.getComunidadAutonoma());//CCAA
			fila.add(fechaAltaOferta);//OFFER DATE
			fila.add(fechaPrevista);//Fecha Prevista firma
			fila.add(ofertaCES.getImporteOferta());//OFFER (€)
			fila.add(ofertaCES.getImporteVentaActivo());//ASKING PRICE
			fila.add(ofertaCES.getNumeroLeadsActivo());//LEADS NUMBER
			fila.add(ofertaCES.getNumeroVisitasActivo());//VISITS NUMBER
			fila.add(ofertaCES.getNumeroOfertasActivo());//OFFERS NUMBER
			
			String[] compradores = null;
			String[] compradorData = null;
			if(!Checks.esNulo(ofertaCES.getCompradoresExpediente())){
				if(ofertaCES.getCompradoresExpediente().indexOf(";") >= 0) { //Existe mas de 1 comprador
					compradores = ofertaCES.getCompradoresExpediente().split(";");
					for(int i=0;  i < compradores.length && compradores.length <= 3; i++) {
						compradorData = compradores[i].split(",");
						fila.add(compradorData[0]);//Nombre Comprador
						fila.add(compradorData[1]);//Apellidos Comprador
						fila.add(compradorData[2]);//Numero de identificacion comprador
						
					}				
				}else {//Existe solo 1 comprador
					compradores = ofertaCES.getCompradoresExpediente().split(",");
					fila.add(compradores[0]);//Nombre Comprador1
					fila.add(compradores[1]);//Apellidos Comprador1"
					fila.add(compradores[2]);//Numero de identificacion comprador1
				}
			}
			
			valores.add(fila);
		}
		
		return valores;
	}

	public String getReportName() {
		return LISTA_DE_OFERTAS_CES_XLS;
	}
	
	

}
