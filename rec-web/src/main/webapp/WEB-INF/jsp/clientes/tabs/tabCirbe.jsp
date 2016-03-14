<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function() {

debugger;

	var panel = new Ext.Panel({
		title: '<s:message code="cirbe.titulo" text="**CIRBE" />'
		,autoHeight: true
		,autoWidth: true
		,bodyStyle: 'padding:10px'
		,layout: 'table'
		,layoutConfig: {columns:1}
		,nombreTab : 'cirbePanel'
	});

	panel.on('render', function(){
	
		debugger;
	
		fechaInicial1 = '<fwk:date value="${fechaCirbeActual}"/>';
		fechaInicial2 = '<fwk:date value="${fechaCirbe30Dias}"/>';
		fechaInicial3 = '<fwk:date value="${fechaCirbe60Dias}"/>';
	
		var fechaRecord = Ext.data.Record.create([
			 {name:'codigo'}
			,{name:'descripcion'}
		]);
	
		var fecha1Store = page.getStore({
		    flow: 'clientes/buscarFechasCirbe'
		    ,reader: new Ext.data.JsonReader({
		    	 root : 'diccionario'
		    }, fechaRecord)
		});
	
		var fecha1 = new Ext.form.ComboBox({
			store:fecha1Store
			,displayField:'descripcion'
			,valueField:'codigo'
			,forceSelection:true
			,mode: 'remote'
			,triggerAction: 'all'
			,editable: false
			,fieldLabel: '<s:message code="cirbe.filtro.fecha1" text="**Desde" />'
			,name: 'fecha1'
		});
	
		var fecha2Store = page.getStore({
		    flow: 'clientes/buscarFechasCirbe'
		    ,reader: new Ext.data.JsonReader({
		    	 root : 'diccionario'
		    }, fechaRecord)
		});
	
		var fecha2 = new Ext.form.ComboBox({
			store:fecha2Store
			,displayField:'descripcion'
			,valueField:'codigo'
			,forceSelection:true
			,disabled:true
			,mode: 'remote'
			,triggerAction: 'all'
			,editable: false
			,fieldLabel: '<s:message code="cirbe.filtro.fecha2" text="**Hasta" />'
			,name: 'fecha2'
		});
	
		var fecha3Store = page.getStore({
		    flow: 'clientes/buscarFechasCirbe'
		    ,reader: new Ext.data.JsonReader({
		    	 root : 'diccionario'
		    }, fechaRecord)
		});
	
		var fecha3 = new Ext.form.ComboBox({
			store:fecha3Store
			,displayField:'descripcion'
			,valueField:'codigo'
			,forceSelection:true
			,disabled:true
			,mode: 'remote'
			,triggerAction: 'all'
			,editable: false
			,fieldLabel: '<s:message code="cirbe.filtro.fecha3" text="**Hasta" />'
			,name: 'fecha3'
		});
	
		var btnBuscar = app.crearBotonBuscar({ });
	
		var recargarCombo1 = function(){
			fechaInicial1 = fecha1.getValue();
			fecha1Store.webflow({idPersona:${persona.id},fecha2:fecha2.getValue(), fecha3:fecha3.getValue()});
			
		}
	
		var recargarCombo2 = function(){
			fechaInicial2 = fecha2.getValue();
			fecha2Store.webflow({idPersona:${persona.id},fecha1:fecha1.getValue(), fecha3:fecha3.getValue()});
		}
		
		var recargarCombo3 = function(){
			fechaInicial3 = fecha3.getValue();
			fecha3Store.webflow({idPersona:${persona.id},fecha1:fecha1.getValue(), fecha2:fecha2.getValue()});
		}
	
		var seleccionadoCombo1 = function(){
			recargarCombo2();
			if (!fecha3.disabled){
				recargarCombo3();
			}
			fecha2.enable();
		}
	
		var seleccionadoCombo2 = function(){
			recargarCombo1();
			recargarCombo3();
			fecha3.enable();
		}
	
		var seleccionadoCombo3 = function(){
			recargarCombo1();
			recargarCombo2();
		}
	
		fecha1.on('select',seleccionadoCombo1);
		fecha2.on('select',seleccionadoCombo2);
		fecha3.on('select',seleccionadoCombo3);
	
		var labelFecha1 = new Ext.form.Label({
		   	text:'<s:message code="cirbe.filtro.fecha1" text="**Fecha 1" />'+':'
			,style:'font-size:11;padding:15px;font-weight:bolder;'
		});
	
		var labelFecha2 = new Ext.form.Label({
		   	text:'<s:message code="cirbe.filtro.fecha2" text="**Fecha 2" />'+':'
			,style:'font-size:11;padding:15px;font-weight:bolder;'
		});
	
		var labelFecha3 = new Ext.form.Label({
		   	text:'<s:message code="cirbe.filtro.fecha3" text="**Fecha 3" />'+':'
			,style:'font-size:11;padding:15px;font-weight:bolder;'
		});
	
		var panelFiltros = new Ext.form.FieldSet({
			title: '<s:message code="cirbe.fechas" text="**Fechas de carga" />'
			,autoHeight: true
			,autoWidth: true
			,bodyStyle: 'padding:7px;'
			,layout: 'table'
			,layoutConfig: {columns:7}
			,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
			,items: [
				{items:[labelFecha1],border:false,style:'margin-left:5px'}
				,{items:[fecha1],border:false}
				,{items:[labelFecha2],border:false,style:'margin-left:5px'}
				,{items:[fecha2],border:false}
				,{items:[labelFecha3],border:false,style:'margin-left:5px'}
				,{items:[fecha3],border:false}
				,{items:[btnBuscar],border:false,style:'margin-left:20px'}
			 ]
		});
	
		var cirbeGrid = new Ext.ux.DynamicGridPanel({
		  storeUrl: '../clientes/tabCirbeData.htm'
		  ,height: 330
		  //,hidden: true
		});
	
	
	
		var buscarFunc = function() {
					if(fecha1.getValue()===''){
						Ext.Msg.show({
						   title: fwk.constant.errorMsg
						   ,msg: "<s:message code="cirbe.filtro.desde.error" text="**Debe ingresar una fecha en el campo 'Fecha 1'." />"
						   ,buttons: Ext.Msg.OK
						   ,animEl: 'elId'
						   ,icon: Ext.MessageBox.ERROR
						});
					} else {
						cirbeGrid.show();
						panel.doLayout();
						cirbeGrid.store.load({params:{
								idPersona:${persona.id}
								,fecha1:fecha1.getValue()
								,fecha2:fecha2.getValue()
								,fecha3:fecha3.getValue()
							}});
					}
	    	    };
	
		btnBuscar.setHandler(buscarFunc);
		
		var setearFecha1 = function(){
			fecha1.setValue(fechaInicial1);
			fecha1.getValue();//Necesario para que se muestre el valor en el combo 
		}
	
		var setearFecha2 = function(){
			fecha2.setValue(fechaInicial2);
			fecha2.getValue();//Necesario para que se muestre el valor en el combo 
		}
	
		var setearFecha3 = function(){
			fecha3.setValue(fechaInicial3);
			fecha3.getValue();//Necesario para que se muestre el valor en el combo 
		}
	
		fecha1Store.on('load',setearFecha1);
		fecha2Store.on('load',setearFecha2);
		fecha3Store.on('load',setearFecha3);
	
		fecha1Store.webflow({idPersona:${persona.id}});
		
		var cargaInicial = function(){
			if(fechaInicial1!=''){
				cirbeGrid.store.load({params:{
					idPersona:${persona.id}
					,fecha1:fechaInicial1
					,fecha2:fechaInicial2
					,fecha3:fechaInicial3
			     }});
			}
		}
		
		var mostrarGrid = function(){
			if(fechaInicial1!=''){
				cirbeGrid.show();
				panel.doLayout();
			}
		}
	
		//cargaInicial();	
	
		panel.add(panelFiltros);
		panel.add(cirbeGrid);
	
		cargaInicial();
	});
	
	return panel;
})()
