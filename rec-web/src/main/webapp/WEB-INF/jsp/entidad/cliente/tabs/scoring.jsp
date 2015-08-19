<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad) {

	var panel = new Ext.Panel({
		title: '<s:message code="scoring.titulo" text="**Scoring" />'
		,height: 445
		,autoWidth: true
		,bodyStyle: 'padding:10px'
		,layout: 'table'
		,layoutConfig: {columns:1}
		,nombreTab : 'scoringPanel'
	});

	var fechaRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);

	var fechaStore = page.getStore({
	    flow: 'clientes/fechasScoringData'
       ,storeId : 'fechaStoreId'
	    ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, fechaRecord)
	});

	var fechaCombo = new Ext.form.ComboBox({
		store:fechaStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,forceSelection:true
		,mode: 'local'
		,triggerAction: 'all'
		,editable: false
		,fieldLabel: '<s:message code="cirbe.filtro.desde" text="**Desde" />'
		,name: 'fecha'
	});

		
	labelFecha = new Ext.form.Label({
	   	text:'<s:message code="scoring.filtro.fecha" text="**Fecha" />'+':'
		,style:'font-size:11;padding:15px;font-weight:bolder;'
	});

	var btnAgregar = new Ext.Button({
		text : '<s:message code="scoring.filtro.boton.agregar" text="**Añadir nueva fecha" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
      ,handler:function() {
      		debugger;
			if(fechaCombo.getValue()===''){ 
					Ext.Msg.show({
					   title: fwk.constant.errorMsg
					   ,msg: "<s:message code="scoring.filtro.fecha.error" text="**Debe seleccionar una fecha para agregar." />"
						   ,buttons: Ext.Msg.OK
						   ,animEl: 'elId'
						   ,icon: Ext.MessageBox.ERROR
						});
			} else {
					//panel.doLayout();
               var fechasString=panel.getFechasString();
					if (fechasString != ''){
						fechasString += ',';
					}
					fechasString += fechaCombo.getValue();
					panel.scoringGrid.store.load({params:{
							idPersona:panel.getPersonaId()
							,fechas:fechasString
					}});
					fechaStore.webflow({idPersona:panel.getPersonaId(),fechas:panel.getFechasString()});
				}
    	  }
	  });

	panel.scoringGrid = new Ext.ux.DynamicGridPanel({
	    storeUrl: '../clientes/scoringData.htm'
	    ,height: 300
	    ,collapsible: true
	});
	
	var leyenda = new Ext.form.Label({
                text: "<s:message code="scoring.leyenda" text="***Las fechas son aproximaciones calculadas a partir de las alertas cargadas en el sistema." />"
                ,style: "color:red;font-size:12px;"
    });
	
	var panelFiltro = new Ext.form.FieldSet({
		title: '<s:message code="scoring.filtro.fechas" text="**Fechas" />'
		,autoHeight: true
		,autoWidth: true
		,bodyStyle: 'padding:7px;'
		,layout: 'table'
		,layoutConfig: {columns:3}
		,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
		,items: [
			{items:[labelFecha],border:false,style:'margin-left:5px'}
			,{items:[fechaCombo],border:false}
			,{items:[btnAgregar],border:false,style:'margin-left:20px;margin-right:40px'}
		   ]
	});


   entidad.cacheStore(panel.scoringGrid.getStore());
   entidad.cacheStore(fechaCombo.getStore());

	panel.add(panelFiltro);
	panel.add(panel.scoringGrid);
	panel.add(leyenda);

	panel.getFechasString = function(){
		var data = entidad.get("data");
		return data.scoring.fechasAlertas;
	}

	panel.getPersonaId = function(){
		var data = entidad.get("data");
		return data.id;
	}

	panel.getValue = function(){}

	panel.setValue = function(){
		var data = entidad.get("data");
		panel.scoringGrid.getStore().removeAll();
		panel.scoringGrid.colModel.setConfig([],false);
		fechaCombo.clearValue();
		//entidad.cacheStore(panel.scoringGrid.getStore());
		//entidad.cacheOrLoad(data, panel.scoringGrid.getStore(), { idPersona : data.id } );
		entidad.cacheOrLoad(data, fechaCombo.getStore(), { idPersona : data.id, fechas : data.scoring.fechasAlertas } );
	}

	return panel;
})
