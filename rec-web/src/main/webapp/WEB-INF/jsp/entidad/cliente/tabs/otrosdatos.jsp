<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad){
	function label(id,text){
		return app.creaLabel(text,"",  {id:'entidad-cliente-'+id});
	}

	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title: title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
	}


   var literal = {
		fechaConstitucion: '<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion" text="**fecha Nacimiento" />'
		,fechaConstitucion1: '<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion1" text="**fecha constitucion" />'
		,paisNacimiento :  '<s:message code="menu.clientes.consultacliente.datosTab.paisnacimiento" text="**Pais Nacimineto" />'
		,paisNacimiento1 :  '<s:message code="menu.clientes.consultacliente.datosTab.paisnacimiento1" text="**Pais Nacimineto" />'
   }

	var panel=new Ext.Panel({
		title:'<s:message code="contrato.consulta.tabcabecera.otrosdatos" text="**Otros Datos"/>'
		,autoScroll:true
		,width:770
		,autoHeight:true
		//,autoWidth : true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,nombreTab : 'tabDatosCliente'
	});


   var tipoPersonaFisica = '<fwk:const value="es.capgemini.pfs.persona.model.DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA" />';
   var tipoPersonaJuridica = '<fwk:const value="es.capgemini.pfs.persona.model.DDTipoPersona.CODIGO_TIPO_PERSONA_JURIDICA" />';

   var fechaConstitucion =  label('fechaConstitucion','<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion" text="**fecha nacimiento" />');
   var fechaConstitucion1 =  label('fechaConstitucion','<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion1" text="**fecha constitucion" />');
   var paisNacimiento =     label('paisNacimiento','<s:message code="menu.clientes.consultacliente.datosTab.paisnacimiento" text="**Pais Nacimineto" />');
   var sexo=                label('sexo','<s:message code="menu.clientes.consultacliente.datosTab.sexo" text="**Sexo" />');
   var nroSocios =          label('nroSocios','<s:message code="menu.clientes.consultacliente.datosTab.nroSocios" text="**Numero de socios" />');
   var oficinaGestora =     label('oficinaGestora','<s:message code="menu.clientes.consultacliente.datosTab.oficinaGestora" text="**oficina Gestora" />');  
   var tipoGestorEntidad =     label('tipoGestorEntidad','<s:message code="menu.clientes.consultacliente.datosTab.tipoGestorEntidad" text="**Tipo gestor" />');
   var esEmpleado =         label('esEmpleado','<s:message code="menu.clientes.consultacliente.datosTab.esEmpleado" text="**Empleado" />');
   var tieneIngresosDomiciliados =     label('tieneIngresosDomiciliados','<s:message code="menu.clientes.consultacliente.datosTab.tieneIngresosDomiciliados" text="**Ingresos domiciliados" />');
   var volumenFacturacion = label('volumenFacturacion','<s:message code="menu.clientes.consultacliente.datosTab.volumenFacturacion" text="**Volumen facturación" />');
   var fechaVolumenFacturacion = label('fechaVolumenFacturacion','<s:message code="menu.clientes.consultacliente.datosTab.fechaVolumenFacturacion" text="**Fecha vol. facturación" />');
   var cnae = label('cnae','<s:message code="menu.clientes.consultacliente.datosTab.cnae" text="**CNAE" />');
   var centroGestor=        label('centroGestor','<s:message code="menu.clientes.consultacliente.datosTab.centroGestor" text="**centro Gestor" />');
   var perfilGestor=        label('perfilGestor','<s:message code="menu.clientes.consultacliente.datosTab.perfilGestor" text="**perfil Gestor" />');
   var areaGestion=        label('areaGestion','<s:message code="menu.clientes.consultacliente.datosTab.areaGestion" text="**Área gestion" />');
   var usuarioGestor =      label('usuarioGestor','<s:message code="menu.clientes.consultacliente.datosTab.usuarioGestor" text="**usuario Gestor" />');
   var grupoGestor =        label('grupoGestor','<s:message code="menu.clientes.consultacliente.datosTab.grupoGestor" text="**grupo Gestor" />');
   var codClienteEntidad =  label('codClienteEntidad','<s:message code="menu.clientes.consultacliente.datosTab.codCliente" text="**Codigo" />');
   var nacionalidad =       label('nacionalidad','<s:message code="menu.clientes.consultacliente.datosTab.nacionalidad" text="**Nacionalidad" />');
   var numEmpleados =       label('numEmpleados','<s:message code="menu.clientes.consultacliente.datosTab.numEmpleados" text="**Numero de Empleados" />');
   var politicaEntidad	=   label('politicaEntidad','<s:message code="menu.clientes.consultacliente.datosTab.politicaEntidad" text="**Plan de actuaci&oacute;n Entidad" />');
   var ratingAuxiliar =     label('ratingAuxiliar','<s:message code="menu.clientes.consultacliente.datosTab.ratingAuxiliar" text="**rating Auxiliar" />');
   //var fechaReferenciaRating =     label('fechaReferenciaRating','<s:message code="menu.clientes.consultacliente.datosTab.fechaReferenciaRating" text="**Rating fecha" />');
   //var ratingReferencia =     label('ratingReferencia','<s:message code="menu.clientes.consultacliente.datosTab.ratingReferencia" text="**Rating referencia" />');
   var servicioNominaPension =     label('servicioNominaPension','<s:message code="menu.clientes.consultacliente.datosTab.servicioNominaPension" text="**Nomina o pension" />');
   var ultimaActuacion =     label('ultimaActuacion','<s:message code="menu.clientes.consultacliente.datosTab.ultimaActuacion" text="**Última actuacion" />');
   var situacionConcursal =	label('situacionConcursal','<s:message code="menu.clientes.consultacliente.datosTab.situacionConcursal" text="**Situación concursal" />');
   var fechaSituacionConcursal = label('fechaSituacionConcursal','<s:message code="menu.clientes.consultacliente.datosTab.fechaSituacionConcursal" text="**Fecha situación concursal" />');
   var clienteReestructurado =			label('clienteReestructurado','<s:message code="menu.clientes.consultacliente.datosTab.clienteReestructurado" text="**Cliente Reestructurado"/>');
   var extra1 =             label('extra1','<s:message code="menu.clientes.consultacliente.datosTab.extra1" text="**Extra 1" />');
   var extra2 =             label('extra2','<s:message code="menu.clientes.consultacliente.datosTab.extra2" text="**Extra 2" />');
   var extra3 =             label('extra3','<s:message code="menu.clientes.consultacliente.datosTab.extra3" text="**Extra 3" />');
   var extra4 =             label('extra4','<s:message code="menu.clientes.consultacliente.datosTab.extra4" text="**Extra 4" />');
   var extra5 =             label('extra5','<s:message code="menu.clientes.consultacliente.datosTab.extra5" text="**Extra 5" />');
   var extra6 =             label('extra6','<s:message code="menu.clientes.consultacliente.datosTab.extra6" text="**Extra 6" />');
   var fijo3		=         label('fijo3','<s:message code="menu.clientes.consultacliente.datosTab.telefono3" text="**Fijo3" />');
   var fijo4		=         label('fijo4','<s:message code="menu.clientes.consultacliente.datosTab.telefono4" text="**Fijo4" />');
   var fijo5		=         label('fijo5','<s:message code="menu.clientes.consultacliente.datosTab.telefono5" text="**Fijo5" />');
   var fijo6		=         label('fijo6','<s:message code="menu.clientes.consultacliente.datosTab.telefono6" text="**Fijo6" />');
   
   var colectivoSingular =   label('colectivoSingular','<s:message code="menu.clientes.consultacliente.datosTab.colectivoSingular" text="**Colectivo singular"/>');
   var politicaEntidad =  label('politicaEntidad','<s:message code="menu.clientes.consultacliente.datosTab.prePolitica" text="**Política de Seguimiento"/>');
   var prePolitica	=            label('prePolitica','<s:message code="menu.clientes.consultacliente.datosTab.politica" text="**Plan de actuaci&oacute;n" />');
   var puntuacionAlerta=         label('puntuacionAlerta','<s:message code="menu.clientes.consultacliente.datosTab.puntuacionAlerta" text="**puntuacionAlerta" />');
   var grupoCliente =            label('grupoCliente','<s:message code="menu.clientes.consultacliente.datosTab.grupoCliente" text="**grupoCliente" />');
   var ultimaOperacionConcedida= label('ultimaOperacionConcedida','<s:message code="menu.clientes.consultacliente.datosTab.ultimaOperacionConcedida" text="**ultima Operacion Concedida" />');
   
   var zonaPersona =     label('zonaPersona','<s:message code="menu.clientes.consultacliente.datosTab.zonaPersona" text="**Zona Persona" />');
   var zonaTerritorial = label('zonaTerritorial','<s:message code="menu.clientes.consultacliente.datosTab.zonaTerritorial" text="**Zona Territorial" />');
     
   var accionFSR = label('accionFSR','<s:message code="menu.clientes.consultacliente.datosTab.accionFSR" text="**Acción de FSR" />');
   
  	
   colectivoSingular.autoHeight=true;
   politicaEntidad.autoHeight=true;
   zonaPersona.autoHeight=true;
   zonaTerritorial.autoHeight=true;
   cnae.autoHeight=true;

	var telefonosFieldSet = fieldSet( '<s:message code="menu.clientes.consultacliente.menu.Telefonos" text="**Telefonos"/>'
			,[ {items:[fijo3,fijo4]}, {items:[fijo5,fijo6]} ]);	

	var datosPersonalesFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosPersonales" text="**Datos Personales"/>'
			   , [{items:[fechaConstitucion,nacionalidad,paisNacimiento,numEmpleados, sexo]}, {items:[esEmpleado, volumenFacturacion,fechaVolumenFacturacion, cnae]} ] );

	var datosGestionFieldSet = fieldSet( '<s:message code="menu.clientes.consultacliente.menu.DatosGestion" text="**Datos Gestion"/>'
			, [ {items:[tipoGestorEntidad,oficinaGestora,zonaPersona,zonaTerritorial]}, {items:[centroGestor,grupoGestor,usuarioGestor]} ] );

	//var ratingFieldSet = fieldSet( '<s:message code="menu.clientes.consultacliente.menu.Rating" text="**Rating"/>'
	//		, [ {items:[fechaReferenciaRating]}, {items:[ratingReferencia]} ] ); 


	var OtrosFieldSet = fieldSet( '<s:message code="menu.clientes.consultacliente.menu.Otros" text="**Otros"/>'
			, [ {items:[servicioNominaPension,colectivoSingular,politicaEntidad,prePolitica,tieneIngresosDomiciliados,ultimaActuacion
				<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
					,fechaSituacionConcursal
				</sec:authorize>
			]}
			, {items:[puntuacionAlerta,grupoCliente,ultimaOperacionConcedida,areaGestion,perfilGestor
				<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
					,situacionConcursal,clienteReestructurado
				</sec:authorize>			
			]} ] );

   panel.add(datosPersonalesFieldSet);
   panel.add(datosGestionFieldSet);
   //panel.add(ratingFieldSet);
   panel.add(OtrosFieldSet);


   function telef(num, desc){
      if (desc!='') return num + ' ('+desc+')';
      return num;
   }

    panel.getValue = function(){}
   
	panel.setValue = function(){
		var data = entidad.get("data");
		var d = data.datosCliente;		
		//var cabecera = data.cabecera;

		
		entidad.setLabel("fijo3", telef(d.movil1, d.tipoTelefono3));
		entidad.setLabel("fijo4", telef(d.movil2, d.tipoTelefono4));
		entidad.setLabel("fijo5", telef(d.telefono5, d.tipoTelefono5));
		entidad.setLabel("fijo6", telef(d.telefono6, d.tipoTelefono6));

		if(d.tipoPersona==tipoPersonaFisica){
			entidad.setLabel("fechaConstitucion", d.fechaNacimiento,literal.fechaConstitucion);
			entidad.setLabel("paisNacimiento", d.paisNacimiento,literal.paisNacimiento);
			entidad.setLabel("sexo", d.sexo);
		}else{
			entidad.setLabel("fechaConstitucion", d.fechaConstitucion,literal.fechaConstitucion1);
			entidad.setLabel("paisNacimiento", d.paisNacimiento,literal.paisNacimiento1);
			entidad.setLabel(nroSocios, d.nroSocios);
		}

		entidad.setLabel("esEmpleado", d.esEmpleado);
		entidad.setLabel("tieneIngresosDomiciliados", d.tieneIngresosDomiciliados);
		entidad.setLabel("volumenFacturacion", app.format.moneyRenderer(d.volumenFacturacion));
		entidad.setLabel("fechaVolumenFacturacion", d.fechaVolumenFacturacion);
		entidad.setLabel("cnae", d.cnae);
		entidad.setLabel("tipoGestorEntidad", d.tipoGestorEntidad);
		entidad.setLabel("oficinaGestora", d.oficinaGestora);
		entidad.setLabel("centroGestor", d.centroGestor);
		entidad.setLabel("perfilGestor", d.perfilGestor);
		entidad.setLabel("areaGestion", d.areaGestion);
		entidad.setLabel("usuarioGestor", d.usuarioGestor);
		entidad.setLabel("grupoGestor", d.grupoGestor);
		entidad.setLabel("codClienteEntidad", d.codClienteEntidad);
		entidad.setLabel("nacionalidad", d.nacionalidad);
		entidad.setLabel("numEmpleados", d.numEmpleados);
		entidad.setLabel("politicaEntidad", d.politicaEntidad);
		entidad.setLabel("ratingAuxiliar", d.ratingAuxiliar);
		//entidad.setLabel("ratingReferencia", d.ratingExterno);
		//entidad.setLabel("fechaReferenciaRating", d.fechaReferenciaRating);
		entidad.setLabel("servicioNominaPension", d.servicioNominaPension);
		entidad.setLabel("ultimaActuacion", d.ultimaActuacion);
		entidad.setLabel("situacionConcursal",d.sitConcursal);
		entidad.setLabel('fechaSituacionConcursal',d.fechaSituacionConcursal);
		entidad.setLabel('clienteReestructurado',d.clienteReestructurado);
		entidad.setLabel("extra1", d.extra1);
		entidad.setLabel("extra2", d.extra2);
		entidad.setLabel("extra3", d.extra3);
		entidad.setLabel("extra4", d.extra4);
		entidad.setLabel("extra5", d.extra5);
		entidad.setLabel("extra6", d.extra6);
		
		entidad.setLabel("colectivoSingular", d.colectivoSingular);
		entidad.setLabel("politicaEntidad", d.politicaEntidad);	
		entidad.setLabel('prePolitica', d.prepolitica);	
		entidad.setLabel('puntuacionAlerta', d.puntuacion);
		entidad.setLabel('grupoCliente', data.grupo.nombre);
		entidad.setLabel('ultimaOperacionConcedida', d.ultimaOperacionConcedida);
		entidad.setLabel('zonaPersona', d.zonaPersona);
		entidad.setLabel('zonaTerritorial',d.zonaTerritorial);
		entidad.setLabel('accionFSR',d.accionFSR);
		
					
		var esVisible = [
			[sexo, d.tipoPersona==tipoPersonaFisica]
			,[nroSocios, d.tipoPersona==tipoPersonaJuridica]
//			['sexo',false]
//			,[nroSocios, false]
		];

		entidad.setVisible(esVisible);
	}

	return panel;

})
