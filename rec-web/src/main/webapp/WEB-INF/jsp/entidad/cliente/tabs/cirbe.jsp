<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad) {


	var panel = new Ext.Panel({
		title: '<s:message code="cirbe.titulo" text="**CIRBE" />'
		,autoHeight: true
		,autoWidth: true
		,bodyStyle: 'padding:10px'
		,layout: 'table'
		,layoutConfig: {columns:1}
		,nombreTab : 'cirbePanel'
	});

		var fechaInicial1 = '<fwk:date value="${fechaCirbeActual}"/>';
		var fechaInicial2 = '<fwk:date value="${fechaCirbe30Dias}"/>';
		var fechaInicial3 = '<fwk:date value="${fechaCirbe60Dias}"/>';
	
		var fechaRecord = Ext.data.Record.create([
			 {name:'codigo'}
			,{name:'descripcion'}
		]);

      function getStore(flow, storeId){
         return page.getStore({
		    flow: flow
		    ,storeId :storeId 
		    ,reader: new Ext.data.JsonReader({
		    	 root : 'diccionario'
		    }, fechaRecord)
		   });
      }

      function combo(store, label, name, disabled){
         return new Ext.form.ComboBox({
                 store:store
                 ,displayField:'descripcion'
                 ,valueField:'codigo'
                 ,forceSelection:true
                 ,mode: 'remote'
                 ,triggerAction: 'all'
                 ,editable: false
                 ,disabled:disabled
                 ,fieldLabel: label
                 ,name:name
              });
      }
	
		var fecha1Store = getStore('clientes/buscarFechasCirbe' , 'fecha1Store');
		var fecha1 = combo(fecha1Store, '<s:message code="cirbe.filtro.fecha1" text="**Desde" />' , 'fecha1', false);
		var fecha2Store = getStore( 'clientes/buscarFechasCirbe' , 'fecha2Store');
		var fecha2 = combo(fecha2Store,'<s:message code="cirbe.filtro.fecha2" text="**Hasta" />' , 'fecha2',true);
		var fecha3Store = getStore( 'clientes/buscarFechasCirbe' , 'fecha3Store');
		var fecha3 = combo(fecha3Store ,'<s:message code="cirbe.filtro.fecha3" text="**Hasta" />' , 'fecha3',true);
	
		var btnBuscar = app.crearBotonBuscar({ });
	
		var recargarCombo1 = function(){
			fechaInicial1 = fecha1.getValue();
			fecha1Store.webflow({idPersona:panel.getPersonaId(),fecha2:fecha2.getValue(), fecha3:fecha3.getValue()});
			
		}
	
		var recargarCombo2 = function(){
			fechaInicial2 = fecha2.getValue();
			fecha2Store.webflow({idPersona:panel.getPersonaId(),fecha1:fecha1.getValue(), fecha3:fecha3.getValue()});
		}
		
		var recargarCombo3 = function(){
			fechaInicial3 = fecha3.getValue();
			fecha3Store.webflow({idPersona:panel.getPersonaId(),fecha1:fecha1.getValue(), fecha2:fecha2.getValue()});
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
						if (!cirbeGrid.handlerSetted){
							cirbeGrid.handlerSetted=true;
  				    cirbeGrid.store.on("load", function(store,records,opts){
							    var data = entidad.get("data");
									entidad.put("cirbeStore", store.getRange());
							});
						}
						cirbeGrid.store.load({params:{
								idPersona:panel.getPersonaId()
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
	
		/*fecha1Store.webflow({idPersona:${persona.id}});*/
		
		
		var mostrarGrid = function(){
			if(fechaInicial1!=''){
				cirbeGrid.show();
				panel.doLayout();
			}
		}
	
	
		panel.add(panelFiltros);
		panel.add(cirbeGrid);

		entidad.cacheStore(cirbeGrid.getStore());
		entidad.cacheStore(fecha1.getStore());
	

	panel.getPersonaId = function(){
      var data = entidad.get("data");
      return data.id;
   }

   
	panel.getValue = function(){
        return {
		  fecha1 : fecha1.getValue()
		  ,fecha2 : fecha2.getValue()
		  ,fecha3 : fecha3.getValue()
        }
	}
   
	panel.setValue = function(){
		var data = entidad.get("data");
		var state = entidad.get("state") || {};
		fecha1.setValue();
		fecha2.setValue();
		fecha3.setValue();
		if (state.fecha1){
			fecha1.setValue(state.fecha1);
		}else{
			entidad.cacheOrLoad(data,fecha1.getStore(), {idPersona:data.id});
		}
		if (state.fecha2){
			fecha2.setValue(state.fecha2);
		}
		if (state.fecha3){
			fecha3.setValue(state.fecha3);
		}
		//entidad.cacheOrLoad(data,cirbeGrid.getStore(), {idPersona:data.id});

		if (data.cirbe.fechaInicial1!=''){
			cirbeGrid.store.load({params:{
				idPersona:panel.getPersonaId()
				,fecha1:data.cirbe.fechaInicial1
				,fecha2:data.cirbe.fechaInicial2
				,fecha3:data.cirbe.fechaInicial3
			}});
		}

		cirbeGrid.getStore().removeAll();
		if (entidad.get("cirbeStore")){
			cirbeGrid.getStore().add( entidad.get("cirbeStore") );
		}
	}
	
	return panel;
})
