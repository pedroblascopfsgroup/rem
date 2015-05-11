<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){

		//Panel propiamente dicho...
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
		
		
		panel.on('render', function()
		{


			var labelStyle = 'width:185px;font-weight:bolder';
			var cfg = {labelStyle:"width:185px;font-weight:bolder",width:375};
			Ext.QuickTips.init();
			var labelLargo = function(label,text){
				return {html : "<span class='LabelStatic'>"+label+":</span><span class='TextStatic' ext:qtip='"+text+"' >"+text+"</span>",border:false}
			}
			
			var tipoPersonaFisica = '<fwk:const value="es.capgemini.pfs.persona.model.DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA" />';
			var tipoPersonaJuridica = '<fwk:const value="es.capgemini.pfs.persona.model.DDTipoPersona.CODIGO_TIPO_PERSONA_JURIDICA" />';
			var tipoPersona = '${persona.tipoPersona.codigo}';
		
			var fechaConstitucion = null;
			var paisnacimiento= null;
			var sexo=  null; 
			var nroSocios= null;
			if (tipoPersona == tipoPersonaFisica)
			{
				fechaConstitucion= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion" text="**fecha nacimiento" />',"<fwk:date value='${persona.fechaConstitucion}'/>",cfg);
				paisnacimiento= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.paisnacimiento" text="**Pais Nacimineto" />','${persona.paisNacimiento.descripcion}',cfg);
				sexo= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.sexo" text="**Sexo" />','${persona.sexo.descripcion}',cfg);
			}
			else
			{
				fechaConstitucion= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion1" text="**fecha Constitucion" />',"<fwk:date value='${persona.fechaConstitucion}'/>",cfg);
				paisnacimiento= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.paisnacimiento1" text="**Pais Nacimineto" />','${persona.paisNacimiento.descripcion}',cfg);
				nroSocios=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.nroSocios" text="**Numero de socios" />','${persona.nroSocios}',cfg);
			}
		
		
			
		//Textfields
			
			var oficinaGestora= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.oficinaGestora" text="**oficina Gestora" />','${persona.oficinaGestora.nombre}',cfg);
			var centroGestor=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.centroGestor" text="**centro Gestor" />','${persona.centroGestor.descripcion}',cfg);
			var perfilGestor= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.perfilGestor" text="**perfil Gestor" />','${persona.perfilGestor.descripcion}',cfg);
			var usuarioGestor= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.usuarioGestor" text="**usuario Gestor" />','${persona.usuarioGestor.apellidoNombre}',cfg);
			var grupoGestor= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.grupoGestor" text="**grupo Gestor" />','${persona.grupoGestor.descripcion}',cfg);
			var codClienteEntidad=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.codCliente" text="**Codigo" />','${persona.codClienteEntidad}' , {<app:test id="codClienteEntidad" />},cfg);
			var nacionalidad= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.nacionalidad" text="**Nacionalidad" />','${persona.nacionalidad.descripcion}',cfg);
			var numEmpleados=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.numEmpleados" text="**Numero de Empleados" />','${persona.numEmpleados}',cfg); 
			
			//Politica de la entidad
			var politicaEntidad 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.politicaEntidad" text="**politicaEntidad" />','${persona.politicaEntidad.descripcion}',cfg);
			
			var ratingAuxiliar=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.ratingAuxiliar" text="**rating Auxiliar" />','${persona.ratingAuxiliar}',cfg); 
			var extra1=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.extra1" text="**Extra 1" />','${persona.extra1}',cfg); 
			var extra2=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.extra2" text="**Extra 2" />','${persona.extra2}',cfg); 
			var extra3=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.extra3" text="**Extra 3" />','${persona.extra3.descripcion}',cfg); 
			var extra4=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.extra4" text="**Extra 4" />','${persona.extra4.descripcion}',cfg); 
			var extra5=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.extra5" text="**Extra 5" />',"<fwk:date value='${persona.extra5}'/>",cfg); 
			var extra6=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.extra6" text="**Extra 6" />',"<fwk:date value='${persona.extra6}'/>",cfg); 
			var fijo3		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.telefono3" text="**Fijo3" />',descTel3,cfg);
			var fijo4		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.telefono4" text="**Fijo4" />',descTel4,cfg);
			var fijo5		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.telefono5" text="**Fijo5" />',descTel5,cfg);
			var fijo6		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.telefono6" text="**Fijo6" />',descTel6,cfg);
	
		
		var tel3 = '${persona.movil1}';	
		var tel4 = '${persona.movil2}';	
		var tel5 = '${persona.telefono5}';	
		var tel6 = '${persona.telefono6}';	
	
	
		var tipoTel3 = '${persona.tipoTelefono3.descripcion}';	
		var tipoTel4 = '${persona.tipoTelefono4.descripcion}';	
		var tipoTel5 = '${persona.tipoTelefono5.descripcion}';	
		var tipoTel6 = '${persona.tipoTelefono6.descripcion}';	
	
	
		var descTel3 = '';
		var descTel4 = '';
		var descTel5 = '';
		var descTel6 = '';
	
		
		
		if (tel3 != '')
		{
			descTel3 = tel3;
			if (tipoTel3 != '') descTel3 += ' ('+tipoTel3+')';
		}	
	
		if (tel4 != '')
		{
			descTel4 = tel4;
			if (tipoTel4 != '') descTel4 += ' ('+tipoTel4+')';
		}	
	
		if (tel5 != '')
		{
			descTel5 = tel5;
			if (tipoTel5 != '') descTel5 += ' ('+tipoTel5+')';
		}	
	
		if (tel6 != '')
		{
			descTel6 = tel6;
			if (tipoTel6 != '') descTel6 += ' ('+tipoTel6+')';
		}	
		
		var telefonosFieldSet = new Ext.form.FieldSet({
			autoHeight:'false'
			,style:'padding:0px'
	 		,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,width:770
			,title:'<s:message code="menu.clientes.consultacliente.menu.Telefonos" text="**Telefonos"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
			,items : [
					  {items:[fijo3,fijo4]},
					  {items:[fijo5,fijo6]}
			 	 
			]
		});	
		
			
			var arraySociosEmpleadosSexo = [numEmpleados];
			
			if (tipoPersona == tipoPersonaFisica){
				arraySociosEmpleadosSexo.push(sexo);
			}
			if (tipoPersona == tipoPersonaJuridica){
				arraySociosEmpleadosSexo.push(nroSocios);
			}
	
	
			var datosPersonalesFieldSet = new Ext.form.FieldSet({
			autoHeight:'false'
			,style:'padding:0px'
		  	,border:false
			,layout : 'table'
			,border : true
			,layoutConfig:{
			columns:2
				}
			,width:770
			,title:'<s:message code="menu.clientes.consultacliente.menu.DatosPersonales" text="**Datos Personales"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
			,items : [{items:[fechaConstitucion,nacionalidad,paisnacimiento]},
					  {items:arraySociosEmpleadosSexo}
			 	
			]
		});
	
	
		var datosGestionFieldSet = new Ext.form.FieldSet({
			autoHeight:'false'
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,width:770
			,title:'<s:message code="menu.clientes.consultacliente.menu.DatosGestion" text="**Datos Gestion"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
			,items : [
					  {items:[oficinaGestora,centroGestor,perfilGestor]},
					  {items:[usuarioGestor,grupoGestor]}
			 	 
			]
			
		});
	
	
		var ratingFieldSet = new Ext.form.FieldSet({
			autoHeight:'false'
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,width:770
			,title:'<s:message code="menu.clientes.consultacliente.menu.Rating" text="**Rating"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
			,items : [
					  {items:[politicaEntidad]},
					  {items:[ratingAuxiliar]}
			 	 
				 	
			]
		}); 
	
		var OtrosFieldSet = new Ext.form.FieldSet({
			autoHeight:'false'
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,width:770
			,title:'<s:message code="menu.clientes.consultacliente.menu.Otros" text="**Otros"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
			,items : [
					  {items:[extra1,extra2,extra3]},
					  {items:[extra4,extra5,extra6]}
			]
		
		});

		
			panel.add(datosPersonalesFieldSet);
			panel.add(datosGestionFieldSet);
			panel.add(ratingFieldSet);
			panel.add(telefonosFieldSet);
			panel.add(OtrosFieldSet);
		});
				
		
		
/*		
		//panel.show(false);
		panel.on('show', function()
		{
			panel.setRender(true);
			panel.setHidden(false);
			alert('abierto');
		});
*/		
		
		return panel;
})()
