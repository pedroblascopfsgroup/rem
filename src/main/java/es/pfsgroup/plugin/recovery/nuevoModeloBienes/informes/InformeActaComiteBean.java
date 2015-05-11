package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.SubastaApi;

@Configurable
public class InformeActaComiteBean {

	@Autowired
	protected ApiProxyFactory proxyFactory;

	@Autowired
	protected SubastaApi subastaApi;

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public SubastaApi getSubastaApi() {
		return subastaApi;
	}

	public void setSubastaApi(SubastaApi subastaApi) {
		this.subastaApi = subastaApi;
	}
	
	List<DatosActaComiteBean> datosActaComite;

	Long idAsunto;
	Long idSubasta;
	String fecha;


	public List<Object> create(NMBDtoBuscarLotesSubastas dto) {

		System.out.println("[INFO] - START - informeActaComite");
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

		String fechaDemanda = null;

		InformeActaComiteBean stub = new InformeActaComiteBean();
		Calendar hoy = Calendar.getInstance();

		//Fecha actual desglosada:
        int ano = hoy.get(Calendar.YEAR);
        int mes = hoy.get(Calendar.MONTH) + 1;
        int dia = hoy.get(Calendar.DAY_OF_MONTH);
		
		String mesName = getMontName(mes);
		
		//stub.setFecha(formatter.format(hoy.getTime()));
		stub.setFecha(dia + " DE " + mesName + " DE " + ano);
		//stub.setDatosRegistrales(datosRegistrales);

		List<DatosActaComiteBean> datosActaComite = new ArrayList<DatosActaComiteBean>();
		
		// AQUI TENDREMOS UN PROCESO PARA OBTENER LOS DATOS A MOSTRAR - O BIEN UN METODO 
		// QUE YA NOS LO DE O BIEN CONSTRUIRLO A PARTIR DE DE UN PROCESADO
		// AMQ - 
		datosActaComite = subastaApi.getDatosActaComite(dto);
		
		stub.setDatosActaComite(datosActaComite);
		
		System.out.println("[INFO] - END - Informe acta comite correctamente");

		return Arrays.asList((Object) stub);

	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public Long getIdSubasta() {
		return idSubasta;
	}

	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public List<DatosActaComiteBean> getDatosActaComite() {
		return datosActaComite;
	}

	public void setDatosActaComite(List<DatosActaComiteBean> datosActaComite) {
		this.datosActaComite = datosActaComite;
	}
	
    private String getMontName(int mes)
    {
    	String result = "";
    	String[] meses = {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO",
    			"AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
        result = meses[mes-1];
        
        return result;
    }



}
